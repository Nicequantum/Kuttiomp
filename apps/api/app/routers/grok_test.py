from fastapi import APIRouter, HTTPException

from app.services.grok_service import grok_service

router = APIRouter(prefix="/api/grok", tags=["Grok API"])


@router.get(
    "/test",
    summary="Test Grok API connection",
    description="Confirms GROK_API_KEY is configured and the xAI API is reachable.",
)
async def test_grok_connection():
    if not grok_service.is_configured():
        raise HTTPException(
            status_code=503,
            detail="GROK_API_KEY is not configured. Set it in apps/api/.env",
        )
    try:
        return await grok_service.test_connection()
    except Exception as exc:
        raise HTTPException(
            status_code=502,
            detail=f"Grok API connection failed: {exc}",
        ) from exc