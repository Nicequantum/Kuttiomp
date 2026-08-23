from uuid import uuid4

from tests.conftest import KEEPER_SPEAKER_ID
from tests.fakes import FilteringClient


FORGE_ROWS = [
    {
        "id": "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb",
        "proposed_word": "wunnegan",
        "word_normalized": "wunnegan",
        "english_gloss": "welcome",
        "status": "draft",
        "semantic_domain": "other",
        "spiritual_significance": "none",
        "is_demo_visible": True,
        "is_production_ready": False,
        "version": 1,
        "last_updated_at": "2026-08-17T00:00:00Z",
    },
    {
        "id": "cccccccc-cccc-cccc-cccc-cccccccccccc",
        "proposed_word": "restricted-form",
        "word_normalized": "restricted-form",
        "english_gloss": "should not leak",
        "status": "approved",
        "semantic_domain": "spiritual",
        "spiritual_significance": "sacred",
        "is_demo_visible": True,
        "is_production_ready": True,
        "version": 1,
        "last_updated_at": "2026-08-17T00:00:00Z",
    },
]


def _forge_client():
    return FilteringClient(
        {
            "language_forge_entries": FORGE_ROWS,
            "app_environment": [{"id": "default", "corpus_mode": "demo_historical"}],
            "forge_comments": [],
            "forge_audit_log": [],
            "forge_example_sentences": [],
            "forge_cognate_references": [],
        }
    )


def test_unauthenticated_forge_list_denied(client):
    response = client.get("/api/v1/forge")
    assert response.status_code == 401
    assert response.json()["error"]["code"] == "UNAUTHORIZED"


def test_learner_forge_list_forbidden(client, learner_headers):
    response = client.get("/api/v1/forge", headers=learner_headers)
    assert response.status_code == 403
    assert response.json()["error"]["code"] == "FORBIDDEN"


def test_learner_cannot_create_forge_entry(client, learner_headers):
    response = client.post(
        "/api/v1/forge",
        json={"proposed_word": "wunnegan", "english_gloss": "welcome"},
        headers=learner_headers,
    )
    assert response.status_code == 403


def test_keeper_can_list_forge(client, keeper_headers, monkeypatch):
    monkeypatch.setattr("app.routers.forge.get_supabase", _forge_client)
    response = client.get("/api/v1/forge", headers=keeper_headers)
    assert response.status_code == 200
    words = [row["proposed_word"] for row in response.json()]
    assert "wunnegan" in words


def test_public_learner_feed_unauthenticated(client, monkeypatch):
    monkeypatch.setattr("app.routers.forge.get_supabase", _forge_client)
    response = client.get("/api/v1/forge/public/learner-feed")
    assert response.status_code == 200
    body = response.json()
    words = [row["wordNarragansett"] for row in body["words"]]
    assert "wunnegan" in words
    assert "restricted-form" not in words
    assert body["corpusMode"] == "demo_historical"


def test_public_forge_feed_alias(client, monkeypatch):
    monkeypatch.setattr(
        "app.routers.forge.learner_feed_payload",
        lambda: {"corpusMode": "demo_historical", "words": []},
    )
    response = client.get("/api/v1/public/forge-feed")
    assert response.status_code == 200
    assert response.json()["corpusMode"] == "demo_historical"


def test_non_elder_cannot_mark_production(client, keeper_headers):
    response = client.post(
        f"/api/v1/forge/{uuid4()}/production",
        json={"production_ready": True, "actor_id": KEEPER_SPEAKER_ID},
        headers=keeper_headers,
    )
    assert response.status_code == 403
