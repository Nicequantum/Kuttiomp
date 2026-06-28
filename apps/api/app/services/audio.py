import uuid
from datetime import datetime

from fastapi import UploadFile

from app.config import settings
from app.database import get_supabase


async def upload_audio(
    file: UploadFile,
    speaker_id: str,
    lexical_entry_id: str | None = None,
    recorded_by: str | None = None,
    recording_context: str | None = None,
    quality: str = "field",
    visibility: str = "clan",
) -> dict:
    """Upload audio file to Supabase storage and create recording record."""
    supabase = get_supabase()

    file_ext = file.filename.split(".")[-1] if file.filename else "webm"
    storage_path = f"{speaker_id}/{uuid.uuid4()}.{file_ext}"
    content = await file.read()

    supabase.storage.from_(settings.audio_storage_bucket).upload(
        path=storage_path,
        file=content,
        file_options={"content-type": file.content_type or "audio/webm"},
    )

    recording_data = {
        "lexical_entry_id": lexical_entry_id,
        "speaker_id": speaker_id,
        "recorded_by": recorded_by,
        "storage_path": storage_path,
        "storage_bucket": settings.audio_storage_bucket,
        "file_format": file_ext,
        "quality": quality,
        "recording_context": recording_context,
        "visibility": visibility,
        "approval_status": "pending",
    }

    result = supabase.table("audio_recordings").insert(recording_data).execute()
    recording = result.data[0]

    try:
        public_url = supabase.storage.from_(settings.audio_storage_bucket).get_public_url(
            storage_path
        )
    except Exception:
        public_url = None

    return {"recording": recording, "public_url": public_url}


def get_speaker_recordings(speaker_id: str, limit: int = 50) -> list[dict]:
    supabase = get_supabase()
    result = (
        supabase.table("audio_recordings")
        .select("*, speakers(display_name, role), lexical_entries(word_narragansett, english_gloss)")
        .eq("speaker_id", speaker_id)
        .order("created_at", desc=True)
        .limit(limit)
        .execute()
    )
    return result.data or []


def approve_recording(recording_id: str, approved_by: str) -> dict:
    supabase = get_supabase()
    result = (
        supabase.table("audio_recordings")
        .update(
            {
                "approval_status": "approved",
                "approved_by": approved_by,
                "approved_at": datetime.utcnow().isoformat(),
            }
        )
        .eq("id", recording_id)
        .execute()
    )
    return result.data[0] if result.data else {}