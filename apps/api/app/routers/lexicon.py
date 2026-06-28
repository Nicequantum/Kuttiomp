from uuid import UUID

from fastapi import APIRouter, HTTPException, Query

from app.database import get_supabase
from app.models.schemas import (
    LexicalEntryCreate,
    LexicalEntryResponse,
    LexicalEntryUpdate,
)

router = APIRouter(prefix="/lexicon", tags=["Lexicon"])


@router.get("", response_model=list[LexicalEntryResponse])
async def list_lexical_entries(
    search: str | None = None,
    category: str | None = None,
    visibility: str | None = None,
    speaker_id: UUID | None = None,
    limit: int = Query(default=50, le=200),
    offset: int = 0,
):
    supabase = get_supabase()
    query = supabase.table("lexical_entries").select("*")

    if search:
        query = query.or_(
            f"word_narragansett.ilike.%{search}%,"
            f"english_gloss.ilike.%{search}%,"
            f"word_normalized.ilike.%{search}%"
        )
    if category:
        query = query.eq("category", category)
    if visibility:
        query = query.eq("visibility", visibility)
    if speaker_id:
        query = query.eq("primary_speaker_id", str(speaker_id))

    result = (
        query.order("word_narragansett")
        .range(offset, offset + limit - 1)
        .execute()
    )
    return result.data or []


@router.get("/{entry_id}", response_model=LexicalEntryResponse)
async def get_lexical_entry(entry_id: UUID):
    supabase = get_supabase()
    result = (
        supabase.table("lexical_entries")
        .select("*")
        .eq("id", str(entry_id))
        .single()
        .execute()
    )
    if not result.data:
        raise HTTPException(status_code=404, detail="Lexical entry not found")
    return result.data


@router.post("", response_model=LexicalEntryResponse, status_code=201)
async def create_lexical_entry(entry: LexicalEntryCreate):
    supabase = get_supabase()
    data = entry.model_dump()
    for field in ("domain_id", "primary_speaker_id", "created_by"):
        if data.get(field):
            data[field] = str(data[field])

    if data.get("is_sacred"):
        data["approval_status"] = "requires_elder_review"
    else:
        data["approval_status"] = "pending"

    result = supabase.table("lexical_entries").insert(data).execute()
    return result.data[0]


@router.patch("/{entry_id}", response_model=LexicalEntryResponse)
async def update_lexical_entry(entry_id: UUID, update: LexicalEntryUpdate):
    supabase = get_supabase()
    data = update.model_dump(exclude_unset=True)
    if "primary_speaker_id" in data and data["primary_speaker_id"]:
        data["primary_speaker_id"] = str(data["primary_speaker_id"])

    result = (
        supabase.table("lexical_entries")
        .update(data)
        .eq("id", str(entry_id))
        .execute()
    )
    if not result.data:
        raise HTTPException(status_code=404, detail="Lexical entry not found")
    return result.data[0]


@router.get("/{entry_id}/pronunciations")
async def get_pronunciation_variants(entry_id: UUID):
    supabase = get_supabase()
    result = (
        supabase.table("pronunciation_variants")
        .select("*, speakers(display_name, role)")
        .eq("lexical_entry_id", str(entry_id))
        .execute()
    )
    return result.data or []


@router.get("/{entry_id}/audio")
async def get_entry_audio(entry_id: UUID):
    supabase = get_supabase()
    result = (
        supabase.table("audio_recordings")
        .select("*, speakers(display_name, role)")
        .eq("lexical_entry_id", str(entry_id))
        .eq("approval_status", "approved")
        .order("is_primary_recording", desc=True)
        .execute()
    )
    return result.data or []