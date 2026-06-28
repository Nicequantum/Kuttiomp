from uuid import UUID

from app.database import get_supabase
from app.exceptions import NotFoundError, ValidationFailedError
from app.models.lexical_schemas import LexicalEntryCreateV2, LexicalEntryUpdateV2

UUID_FIELDS = (
    "domain_id", "primary_speaker_id", "primary_orthography_id", "created_by"
)


def _serialize_uuids(data: dict) -> dict:
    for field in UUID_FIELDS:
        if data.get(field):
            data[field] = str(data[field])
    return data


def _approval_status(entry: dict) -> str:
    if entry.get("is_sacred") or entry.get("spiritual_significance") == "sacred":
        return "requires_elder_review"
    if entry.get("visibility") == "sacred":
        return "requires_elder_review"
    return "pending"


def create_lexical_entry(entry: LexicalEntryCreateV2) -> dict:
    supabase = get_supabase()
    data = entry.model_dump(
        exclude={"spelling_variants", "example_sentences", "cultural_contexts"}
    )
    data = _serialize_uuids(data)
    data["approval_status"] = _approval_status(data)
    if data.get("seasonal_usage"):
        data["seasonal_usage"] = [s.value if hasattr(s, "value") else s for s in data["seasonal_usage"]]
    for enum_field in ("category", "semantic_domain", "spiritual_significance", "visibility"):
        if data.get(enum_field) and hasattr(data[enum_field], "value"):
            data[enum_field] = data[enum_field].value

    result = supabase.table("lexical_entries").insert(data).execute()
    if not result.data:
        raise ValidationFailedError("Failed to create lexical entry")
    created = result.data[0]
    entry_id = created["id"]

    for variant in entry.spelling_variants:
        vdata = variant.model_dump()
        if vdata.get("orthography_id"):
            vdata["orthography_id"] = str(vdata["orthography_id"])
        vdata["lexical_entry_id"] = entry_id
        supabase.table("spelling_variants").insert(vdata).execute()

    for sentence in entry.example_sentences:
        sdata = sentence.model_dump()
        if sdata.get("speaker_id"):
            sdata["speaker_id"] = str(sdata["speaker_id"])
        sdata["lexical_entry_id"] = entry_id
        supabase.table("example_sentences").insert(sdata).execute()

    for ctx in entry.cultural_contexts:
        cdata = ctx.model_dump()
        cdata["lexical_entry_id"] = entry_id
        if hasattr(cdata.get("context_type"), "value"):
            cdata["context_type"] = cdata["context_type"].value
        if hasattr(cdata.get("visibility"), "value"):
            cdata["visibility"] = cdata["visibility"].value
        cdata["approval_status"] = "pending"
        supabase.table("cultural_contexts").insert(cdata).execute()

    return created


def update_lexical_entry(entry_id: UUID, update: LexicalEntryUpdateV2) -> dict:
    supabase = get_supabase()
    data = update.model_dump(exclude_unset=True)
    data = _serialize_uuids(data)
    for enum_field in ("category", "semantic_domain", "spiritual_significance", "visibility", "approval_status"):
        if data.get(enum_field) and hasattr(data[enum_field], "value"):
            data[enum_field] = data[enum_field].value
    if data.get("seasonal_usage"):
        data["seasonal_usage"] = [
            s.value if hasattr(s, "value") else s for s in data["seasonal_usage"]
        ]

    result = (
        supabase.table("lexical_entries")
        .update(data)
        .eq("id", str(entry_id))
        .execute()
    )
    if not result.data:
        raise NotFoundError("Lexical entry", str(entry_id))
    return result.data[0]


def get_lexical_entry(entry_id: UUID) -> dict:
    supabase = get_supabase()
    result = (
        supabase.table("lexical_entries")
        .select("*")
        .eq("id", str(entry_id))
        .single()
        .execute()
    )
    if not result.data:
        raise NotFoundError("Lexical entry", str(entry_id))
    return result.data