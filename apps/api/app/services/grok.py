"""Backward-compatible Grok helpers — delegates to grok_service."""

from app.database import get_supabase
from app.services.grok_service import grok_service


async def query_grok(
    prompt_type: str,
    text: str,
    user_id: str | None = None,
    speaker_context_id: str | None = None,
    lexical_entry_id: str | None = None,
) -> tuple[str, str | None]:
    response_text = await grok_service.query(prompt_type, text)

    supabase = get_supabase()
    result = (
        supabase.table("ai_interactions")
        .insert(
            {
                "user_id": user_id,
                "speaker_context_id": speaker_context_id,
                "prompt_type": prompt_type,
                "prompt_text": text,
                "response_text": response_text,
                "lexical_entry_id": lexical_entry_id,
            }
        )
        .execute()
    )

    interaction_id = result.data[0]["id"] if result.data else None
    return response_text, interaction_id