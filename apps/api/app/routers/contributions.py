from datetime import datetime
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel, Field

from app.auth import Actor, require_identity
from app.database import get_supabase

router = APIRouter(
    prefix="/contributions",
    tags=["Knowledge Contributions"],
    dependencies=[Depends(require_identity)],
)


class ContributionReviewRequest(BaseModel):
    status: str
    review_notes: str | None = None
    reviewed_by: UUID | None = Field(
        default=None,
        description="Ignored. Reviewer is taken from the verified token.",
    )


@router.get("")
async def list_contributions(
    status: str | None = None,
    contributor_id: UUID | None = None,
    limit: int = Query(default=50, le=200),
):
    supabase = get_supabase()
    query = supabase.table("knowledge_contributions").select(
        "*, contributor:speakers!contributor_speaker_id(display_name, role, cultural_authority), "
        "reviewer:speakers!reviewed_by(display_name)"
    )
    if status:
        query = query.eq("status", status)
    if contributor_id:
        query = query.eq("contributor_speaker_id", str(contributor_id))
    result = query.order("created_at", desc=True).limit(limit).execute()
    return result.data or []


@router.post("", status_code=201)
async def submit_contribution(payload: dict):
    supabase = get_supabase()
    payload["contributor_speaker_id"] = str(payload["contributor_speaker_id"])
    payload.setdefault("status", "draft")
    payload.setdefault("protocol_acknowledgments", [1, 2, 3, 4, 5])
    result = supabase.table("knowledge_contributions").insert(payload).execute()
    return result.data[0]


@router.post("/{contribution_id}/submit")
async def submit_for_review(contribution_id: UUID):
    supabase = get_supabase()
    result = (
        supabase.table("knowledge_contributions")
        .update({"status": "pending", "updated_at": datetime.utcnow().isoformat()})
        .eq("id", str(contribution_id))
        .execute()
    )
    if not result.data:
        raise HTTPException(status_code=404, detail="Contribution not found")
    return result.data[0]


@router.post("/{contribution_id}/review")
async def review_contribution(
    contribution_id: UUID,
    payload: ContributionReviewRequest,
    actor: Actor = Depends(require_identity),
):
    valid = {"approved", "rejected", "under_review", "requires_elder_review"}
    if payload.status not in valid:
        raise HTTPException(status_code=400, detail=f"status must be one of: {valid}")
    reviewer_id = actor.require_speaker_id()
    supabase = get_supabase()
    result = (
        supabase.table("knowledge_contributions")
        .update({
            "status": payload.status,
            "reviewed_by": str(reviewer_id),
            "reviewed_at": datetime.utcnow().isoformat(),
            "review_notes": payload.review_notes,
        })
        .eq("id", str(contribution_id))
        .execute()
    )
    if not result.data:
        raise HTTPException(status_code=404, detail="Contribution not found")
    return result.data[0]


@router.get("/pending")
async def pending_contributions():
    supabase = get_supabase()
    result = (
        supabase.table("knowledge_contributions")
        .select("*, contributor:speakers!contributor_speaker_id(display_name, role)")
        .in_("status", ["pending", "under_review", "requires_elder_review"])
        .order("created_at")
        .execute()
    )
    return result.data or []