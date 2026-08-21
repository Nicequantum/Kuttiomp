import os

os.environ.setdefault("SUPABASE_URL", "https://example.supabase.co")
os.environ.setdefault("SUPABASE_ANON_KEY", "test-anon-key")
os.environ.setdefault("SUPABASE_SERVICE_ROLE_KEY", "test-service-role-key")
os.environ.setdefault("CLERK_SECRET_KEY", "sk_test_dummy")
os.environ.setdefault("GROK_API_KEY", "xai-test")
os.environ.setdefault("AUTH_DEV_SECRET", "test-auth-dev-secret")
os.environ.setdefault("API_ENV", "development")
os.environ.setdefault(
    "API_CORS_ORIGINS",
    "http://localhost:3000,http://localhost:8080,https://kuttiomp-learn.vercel.app",
)

import jwt
import pytest
from fastapi.testclient import TestClient

from app.main import app

DEV_SECRET = "test-auth-dev-secret"
KEEPER_SPEAKER_ID = "11111111-1111-1111-1111-111111111111"
ELDER_SPEAKER_ID = "22222222-2222-2222-2222-222222222222"


def make_dev_token(
    *,
    role: str = "keeper",
    speaker_id: str | None = KEEPER_SPEAKER_ID,
    sub: str = "user_test_keeper",
    is_elder: bool = False,
) -> str:
    payload = {
        "iss": "kuttiomp-dev",
        "sub": sub,
        "role": role,
        "is_elder": is_elder,
    }
    if speaker_id:
        payload["speaker_id"] = speaker_id
    return jwt.encode(payload, DEV_SECRET, algorithm="HS256")


def auth_headers(
    *,
    role: str = "keeper",
    speaker_id: str | None = KEEPER_SPEAKER_ID,
    is_elder: bool = False,
) -> dict[str, str]:
    return {
        "Authorization": (
            f"Bearer {make_dev_token(role=role, speaker_id=speaker_id, is_elder=is_elder)}"
        )
    }


@pytest.fixture
def client():
    with TestClient(app) as test_client:
        yield test_client


@pytest.fixture
def keeper_headers():
    return auth_headers(role="keeper", speaker_id=KEEPER_SPEAKER_ID)


@pytest.fixture
def elder_headers():
    return auth_headers(role="elder", speaker_id=ELDER_SPEAKER_ID, is_elder=True)


@pytest.fixture
def learner_headers():
    return auth_headers(role="learner", speaker_id=None)
