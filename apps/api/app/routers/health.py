from fastapi import APIRouter

from app.services.health import get_health

router = APIRouter(tags=["Health"])


@router.get("/health", summary="Health check with database status")
async def health_check():
    return await get_health()