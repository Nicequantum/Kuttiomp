"""Read-only public lexicon queries with a server-side publish gate."""

from datetime import datetime, timezone
from uuid import UUID

from app.config import settings
from app.database import get_anon_supabase, get_supabase
from app.exceptions import NotFoundError, ServiceUnavailableError
from app.models.public_schemas import PublicAudio, PublicWord

RESTRICTED_SPIRITUAL = frozenset({"ceremonial", "sacred", "restricted"})
ALLOWED_SPIRITUAL = ("none", "respectful")
PHRASE_CATEGORIES = frozenset({"phrase", "proverb"})
ENTRY_SELECT = "*, speakers!primary_speaker_id(display_name, role)"


def _utc_now_iso() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def _as_related(value) -> dict:
    if isinstance(value, list):
        return value[0] if value else {}
    return value or {}


def _iso(value) -> str | None:
    if value is None:
        return None
    if hasattr(value, "isoformat"):
        text = value.isoformat()
    else:
        text = str(value)
    if text.endswith("+00:00"):
        return text.replace("+00:00", "Z")
    return text


def _format_speaker(row: dict) -> tuple[str, str | None, str | None]:
    speaker = _as_related(row.get("speakers"))
    speaker_id = row.get("primary_speaker_id")
    name = (speaker.get("display_name") or "").strip()
    role = speaker.get("role") or None
    if name and role:
        attribution = f"{name} — {role}"
    elif name:
        attribution = name
    else:
        attribution = "Knowledge Keeper"
    return attribution, str(speaker_id) if speaker_id else None, role


def _audio_url(recording: dict) -> str | None:
    path = recording.get("storage_path")
    if not path:
        return None
    bucket = recording.get("storage_bucket") or settings.audio_storage_bucket
    try:
        # kuttiomp-audio is a private bucket; mint a short-lived signed URL.
        result = get_supabase().storage.from_(bucket).create_signed_url(
            path, settings.audio_signed_url_ttl_seconds
        )
        if isinstance(result, dict):
            return (
                result.get("signedURL")
                or result.get("signedUrl")
                or result.get("signed_url")
            )
        return None
    except Exception:
        return None


def _audio_payload(recording: dict | None) -> PublicAudio | None:
    if not recording:
        return None
    url = _audio_url(recording)
    if not url:
        return None
    speaker = _as_related(recording.get("speakers"))
    duration = recording.get("duration_seconds")
    duration_ms = int(float(duration) * 1000) if duration is not None else None
    file_format = recording.get("file_format") or "webm"
    return PublicAudio(
        url=url,
        contentType=f"audio/{file_format}",
        durationMs=duration_ms,
        speakerName=speaker.get("display_name"),
    )


def apply_publish_gate(query):
    """Restrict a lexical_entries query to learner-publishable rows."""
    return (
        query.eq("approval_status", "approved")
        .eq("visibility", "public")
        .eq("is_sacred", False)
        .in_("spiritual_significance", list(ALLOWED_SPIRITUAL))
        .neq("english_gloss", "")
    )


LEARNER_BLOCKED_VISIBILITY = frozenset({"sacred", "elders_only", "clan", "family"})


def is_publishable_row(row: dict) -> bool:
    gloss = (row.get("english_gloss") or "").strip()
    spiritual = row.get("spiritual_significance") or "none"
    visibility = row.get("visibility")
    return (
        row.get("approval_status") == "approved"
        and visibility == "public"
        and visibility not in LEARNER_BLOCKED_VISIBILITY
        and not row.get("is_sacred")
        and spiritual not in RESTRICTED_SPIRITUAL
        and bool(gloss)
    )


def to_public_word(row: dict, audio: dict | None = None) -> PublicWord:
    attribution, speaker_id, speaker_role = _format_speaker(row)
    category = row.get("category")
    tags = row.get("context_tags") or row.get("alternate_spellings") or None
    return PublicWord(
        id=str(row["id"]),
        wordNarragansett=row["word_narragansett"],
        wordNormalized=row.get("word_normalized"),
        englishGloss=(row.get("english_gloss") or "").strip(),
        category=category,
        semanticDomain=row.get("semantic_domain") or "other",
        seasonalUsage=row.get("seasonal_usage") or [],
        isPhrase=category in PHRASE_CATEGORIES,
        orthographyNote=row.get("usage_notes") or "",
        speakerAttribution=attribution,
        speakerId=speaker_id,
        speakerRole=speaker_role,
        elderApproved=True,
        isSacred=False,
        source="keeper_approved",
        authority="living_speaker",
        primaryAudio=_audio_payload(audio),
        tags=tags if tags else None,
        updatedAt=_iso(row.get("updated_at")),
    )


def _load_primary_audio(entry_ids: list[str]) -> dict[str, dict]:
    if not entry_ids:
        return {}
    # audio_recordings has no public SELECT policy; mint metadata only for
    # entries that already passed the publish gate, then sign the object.
    supabase = get_supabase()
    result = (
        supabase.table("audio_recordings")
        .select(
            "id, lexical_entry_id, storage_path, storage_bucket, file_format, "
            "duration_seconds, is_primary_recording, speakers(display_name)"
        )
        .in_("lexical_entry_id", entry_ids)
        .eq("approval_status", "approved")
        .order("is_primary_recording", desc=True)
        .execute()
    )
    by_entry: dict[str, dict] = {}
    for recording in result.data or []:
        entry_id = recording.get("lexical_entry_id")
        if entry_id and entry_id not in by_entry:
            by_entry[entry_id] = recording
    return by_entry


def _corpus_version(rows: list[dict]) -> str:
    stamps = [_iso(row.get("updated_at")) for row in rows if row.get("updated_at")]
    return max(stamps) if stamps else _utc_now_iso()


def get_public_health() -> dict:
    try:
        supabase = get_anon_supabase()
        result = apply_publish_gate(
            supabase.table("lexical_entries").select("id, updated_at", count="exact")
        ).order("updated_at", desc=True).limit(1).execute()
        rows = result.data or []
        return {
            "ok": True,
            "service": "kuttiomp-public",
            "corpusVersion": _corpus_version(rows),
            "wordCount": result.count if result.count is not None else len(rows),
        }
    except Exception:
        return {
            "ok": False,
            "service": "kuttiomp-public",
            "corpusVersion": _utc_now_iso(),
            "wordCount": 0,
        }


def list_public_words(
    limit: int,
    offset: int,
    domain: str | None = None,
    q: str | None = None,
) -> dict:
    supabase = get_anon_supabase()
    query = apply_publish_gate(
        supabase.table("lexical_entries").select(ENTRY_SELECT, count="exact")
    )
    if domain:
        query = query.eq("semantic_domain", domain)
    if q:
        safe = q.replace("%", "").replace(",", "").replace("(", "").replace(")", "")
        query = query.or_(
            f"word_narragansett.ilike.%{safe}%,"
            f"english_gloss.ilike.%{safe}%,"
            f"word_normalized.ilike.%{safe}%"
        )

    try:
        result = (
            query.order("updated_at", desc=True)
            .range(offset, offset + limit - 1)
            .execute()
        )
    except Exception as exc:
        raise ServiceUnavailableError(
            "Public lexicon is temporarily unavailable"
        ) from exc
    rows = [row for row in (result.data or []) if is_publishable_row(row)]
    audio_by_entry = _load_primary_audio([row["id"] for row in rows])
    words = [to_public_word(row, audio_by_entry.get(row["id"])) for row in rows]
    total = result.count if result.count is not None else len(words)
    return {
        "corpusVersion": _corpus_version(rows),
        "total": total,
        "limit": limit,
        "offset": offset,
        "words": words,
    }


def get_public_word(entry_id: UUID) -> PublicWord:
    supabase = get_anon_supabase()
    try:
        result = apply_publish_gate(
            supabase.table("lexical_entries")
            .select(ENTRY_SELECT)
            .eq("id", str(entry_id))
        ).limit(1).execute()
    except Exception as exc:
        raise ServiceUnavailableError(
            "Public lexicon is temporarily unavailable"
        ) from exc
    rows = result.data or []
    if not rows or not is_publishable_row(rows[0]):
        raise NotFoundError("Lexical entry")
    row = rows[0]
    audio = _load_primary_audio([row["id"]]).get(row["id"])
    return to_public_word(row, audio)
