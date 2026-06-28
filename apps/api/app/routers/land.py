from uuid import UUID

from fastapi import APIRouter, HTTPException, Query

from app.database import get_supabase

router = APIRouter(prefix="/land", tags=["Land Knowledge"])


@router.get("/sites")
async def list_land_sites(
    site_type: str | None = None,
    limit: int = Query(default=100, le=500),
):
    supabase = get_supabase()
    query = supabase.table("land_knowledge_sites").select(
        "id, name_narragansett, name_english, description, site_type, "
        "elevation_meters, ecological_zone, cultural_significance, "
        "seasonal_relevance, visibility, approval_status, speaker_id, "
        "created_at, location"
    )
    if site_type:
        query = query.eq("site_type", site_type)
    result = query.order("name_narragansett").limit(limit).execute()
    return result.data or []


@router.get("/sites/{site_id}")
async def get_land_site(site_id: UUID):
    supabase = get_supabase()
    result = (
        supabase.table("land_knowledge_sites")
        .select("*, speakers(display_name, role)")
        .eq("id", str(site_id))
        .single()
        .execute()
    )
    if not result.data:
        raise HTTPException(status_code=404, detail="Land site not found")
    return result.data


@router.get("/sites/{site_id}/lexical")
async def get_site_lexical_entries(site_id: UUID):
    supabase = get_supabase()
    result = (
        supabase.table("lexical_land_links")
        .select("*, lexical_entries(word_narragansett, english_gloss, semantic_domain)")
        .eq("land_site_id", str(site_id))
        .execute()
    )
    return result.data or []


@router.post("/sites", status_code=201)
async def create_land_site(payload: dict):
    supabase = get_supabase()
    lat = payload.pop("latitude", None)
    lng = payload.pop("longitude", None)
    if lat is not None and lng is not None:
        payload["location"] = f"POINT({lng} {lat})"
    if payload.get("speaker_id"):
        payload["speaker_id"] = str(payload["speaker_id"])
    payload.setdefault("approval_status", "pending")
    result = supabase.table("land_knowledge_sites").insert(payload).execute()
    return result.data[0]