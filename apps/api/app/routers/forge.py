"""Language Forge — Knowledge Keeper only. Not a learner creation surface."""

from datetime import datetime, timezone
from uuid import UUID

from fastapi import APIRouter, Depends, Query

from app.auth import Actor, require_elder, require_keeper
from app.database import get_supabase
from app.exceptions import ForbiddenError, NotFoundError, ValidationFailedError
from app.models.forge_schemas import (
    CorpusModulesUpdate,
    ForgeCommentCreate,
    ForgeEntryCreate,
    ForgeEntryResponse,
    ForgeStatusChange,
    ForgeVisibilityUpdate,
)
from app.services.public_lexicon import RESTRICTED_SPIRITUAL

router = APIRouter(
    prefix="/forge",
    tags=["Language Forge"],
    dependencies=[Depends(require_keeper)],
    responses={
        401: {"description": "Authentication required"},
        403: {"description": "Keepers only"},
        404: {"description": "Forge entry not found"},
        422: {"description": "Validation error"},
    },
)

public_router = APIRouter(prefix="/forge", tags=["Language Forge"])

MODULE_LABELS = {
    "feedHistorical": "Historical seed",
    "feedApprovedLiving": "Approved living words",
    "feedForgeDemoMerge": "Forge teaching feed",
}


def _normalize(word: str) -> str:
    return " ".join(word.lower().split())


def _stringify(row: dict) -> dict:
    out = dict(row)
    for key, value in list(out.items()):
        if isinstance(value, UUID):
            out[key] = str(value)
    return out


def _actor_id(actor: Actor) -> str | None:
    return str(actor.speaker_id) if actor.speaker_id else None


def _read_env_row() -> dict:
    supabase = get_supabase()
    env = supabase.table("app_environment").select("*").eq("id", "default").limit(1).execute()
    return (env.data or [{}])[0]


def modules_from_env(row: dict | None) -> dict:
    """Independent feed flags. Missing columns fall back from corpus_mode."""
    row = row or {}
    merge = row.get("feed_forge_demo_merge")
    if merge is None:
        merge = (row.get("corpus_mode") or "demo_historical") != "keeper_only"
    hist = row.get("feed_historical")
    living = row.get("feed_approved_living")
    return {
        "feedHistorical": True if hist is None else bool(hist),
        "feedApprovedLiving": True if living is None else bool(living),
        "feedForgeDemoMerge": bool(merge),
    }


def corpus_mode_from_modules(modules: dict) -> str:
    return "demo_historical" if modules.get("feedForgeDemoMerge") else "keeper_only"


def _is_released(entry: dict) -> bool:
    return entry.get("status") == "approved" and bool(entry.get("is_production_ready"))


def forge_entry_visible(entry: dict, modules: dict) -> bool:
    if entry.get("spiritual_significance") in RESTRICTED_SPIRITUAL:
        return False
    living = modules.get("feedApprovedLiving") and _is_released(entry)
    teaching = (
        modules.get("feedForgeDemoMerge")
        and bool(entry.get("is_demo_visible"))
        and entry.get("status") not in {"rejected", "archived"}
        and not _is_released(entry)
    )
    return bool(living or teaching)


def _preview(modules: dict) -> dict:
    supabase = get_supabase()
    forge = supabase.table("language_forge_entries").select("*").execute().data or []
    lex = supabase.table("lexical_entries").select("*").execute().data or []
    historical = sum(1 for row in lex if not row.get("is_neologism"))
    approved_living = sum(
        1
        for entry in forge
        if _is_released(entry) and entry.get("spiritual_significance") not in RESTRICTED_SPIRITUAL
    )
    teaching_drafts = sum(
        1
        for entry in forge
        if bool(entry.get("is_demo_visible"))
        and entry.get("status") not in {"rejected", "archived"}
        and not _is_released(entry)
        and entry.get("spiritual_significance") not in RESTRICTED_SPIRITUAL
    )
    return {
        "historical": historical,
        "approvedLiving": approved_living,
        "teachingDrafts": teaching_drafts,
        "learnerTotal": (
            (historical if modules.get("feedHistorical") else 0)
            + (approved_living if modules.get("feedApprovedLiving") else 0)
            + (teaching_drafts if modules.get("feedForgeDemoMerge") else 0)
        ),
    }


def _audit_rows() -> list:
    supabase = get_supabase()
    try:
        rows = (
            supabase.table("corpus_module_audit")
            .select("*")
            .order("created_at", desc=True)
            .limit(24)
            .execute()
        )
        return rows.data or []
    except Exception:
        return []


def corpus_desk_payload(modules: dict | None = None, env: dict | None = None) -> dict:
    env = env if env is not None else _read_env_row()
    modules = modules if modules is not None else modules_from_env(env)
    return {
        "corpusMode": corpus_mode_from_modules(modules),
        "modules": modules,
        "preview": _preview(modules),
        "updatedBy": env.get("updated_by"),
        "updatedAt": env.get("updated_at"),
        "audit": _audit_rows(),
    }


def learner_feed_payload() -> dict:
    """Sacred/restricted never leave. Teaching feed vs keeper knowledge from modules."""
    env = _read_env_row()
    modules = modules_from_env(env)
    mode = corpus_mode_from_modules(modules)
    rows = get_supabase().table("language_forge_entries").select("*").execute().data or []
    out = []
    for entry in rows:
        if not forge_entry_visible(entry, modules):
            continue
        released = _is_released(entry)
        out.append(
            {
                "id": entry["id"],
                "wordNarragansett": entry["proposed_word"],
                "englishGloss": entry["english_gloss"],
                "semanticDomain": entry.get("semantic_domain") or "other",
                "source": "keeper_approved" if released else "historical_seed",
                "authority": "living_speaker" if released else "colonial_record",
                "elderApproved": released,
                "isSacred": False,
                "speakerAttribution": "Language Forge / Knowledge Keepers",
            }
        )
    return {"corpusMode": mode, "modules": modules, "words": out}


@public_router.get("/public/learner-feed", summary="Read-only feed for kuttiomp-learn")
async def learner_feed():
    return learner_feed_payload()


@router.get("", response_model=list[ForgeEntryResponse], summary="List Forge dossiers")
async def list_forge_entries(
    search: str | None = Query(None),
    status: str | None = None,
    semantic_domain: str | None = None,
    limit: int = Query(default=80, ge=1, le=200),
    offset: int = Query(default=0, ge=0),
    _keeper: Actor = Depends(require_keeper),
):
    supabase = get_supabase()
    query = supabase.table("language_forge_entries").select("*")
    if search:
        safe = search.replace("%", "").replace(",", "")
        query = query.or_(
            f"proposed_word.ilike.%{safe}%,"
            f"english_gloss.ilike.%{safe}%,"
            f"morphological_breakdown.ilike.%{safe}%,"
            f"linguistic_justification.ilike.%{safe}%"
        )
    if status:
        query = query.eq("status", status)
    if semantic_domain:
        query = query.eq("semantic_domain", semantic_domain)
    result = query.order("last_updated_at", desc=True).range(offset, offset + limit - 1).execute()
    return result.data or []


@router.get("/corpus", summary="Learner-feed modules (Keepers)")
async def get_corpus(_keeper: Actor = Depends(require_keeper)):
    return corpus_desk_payload()


@router.patch("/corpus", summary="Convert learner feed modules (Sharente / elder)")
async def update_corpus(payload: CorpusModulesUpdate, actor: Actor = Depends(require_elder)):
    supabase = get_supabase()
    env = _read_env_row()
    current = modules_from_env(env)
    nxt = {
        "feedHistorical": (
            current["feedHistorical"] if payload.feed_historical is None else payload.feed_historical
        ),
        "feedApprovedLiving": (
            current["feedApprovedLiving"]
            if payload.feed_approved_living is None
            else payload.feed_approved_living
        ),
        "feedForgeDemoMerge": (
            current["feedForgeDemoMerge"]
            if payload.feed_forge_demo_merge is None
            else payload.feed_forge_demo_merge
        ),
    }
    if nxt == current:
        return corpus_desk_payload(current, env)

    mode = corpus_mode_from_modules(nxt)
    update = {
        "feed_historical": nxt["feedHistorical"],
        "feed_approved_living": nxt["feedApprovedLiving"],
        "feed_forge_demo_merge": nxt["feedForgeDemoMerge"],
        "corpus_mode": mode,
        "updated_by": _actor_id(actor),
        "updated_at": datetime.now(timezone.utc).isoformat(),
    }
    existing = (
        supabase.table("app_environment").select("*").eq("id", "default").limit(1).execute()
    )
    if existing.data:
        supabase.table("app_environment").update(update).eq("id", "default").execute()
    else:
        supabase.table("app_environment").insert({"id": "default", **update}).execute()

    for key in current:
        if current[key] == nxt[key]:
            continue
        try:
            supabase.table("corpus_module_audit").insert(
                {
                    "actor_id": _actor_id(actor),
                    "module_key": key,
                    "old_value": str(current[key]).lower(),
                    "new_value": str(nxt[key]).lower(),
                    "summary": (
                        f"{MODULE_LABELS.get(key, key)}: "
                        f"{'on' if current[key] else 'off'} → {'on' if nxt[key] else 'off'}."
                    ),
                }
            ).execute()
        except Exception:
            pass

    env = _read_env_row()
    return corpus_desk_payload(modules_from_env(env), env)


@router.get("/{entry_id}", summary="Get Forge dossier with discussion and history")
async def get_forge_entry(entry_id: UUID, actor: Actor = Depends(require_keeper)):
    supabase = get_supabase()
    entry = (
        supabase.table("language_forge_entries")
        .select("*")
        .eq("id", str(entry_id))
        .limit(1)
        .execute()
    )
    if not entry.data:
        raise NotFoundError("Forge entry", str(entry_id))
    row = entry.data[0]
    if row.get("spiritual_significance") in RESTRICTED_SPIRITUAL and not actor.can_view_sacred:
        raise ForbiddenError("Sacred Forge dossiers require an elder session")
    comments = (
        supabase.table("forge_comments")
        .select("*")
        .eq("entry_id", str(entry_id))
        .order("created_at")
        .execute()
    )
    audit = (
        supabase.table("forge_audit_log")
        .select("*")
        .eq("entry_id", str(entry_id))
        .order("created_at", desc=True)
        .execute()
    )
    examples = (
        supabase.table("forge_example_sentences")
        .select("*")
        .eq("entry_id", str(entry_id))
        .order("sort_order")
        .execute()
    )
    cognates = (
        supabase.table("forge_cognate_references")
        .select("*")
        .eq("entry_id", str(entry_id))
        .execute()
    )
    return {
        **row,
        "comments": comments.data or [],
        "audit": audit.data or [],
        "examples": examples.data or [],
        "cognates": cognates.data or [],
    }


@router.post("", response_model=ForgeEntryResponse, summary="Create Forge draft")
async def create_forge_entry(payload: ForgeEntryCreate, actor: Actor = Depends(require_keeper)):
    supabase = get_supabase()
    row = _stringify(payload.model_dump())
    row["word_normalized"] = _normalize(payload.proposed_word)
    row["submitted_by"] = _actor_id(actor)
    row["last_updated_by"] = _actor_id(actor)
    row["is_demo_visible"] = False
    row["is_production_ready"] = False
    result = supabase.table("language_forge_entries").insert(row).execute()
    if not result.data:
        raise ValidationFailedError("Could not create Forge entry")
    created = result.data[0]
    supabase.table("forge_audit_log").insert(
        {
            "entry_id": created["id"],
            "actor_id": _actor_id(actor),
            "action": "created",
            "summary": f"Created draft “{payload.proposed_word}”.",
        }
    ).execute()
    return created


@router.patch("/{entry_id}", response_model=ForgeEntryResponse)
async def update_forge_entry(
    entry_id: UUID,
    payload: ForgeEntryCreate,
    actor: Actor = Depends(require_keeper),
):
    supabase = get_supabase()
    row = _stringify(payload.model_dump())
    row["word_normalized"] = _normalize(payload.proposed_word)
    row.pop("submitted_by", None)
    row["last_updated_by"] = _actor_id(actor)
    row.pop("is_production_ready", None)
    result = (
        supabase.table("language_forge_entries")
        .update(row)
        .eq("id", str(entry_id))
        .execute()
    )
    if not result.data:
        raise NotFoundError("Forge entry", str(entry_id))
    supabase.table("forge_audit_log").insert(
        {
            "entry_id": str(entry_id),
            "actor_id": _actor_id(actor),
            "action": "updated",
            "summary": "Saved a new revision.",
        }
    ).execute()
    return result.data[0]


@router.post("/{entry_id}/status", summary="Workflow transition (Sharente / reviewers)")
async def change_status(
    entry_id: UUID,
    payload: ForgeStatusChange,
    actor: Actor = Depends(require_keeper),
):
    supabase = get_supabase()
    actor_id = _actor_id(actor)
    update = {
        "status": payload.status,
        "approval_notes": payload.notes,
        "reviewed_by": actor_id,
        "last_updated_by": actor_id,
    }
    if payload.status in {"approved", "rejected", "needs_revision", "under_review"}:
        update["reviewed_at"] = "now()"
    if payload.status != "approved":
        update["is_production_ready"] = False
    result = (
        supabase.table("language_forge_entries")
        .update(update)
        .eq("id", str(entry_id))
        .execute()
    )
    if not result.data:
        raise NotFoundError("Forge entry", str(entry_id))
    supabase.table("forge_audit_log").insert(
        {
            "entry_id": str(entry_id),
            "actor_id": actor_id,
            "action": "status_change",
            "field_name": "status",
            "new_value": payload.status,
            "summary": payload.notes or f"Status → {payload.status}",
        }
    ).execute()
    return result.data[0]


@router.post("/{entry_id}/production", summary="Mark production-ready and publish to lexicon")
async def set_production_ready(
    entry_id: UUID,
    payload: ForgeVisibilityUpdate,
    actor: Actor = Depends(require_elder),
):
    supabase = get_supabase()
    existing = (
        supabase.table("language_forge_entries")
        .select("*")
        .eq("id", str(entry_id))
        .limit(1)
        .execute()
    )
    if not existing.data:
        raise NotFoundError("Forge entry", str(entry_id))
    entry = existing.data[0]
    if payload.production_ready and entry.get("status") != "approved":
        raise ValidationFailedError("Only approved entries may be production-ready.")
    spiritual = entry.get("spiritual_significance") or "none"
    if payload.production_ready and spiritual in RESTRICTED_SPIRITUAL:
        raise ValidationFailedError("Sacred or restricted dossiers cannot be published for learners")

    lexical_id = entry.get("lexical_entry_id")
    if payload.production_ready:
        speaker_id = str(actor.require_speaker_id())
        lex = {
            "word_narragansett": entry["proposed_word"],
            "word_normalized": entry["word_normalized"],
            "english_gloss": entry["english_gloss"],
            "english_gloss_extended": entry.get("english_meaning"),
            "ipa_transcription": entry.get("ipa_transcription"),
            "phonemic_transcription": entry.get("phonemic_transcription"),
            "morphological_breakdown": entry.get("morphological_breakdown"),
            "usage_notes": entry.get("usage_notes"),
            "cultural_context": entry.get("cultural_notes"),
            "category": entry.get("part_of_speech") or "other",
            "semantic_domain": entry.get("semantic_domain") or "other",
            "spiritual_significance": spiritual if spiritual in {"none", "respectful"} else "none",
            "is_neologism": True,
            "is_sacred": False,
            "approval_status": "approved",
            "visibility": "public",
            "primary_speaker_id": speaker_id,
        }
        if lexical_id:
            supabase.table("lexical_entries").update(lex).eq("id", lexical_id).execute()
        else:
            created = supabase.table("lexical_entries").insert(lex).execute()
            if created.data:
                lexical_id = created.data[0]["id"]

    actor_id = _actor_id(actor)
    result = (
        supabase.table("language_forge_entries")
        .update(
            {
                "is_production_ready": payload.production_ready,
                "is_demo_visible": payload.demo_visible,
                "lexical_entry_id": lexical_id,
                "last_updated_by": actor_id,
            }
        )
        .eq("id", str(entry_id))
        .execute()
    )
    supabase.table("forge_audit_log").insert(
        {
            "entry_id": str(entry_id),
            "actor_id": actor_id,
            "action": "publish_lexicon" if payload.production_ready else "visibility",
            "summary": "Production-ready / demo visibility updated.",
        }
    ).execute()
    return result.data[0] if result.data else entry


@router.post("/{entry_id}/comments")
async def add_comment(
    entry_id: UUID,
    payload: ForgeCommentCreate,
    actor: Actor = Depends(require_keeper),
):
    supabase = get_supabase()
    result = (
        supabase.table("forge_comments")
        .insert(
            {
                "entry_id": str(entry_id),
                "author_id": _actor_id(actor),
                "body": payload.body,
            }
        )
        .execute()
    )
    return result.data[0] if result.data else {"ok": True}
