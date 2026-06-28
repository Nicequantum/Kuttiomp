"""Dedicated Grok (xAI) API service for Kuttiomp linguistic assistance."""

import httpx

from app.config import settings

KUTTIOMP_SYSTEM_PROMPT = """You are a linguistic assistant for Kuttiomp, the Narragansett Language Revitalization Platform.

CRITICAL CULTURAL PROTOCOLS:
- You assist learners; you do NOT replace Knowledge Keepers, Elders, or Sharente (Two-Spirit keepers).
- Never invent ceremonial or sacred content. Flag uncertain translations.
- Honor speaker-specific pronunciation variants — Narragansett has living dialect variation.
- Use respectful, academically precise language about Indigenous knowledge.
- When discussing kinship terms, honor Two-Spirit (Sharente) roles and inclusive understanding.
- Acknowledge that language revitalization is an act of cultural sovereignty.

Your role: help with translation suggestions, etymology research, pronunciation guidance (IPA), and cultural context explanations for educational purposes only."""

TEST_PROMPT = "Respond with exactly: Kuttiomp Grok connection verified."


class GrokService:
    def __init__(self) -> None:
        self.api_key = settings.grok_api_key
        self.base_url = settings.grok_api_base_url.rstrip("/")
        self.model = "grok-3-latest"

    def is_configured(self) -> bool:
        return bool(self.api_key and self.api_key not in ("", "xai-your-key"))

    async def _chat(self, user_content: str, max_tokens: int = 1024) -> str:
        if not self.is_configured():
            raise ValueError("GROK_API_KEY is not configured")

        async with httpx.AsyncClient(timeout=30.0) as client:
            response = await client.post(
                f"{self.base_url}/chat/completions",
                headers={
                    "Authorization": f"Bearer {self.api_key}",
                    "Content-Type": "application/json",
                },
                json={
                    "model": self.model,
                    "messages": [
                        {"role": "system", "content": KUTTIOMP_SYSTEM_PROMPT},
                        {"role": "user", "content": user_content},
                    ],
                    "temperature": 0.2,
                    "max_tokens": max_tokens,
                },
            )
            response.raise_for_status()
            data = response.json()
            return data["choices"][0]["message"]["content"]

    async def test_connection(self) -> dict:
        """Verify Grok API key and connectivity."""
        response_text = await self._chat(TEST_PROMPT, max_tokens=32)
        return {
            "status": "ok",
            "configured": True,
            "model": self.model,
            "response": response_text.strip(),
            "message": "Grok API connection verified",
        }

    async def query(
        self,
        prompt_type: str,
        text: str,
    ) -> str:
        user_prompt = f"[Request type: {prompt_type}]\n\n{text}"
        return await self._chat(user_prompt)


grok_service = GrokService()