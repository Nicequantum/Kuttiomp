from uuid import UUID

from fastapi import APIRouter, HTTPException, Query

from app.database import get_supabase

router = APIRouter(prefix="/cultural", tags=["Cultural Knowledge"])


@router.get("/contexts")
async def list_cultural_contexts(
    lexical_entry_id: UUID | None = None,
    context_type: str | None = None,
    limit: int = Query(default=50, le=200),
):
    supabase = get_supabase()
    query = supabase.table("cultural_contexts").select(
        "*, speakers(display_name, role), lexical_entries(word_narragansett)"
    )
    if lexical_entry_id:
        query = query.eq("lexical_entry_id", str(lexical_entry_id))
    if context_type:
        query = query.eq("context_type", context_type)
    result = query.order("created_at", desc=True).limit(limit).execute()
    return result.data or []


@router.get("/contexts/{context_id}")
async def get_cultural_context(context_id: UUID):
    supabase = get_supabase()
    result = (
        supabase.table("cultural_contexts")
        .select("*, speakers(display_name), lexical_entries(word_narragansett, english_gloss)")
        .eq("id", str(context_id))
        .single()
        .execute()
    )
    if not result.data:
        raise HTTPException(status_code=404, detail="Cultural context not found")
    return result.data


@router.post("/contexts", status_code=201)
async def create_cultural_context(payload: dict):
    supabase = get_supabase()
    if payload.get("lexical_entry_id"):
        payload["lexical_entry_id"] = str(payload["lexical_entry_id"])
    if payload.get("speaker_id"):
        payload["speaker_id"] = str(payload["speaker_id"])
    payload.setdefault("approval_status", "pending")
    result = supabase.table("cultural_contexts").insert(payload).execute()
    return result.data[0]


@router.get("/narratives")
async def list_narratives(limit: int = Query(default=50, le=100)):
    supabase = get_supabase()
    result = (
        supabase.table("cultural_narratives")
        .select("*, speakers(display_name, role)")
        .order("title_english")
        .limit(limit)
        .execute()
    )
    return result.data or []


@router.get("/narratives/{narrative_id}/lexical-links")
async def get_narrative_lexical_links(narrative_id: UUID):
    supabase = get_supabase()
    result = (
        supabase.table("lexical_narrative_links")
        .select("*, lexical_entries(word_narragansett, english_gloss)")
        .eq("narrative_id", str(narrative_id))
        .execute()
    )
    return result.data or []