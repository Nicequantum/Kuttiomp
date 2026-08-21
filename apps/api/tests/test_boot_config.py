import os
import subprocess
import sys
from pathlib import Path

import pytest

from app.auth import _dev_auth_enabled, verify_bearer_token
from app.config import Settings, settings
from app.database import get_anon_supabase, get_supabase
from app.exceptions import UnauthorizedError
from app.services.grok_service import grok_service
from tests.conftest import make_dev_token

API_ROOT = Path(__file__).resolve().parents[1]
OPTIONAL_SECRETS = (
    "SUPABASE_URL",
    "SUPABASE_ANON_KEY",
    "SUPABASE_SERVICE_ROLE_KEY",
    "CLERK_SECRET_KEY",
    "CLERK_JWKS_URL",
    "CLERK_ISSUER",
    "GROK_API_KEY",
    "SUPABASE_JWT_SECRET",
    "AUTH_DEV_SECRET",
)


def _settings_without_secrets(monkeypatch, **overrides) -> Settings:
    for name in OPTIONAL_SECRETS:
        monkeypatch.delenv(name, raising=False)
    for name, value in overrides.items():
        if value is None:
            monkeypatch.delenv(name, raising=False)
        else:
            monkeypatch.setenv(name, value)
    return Settings(_env_file=None)


def test_settings_load_without_integration_secrets(monkeypatch):
    loaded = _settings_without_secrets(monkeypatch)
    assert loaded.supabase_url is None
    assert loaded.supabase_anon_key is None
    assert loaded.supabase_service_role_key is None
    assert loaded.clerk_secret_key is None
    assert loaded.grok_api_key is None
    assert loaded.supabase_configured is False
    assert loaded.clerk_configured is False
    assert loaded.grok_configured is False
    assert loaded.auth_dev_enabled is False


def test_empty_and_placeholder_secrets_are_unconfigured(monkeypatch):
    loaded = _settings_without_secrets(
        monkeypatch,
        SUPABASE_URL="   ",
        GROK_API_KEY="xai-your-key",
        CLERK_SECRET_KEY="",
        AUTH_DEV_SECRET="  ",
        API_ENV="production",
    )
    assert loaded.supabase_url is None
    assert loaded.grok_configured is False
    assert loaded.clerk_configured is False
    assert loaded.auth_dev_enabled is False


def test_import_and_health_without_grok_or_clerk():
    env = os.environ.copy()
    for name in OPTIONAL_SECRETS:
        env.pop(name, None)
    env["API_ENV"] = "production"
    code = """
from fastapi.testclient import TestClient
from app.main import app

with TestClient(app) as client:
    health = client.get("/health")
    public = client.get("/api/v1/public/health")
    lexicon = client.get("/api/v1/public/lexicon")
    assert health.status_code == 200, health.text
    body = health.json()
    assert body["integrations"]["grok"] is False
    assert body["integrations"]["clerk"] is False
    assert body["integrations"]["auth_dev"] is False
    assert public.status_code == 200, public.text
    assert lexicon.status_code == 503
    keeper = client.get("/api/v1/lexicon")
    assert keeper.status_code == 401
print("ok")
"""
    result = subprocess.run(
        [sys.executable, "-c", code],
        cwd=API_ROOT,
        env=env,
        capture_output=True,
        text=True,
        timeout=45,
    )
    assert result.returncode == 0, result.stdout + result.stderr
    assert "kuttiomp boot integrations:" in (result.stdout + result.stderr)
    assert "grok=no" in (result.stdout + result.stderr)
    assert "clerk=no" in (result.stdout + result.stderr)


def test_health_and_public_health_without_grok_or_clerk(client, monkeypatch):
    monkeypatch.setattr(settings, "grok_api_key", None)
    monkeypatch.setattr(settings, "clerk_secret_key", None)
    monkeypatch.setattr(settings, "clerk_jwks_url", None)
    health = client.get("/health")
    assert health.status_code == 200
    assert health.json()["grok_configured"] is False
    public = client.get("/api/v1/public/health")
    assert public.status_code == 200


def test_public_lexicon_503_without_supabase(client, monkeypatch):
    monkeypatch.setattr(settings, "supabase_url", None)
    monkeypatch.setattr(settings, "supabase_anon_key", None)
    monkeypatch.setattr(settings, "supabase_service_role_key", None)
    get_anon_supabase.cache_clear()
    get_supabase.cache_clear()
    try:
        response = client.get("/api/v1/public/lexicon")
        assert response.status_code == 503
        assert response.json()["error"]["code"] == "SERVICE_UNAVAILABLE"
        health = client.get("/api/v1/public/health")
        assert health.status_code == 200
        assert health.json()["ok"] is False
    finally:
        get_anon_supabase.cache_clear()
        get_supabase.cache_clear()


def test_grok_routes_503_when_key_missing(client, keeper_headers, monkeypatch):
    monkeypatch.setattr(settings, "grok_api_key", None)
    assert grok_service.is_configured() is False
    test = client.get("/api/grok/test", headers=keeper_headers)
    assert test.status_code == 503
    linguistic = client.post(
        "/api/v1/ai/linguistic",
        json={"prompt_type": "translation", "text": "wunnegan"},
        headers=keeper_headers,
    )
    assert linguistic.status_code == 503


def test_grok_still_requires_auth_when_key_missing(client, monkeypatch):
    monkeypatch.setattr(settings, "grok_api_key", None)
    response = client.post(
        "/api/v1/ai/linguistic",
        json={"prompt_type": "translation", "text": "wunnegan"},
    )
    assert response.status_code == 401


def test_keeper_routes_stay_locked_without_clerk(client, monkeypatch):
    monkeypatch.setattr(settings, "clerk_secret_key", None)
    monkeypatch.setattr(settings, "clerk_jwks_url", None)
    response = client.get("/api/v1/lexicon")
    assert response.status_code == 401


def test_production_disables_auth_dev_secret(monkeypatch):
    monkeypatch.setattr(settings, "api_env", "production")
    monkeypatch.setattr(settings, "auth_dev_secret", "test-auth-dev-secret")
    monkeypatch.setattr(settings, "supabase_jwt_secret", None)
    assert _dev_auth_enabled() is False
    with pytest.raises(UnauthorizedError):
        verify_bearer_token(make_dev_token())
