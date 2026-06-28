from uuid import UUID

from fastapi import APIRouter, HTTPException

from app.database import get_supabase
from app.models.schemas import ClanCreate, ClanResponse

router = APIRouter(prefix="/clans", tags=["Clans"])


@router.get("", response_model=list[ClanResponse])
async def list_clans():
    supabase = get_supabase()
    result = supabase.table("clans").select("*").order("name_narragansett").execute()
    return result.data or []


@router.get("/{clan_id}", response_model=ClanResponse)
async def get_clan(clan_id: UUID):
    supabase = get_supabase()
    result = supabase.table("clans").select("*").eq("id", str(clan_id)).single().execute()
    if not result.data:
        raise HTTPException(status_code=404, detail="Clan not found")
    return result.data


@router.post("", response_model=ClanResponse, status_code=201)
async def create_clan(clan: ClanCreate):
    supabase = get_supabase()
    result = supabase.table("clans").insert(clan.model_dump()).execute()
    return result.data[0]


@router.get("/{clan_id}/speakers")
async def get_clan_speakers(clan_id: UUID):
    supabase = get_supabase()
    result = (
        supabase.table("speakers")
        .select("*")
        .eq("clan_id", str(clan_id))
        .eq("is_active", True)
        .order("generation")
        .order("role")
        .execute()
    )
    return result.data or []