from uuid import UUID

from fastapi import APIRouter, HTTPException, Query

from app.database import get_supabase
from app.models.schemas import (
    SpeakerCreate,
    SpeakerResponse,
    SpeakerTreeNode,
    SpeakerUpdate,
)

router = APIRouter(prefix="/speakers", tags=["Speakers"])


@router.get("", response_model=list[SpeakerResponse])
async def list_speakers(
    role: str | None = None,
    clan_id: UUID | None = None,
    is_elder: bool | None = None,
    is_active: bool = True,
):
    supabase = get_supabase()
    query = supabase.table("speakers").select("*")

    if is_active:
        query = query.eq("is_active", True)
    if role:
        query = query.eq("role", role)
    if clan_id:
        query = query.eq("clan_id", str(clan_id))
    if is_elder is not None:
        query = query.eq("is_elder", is_elder)

    result = query.order("generation").order("display_name").execute()
    return result.data or []


@router.get("/tree", response_model=list[SpeakerTreeNode])
async def get_speaker_tree(clan_id: UUID | None = None):
    """Return hierarchical speaker tree by parent_speaker_id relationships."""
    supabase = get_supabase()
    query = supabase.table("speakers").select("*").eq("is_active", True)
    if clan_id:
        query = query.eq("clan_id", str(clan_id))
    result = query.execute()
    speakers = result.data or []

    by_id = {s["id"]: {**s, "children": []} for s in speakers}
    roots = []

    for speaker in speakers:
        node = by_id[speaker["id"]]
        parent_id = speaker.get("parent_speaker_id")
        if parent_id and parent_id in by_id:
            by_id[parent_id]["children"].append(node)
        else:
            roots.append(node)

    return roots


@router.get("/{speaker_id}", response_model=SpeakerResponse)
async def get_speaker(speaker_id: UUID):
    supabase = get_supabase()
    result = (
        supabase.table("speakers").select("*").eq("id", str(speaker_id)).single().execute()
    )
    if not result.data:
        raise HTTPException(status_code=404, detail="Speaker not found")
    return result.data


@router.post("", response_model=SpeakerResponse, status_code=201)
async def create_speaker(speaker: SpeakerCreate):
    supabase = get_supabase()
    data = speaker.model_dump()
    data["clan_id"] = str(data["clan_id"]) if data.get("clan_id") else None
    data["parent_speaker_id"] = (
        str(data["parent_speaker_id"]) if data.get("parent_speaker_id") else None
    )
    result = supabase.table("speakers").insert(data).execute()
    return result.data[0]


@router.patch("/{speaker_id}", response_model=SpeakerResponse)
async def update_speaker(speaker_id: UUID, update: SpeakerUpdate):
    supabase = get_supabase()
    data = update.model_dump(exclude_unset=True)
    if "clan_id" in data and data["clan_id"]:
        data["clan_id"] = str(data["clan_id"])
    if "parent_speaker_id" in data and data["parent_speaker_id"]:
        data["parent_speaker_id"] = str(data["parent_speaker_id"])

    result = (
        supabase.table("speakers")
        .update(data)
        .eq("id", str(speaker_id))
        .execute()
    )
    if not result.data:
        raise HTTPException(status_code=404, detail="Speaker not found")
    return result.data[0]


@router.get("/{speaker_id}/recordings")
async def get_speaker_recordings(
    speaker_id: UUID,
    limit: int = Query(default=50, le=100),
):
    from app.services.audio import get_speaker_recordings

    return get_speaker_recordings(str(speaker_id), limit)