from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=("../../.env", ".env"),
        env_file_encoding="utf-8",
        extra="ignore",
    )

    # Supabase
    supabase_url: str
    supabase_anon_key: str
    supabase_service_role_key: str

    # Clerk
    clerk_secret_key: str

    # Grok API
    grok_api_key: str
    grok_api_base_url: str = "https://api.x.ai/v1"

    # Server
    api_host: str = "0.0.0.0"
    api_port: int = 8000
    api_cors_origins: str = "http://localhost:3000"

    # Audio
    audio_storage_bucket: str = "kuttiomp-audio"
    audio_max_duration_seconds: int = 300

    # Cultural
    sacred_content_requires_elder_approval: bool = True
    default_content_visibility: str = "clan"

    @property
    def cors_origins_list(self) -> list[str]:
        return [origin.strip() for origin in self.api_cors_origins.split(",")]


settings = Settings()