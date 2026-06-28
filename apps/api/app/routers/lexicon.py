from uuid import UUID

from fastapi import APIRouter, Query

from app.exceptions import NotFoundError, SacredContentError
from app.models.lexical_schemas import (
    LexicalEntryCreateV2,
    LexicalEntryResponseV2,
    LexicalEntryUpdateV2,
)
from app.database import get_supabase
from app.services.lexical import create_lexical_entry, get_lexical_entry, update_lexical_entry

router = APIRouter(
    prefix="/lexicon",
    tags=["Lexicon"],
    responses={
        404: {"description": "Lexical entry not found"},
        422: {"description": "Validation error"},
        403: {"description": "Sacred content restricted"},
    },
)


def _filter_sacred(entries: list[dict], include_sacred: bool = False) -> list[dict]:
    if include_sacred:
        return entries
    return [
        e for e in entries
        if not e.get("is_sacred") and e.get("visibility") != "sacred"
    ]


@router.get(
    "",
    response_model=list[LexicalEntryResponseV2],
    summary="List lexical entries",
    description="Search and filter Narragansett lexical entries. Sacred content excluded by default.",
)
async def list_lexical_entries(
    search: str | None = Query(None, description="Search Narragansett or English"),
    category: str | None = None,
    semantic_domain: str | None = None,
    visibility: str | None = None,
    speaker_id: UUID | None = None,
    include_sacred: bool = Query(False, description="Include sacred entries (elders only)"),
    limit: int = Query(default=50, ge=1, le=200),
    offset: int = Query(default=0, ge=0),
):
    supabase = get_supabase()
    query = supabase.table("lexical_entries").select("*")

    if search:
        safe = search.replace("%", "").replace(",", "")
        query = query.or_(
            f"word_narragansett.ilike.%{safe}%,"
            f"english_gloss.ilike.%{safe}%,"
            f"word_normalized.ilike.%{safe}%"
        )
    if category:
        query = query.eq("category", category)
    if semantic_domain:
        query = query.eq("semantic_domain", semantic_domain)
    if visibility:
        query = query.eq("visibility", visibility)
    if speaker_id:
        query = query.eq("primary_speaker_id", str(speaker_id))

    result = query.order("word_narragansett").range(offset, offset + limit - 1).execute()
    return _filter_sacred(result.data or [], include_sacred)


@router.get(
    "/{entry_id}",
    response_model=LexicalEntryResponseV2,
    summary="Get lexical entry by ID",
)
async def get_entry(entry_id: UUID, include_sacred: bool = False):
    entry = get_lexical_entry(entry_id)
    if not include_sacred and (entry.get("is_sacred") or entry.get("visibility") == "sacred"):
        raise SacredContentError()
    return entry


@router.post(
    "",
    response_model=LexicalEntryResponseV2,
    status_code=201,
    summary="Create lexical entry",
    description="Create a full lexical entry with optional spelling variants, example sentences, and cultural contexts.",
)
async def create_entry(entry: LexicalEntryCreateV2):
    return create_lexical_entry(entry)


@router.patch(
    "/{entry_id}",
    response_model=LexicalEntryResponseV2,
    summary="Update lexical entry",
)
async def patch_entry(entry_id: UUID, update: LexicalEntryUpdateV2):
    return update_lexical_entry(entry_id, update)


@router.get("/{entry_id}/pronunciations", summary="Pronunciation variants by speaker")
async def get_pronunciation_variants(entry_id: UUID):
    supabase = get_supabase()
    result = (
        supabase.table("pronunciation_variants")
        .select("*, speakers(display_name, role)")
        .eq("lexical_entry_id", str(entry_id))
        .execute()
    )
    return result.data or []


@router.get("/{entry_id}/spellings", summary="Orthographic spelling variants")
async def get_spelling_variants(entry_id: UUID):
    supabase = get_supabase()
    result = (
        supabase.table("spelling_variants")
        .select("*, orthographies(name, system_key)")
        .eq("lexical_entry_id", str(entry_id))
        .execute()
    )
    return result.data or []


@router.get("/{entry_id}/examples", summary="Example sentences")
async def get_example_sentences(entry_id: UUID):
    supabase = get_supabase()
    result = (
        supabase.table("example_sentences")
        .select("*, speakers(display_name)")
        .eq("lexical_entry_id", str(entry_id))
        .execute()
    )
    return result.data or []


@router.get("/{entry_id}/cultural-contexts", summary="Linked cultural contexts")
async def get_entry_cultural_contexts(entry_id: UUID):
    supabase = get_supabase()
    result = (
        supabase.table("cultural_contexts")
        .select("*")
        .eq("lexical_entry_id", str(entry_id))
        .execute()
    )
    return result.data or []


@router.get("/{entry_id}/audio", summary="Approved audio recordings")
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