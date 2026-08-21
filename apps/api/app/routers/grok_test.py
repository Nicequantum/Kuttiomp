from fastapi import APIRouter, Depends, HTTPException

from app.auth import require_keeper
from app.services.grok_service import grok_service

router = APIRouter(
    prefix="/api/grok",
    tags=["Grok API"],
    dependencies=[Depends(require_keeper)],
)


@router.get(
    "/test",
    summary="Test Grok API connection",
    description="Confirms GROK_API_KEY is configured and the xAI API is reachable.",
)
async def test_grok_connection():
    grok_service.require_configured()
    try:
        return await grok_service.test_connection()
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(
            status_code=502,
            detail=f"Grok API connection failed: {exc}",
        ) from exc