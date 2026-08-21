"""Health check service with database connectivity verification."""

from app.config import settings
from app.database import get_supabase

API_VERSION = "0.4.0"
EXPECTED_MIGRATION = "004"


async def check_database() -> dict:
    if not settings.supabase_service_configured:
        return {
            "status": "not_configured",
            "provider": "supabase",
            "speakers_accessible": False,
        }
    try:
        supabase = get_supabase()
        result = supabase.table("speakers").select("id", count="exact").limit(1).execute()
        speaker_count = result.count if result.count is not None else len(result.data or [])

        migration_version = None
        try:
            mv = supabase.table("schema_migrations").select("version").execute()
            if mv.data:
                # Match foundation_status view: MAX(version), not latest applied_at.
                # Batch-inserted rows (migration 004) share the same applied_at.
                migration_version = max(row["version"] for row in mv.data)
        except Exception:
            migration_version = "unknown"

        return {
            "status": "connected",
            "provider": "supabase",
            "speakers_accessible": True,
            "speaker_count": speaker_count,
            "migration_version": migration_version,
            "expected_migration": EXPECTED_MIGRATION,
            "migrations_current": migration_version == EXPECTED_MIGRATION,
        }
    except Exception as exc:
        return {
            "status": "error",
            "provider": "supabase",
            "message": str(exc),
            "speakers_accessible": False,
        }


async def get_health() -> dict:
    db = await check_database()
    overall = "healthy" if db.get("status") == "connected" else "degraded"

    return {
        "status": overall,
        "service": "kuttiomp-api",
        "version": API_VERSION,
        "cultural_protocols": 12,
        "database": db,
        "grok_configured": settings.grok_configured,
        "integrations": settings.integration_flags(),
    }


def grok_service_is_configured() -> bool:
    return settings.grok_configured