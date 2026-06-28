import httpx

from app.config import settings
from app.database import get_supabase

KUTTIOMP_SYSTEM_PROMPT = """You are a linguistic assistant for Kuttiomp, the Narragansett Language Revitalization Platform.

CRITICAL CULTURAL PROTOCOLS:
- You assist learners; you do NOT replace Knowledge Keepers, Elders, or Sharente (Two-Spirit keepers).
- Never invent ceremonial or sacred content. Flag uncertain translations.
- Honor speaker-specific pronunciation variants — Narragansett has living dialect variation.
- Use respectful, academically precise language about Indigenous knowledge.
- When discussing kinship terms, honor Two-Spirit (Sharente) roles and inclusive understanding.
- Acknowledge that language revitalization is an act of cultural sovereignty.

Your role: help with translation suggestions, etymology research, pronunciation guidance (IPA), and cultural context explanations for educational purposes only."""


async def query_grok(
    prompt_type: str,
    text: str,
    user_id: str | None = None,
    speaker_context_id: str | None = None,
    lexical_entry_id: str | None = None,
) -> tuple[str, str | None]:
    """Query Grok API and log interaction. Returns (response_text, interaction_id)."""
    user_prompt = f"[Request type: {prompt_type}]\n\n{text}"

    async with httpx.AsyncClient(timeout=60.0) as client:
        response = await client.post(
            f"{settings.grok_api_base_url}/chat/completions",
            headers={
                "Authorization": f"Bearer {settings.grok_api_key}",
                "Content-Type": "application/json",
            },
            json={
                "model": "grok-2-latest",
                "messages": [
                    {"role": "system", "content": KUTTIOMP_SYSTEM_PROMPT},
                    {"role": "user", "content": user_prompt},
                ],
                "temperature": 0.3,
                "max_tokens": 1024,
            },
        )
        response.raise_for_status()
        data = response.json()
        response_text = data["choices"][0]["message"]["content"]

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