from uuid import UUID

from fastapi import APIRouter, File, Form, HTTPException, UploadFile

from app.models.schemas import AudioUploadResponse
from app.services.audio import approve_recording, upload_audio

router = APIRouter(prefix="/audio", tags=["Audio"])


@router.post("/upload", response_model=AudioUploadResponse, status_code=201)
async def upload_audio_recording(
    file: UploadFile = File(...),
    speaker_id: str = Form(...),
    lexical_entry_id: str | None = Form(None),
    recorded_by: str | None = Form(None),
    recording_context: str | None = Form(None),
    quality: str = Form("field"),
    visibility: str = Form("clan"),
):
    if not file.content_type or not file.content_type.startswith("audio/"):
        raise HTTPException(status_code=400, detail="File must be an audio recording")

    result = await upload_audio(
        file=file,
        speaker_id=speaker_id,
        lexical_entry_id=lexical_entry_id,
        recorded_by=recorded_by,
        recording_context=recording_context,
        quality=quality,
        visibility=visibility,
    )
    return result


@router.post("/{recording_id}/approve")
async def approve_audio_recording(recording_id: UUID, approved_by: UUID):
    result = approve_recording(str(recording_id), str(approved_by))
    if not result:
        raise HTTPException(status_code=404, detail="Recording not found")
    return result


@router.get("/pending")
async def list_pending_recordings():
    from app.database import get_supabase

    supabase = get_supabase()
    result = (
        supabase.table("audio_recordings")
        .select("*, speakers(display_name, role), lexical_entries(word_narragansett)")
        .eq("approval_status", "pending")
        .order("created_at", desc=True)
        .execute()
    )
    return result.data or []