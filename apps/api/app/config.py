import logging

from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict

logger = logging.getLogger("kuttiomp.boot")

# Placeholder copied from .env.example — treat as unset.
_GROK_PLACEHOLDERS = frozenset({"", "xai-your-key"})


def _secret_present(value: str | None) -> bool:
    return bool(value and value.strip())


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=(".env", "../../.env", "../.env"),
        env_file_encoding="utf-8",
        extra="ignore",
    )

    # Supabase — optional at import so Railway can boot /health without secrets.
    supabase_url: str | None = None
    supabase_anon_key: str | None = None
    supabase_service_role_key: str | None = None

    # Clerk (admin / Knowledge Keeper portal)
    clerk_secret_key: str | None = None
    clerk_jwks_url: str | None = None
    clerk_issuer: str | None = None

    # Optional: verify Flutter / Supabase access tokens
    supabase_jwt_secret: str | None = None

    # Local/test HS256 only. Must stay unset in production.
    auth_dev_secret: str | None = None
    api_env: str = "development"

    # Grok API
    grok_api_key: str | None = None
    grok_api_base_url: str = "https://api.x.ai/v1"

    # Server
    api_host: str = "0.0.0.0"
    api_port: int = 8000
    api_cors_origins: str = (
        "http://localhost:3000,"
        "http://localhost:8080,"
        "https://kuttiomp-learn.vercel.app,"
        "https://kuttiomp-admin.vercel.app"
    )

    # Audio
    audio_storage_bucket: str = "kuttiomp-audio"
    audio_max_duration_seconds: int = 300
    audio_signed_url_ttl_seconds: int = 3600

    # Cultural
    sacred_content_requires_elder_approval: bool = True
    default_content_visibility: str = "clan"

    @field_validator(
        "supabase_url",
        "supabase_anon_key",
        "supabase_service_role_key",
        "clerk_secret_key",
        "clerk_jwks_url",
        "clerk_issuer",
        "supabase_jwt_secret",
        "auth_dev_secret",
        "grok_api_key",
        mode="before",
    )
    @classmethod
    def empty_str_none(cls, value: object) -> object:
        if isinstance(value, str) and not value.strip():
            return None
        return value

    @property
    def cors_origins_list(self) -> list[str]:
        return [origin.strip() for origin in self.api_cors_origins.split(",") if origin.strip()]

    @property
    def supabase_anon_configured(self) -> bool:
        return _secret_present(self.supabase_url) and _secret_present(self.supabase_anon_key)

    @property
    def supabase_service_configured(self) -> bool:
        return _secret_present(self.supabase_url) and _secret_present(self.supabase_service_role_key)

    @property
    def supabase_configured(self) -> bool:
        return self.supabase_anon_configured and self.supabase_service_configured

    @property
    def clerk_configured(self) -> bool:
        return _secret_present(self.clerk_secret_key) or _secret_present(self.clerk_jwks_url)

    @property
    def grok_configured(self) -> bool:
        key = (self.grok_api_key or "").strip()
        return bool(key) and key not in _GROK_PLACEHOLDERS

    @property
    def supabase_jwt_configured(self) -> bool:
        return _secret_present(self.supabase_jwt_secret)

    @property
    def auth_dev_enabled(self) -> bool:
        return _secret_present(self.auth_dev_secret) and self.api_env != "production"

    def integration_flags(self) -> dict[str, bool]:
        return {
            "supabase": self.supabase_configured,
            "clerk": self.clerk_configured,
            "grok": self.grok_configured,
            "supabase_jwt": self.supabase_jwt_configured,
            "auth_dev": self.auth_dev_enabled,
        }

    def log_boot_integrations(self) -> None:
        flags = self.integration_flags()
        parts = [f"{name}={'yes' if ok else 'no'}" for name, ok in flags.items()]
        line = (
            "kuttiomp boot integrations: "
            + " ".join(parts)
            + f" api_env={self.api_env}"
        )
        logger.info(line)
        # Railway captures process stdout even if the kuttiomp logger is quiet.
        print(line)


settings = Settings()
