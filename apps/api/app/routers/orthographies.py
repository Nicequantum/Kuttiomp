from fastapi import APIRouter

from app.database import get_supabase

router = APIRouter(prefix="/orthographies", tags=["Orthographies"])


@router.get("")
async def list_orthographies():
    supabase = get_supabase()
    result = supabase.table("orthographies").select("*").order("is_primary", desc=True).execute()
    return result.data or []


@router.get("/{entry_id}/spellings")
async def get_entry_spellings(entry_id: str):
    supabase = get_supabase()
    result = (
        supabase.table("spelling_variants")
        .select("*, orthographies(name, system_key), speakers(display_name)")
        .eq("lexical_entry_id", entry_id)
        .execute()
    )
    return result.data or []