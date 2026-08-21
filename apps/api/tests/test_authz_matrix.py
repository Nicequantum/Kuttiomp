from uuid import uuid4

from app.auth import actor_from_speaker
from tests.conftest import KEEPER_SPEAKER_ID, make_dev_token


SACRED_ID = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
SACRED_ENTRY = {
    "id": SACRED_ID,
    "word_narragansett": "restricted-word",
    "word_normalized": "restricted-word",
    "english_gloss": "should not leak",
    "category": "other",
    "visibility": "sacred",
    "is_sacred": True,
    "approval_status": "approved",
    "created_at": "2026-01-01T00:00:00Z",
    "updated_at": "2026-01-01T00:00:00Z",
}


def test_unauthenticated_health_allowed(client):
    response = client.get("/health")
    assert response.status_code == 200


def test_unauthenticated_write_denied(client):
    response = client.post(
        "/api/v1/lexicon",
        json={"word_narragansett": "wunnegan", "english_gloss": "welcome"},
    )
    assert response.status_code == 401
    assert response.json()["error"]["code"] == "UNAUTHORIZED"


def test_unauthenticated_bulk_denied(client):
    response = client.post("/api/v1/lexicon/bulk", json=[{"word_narragansett": "a"}])
    assert response.status_code == 401


def test_unauthenticated_approve_denied(client):
    response = client.post(f"/api/v1/audio/{uuid4()}/approve")
    assert response.status_code == 401


def test_unauthenticated_ai_denied(client):
    response = client.post(
        "/api/v1/ai/linguistic",
        json={"prompt_type": "translation", "text": "wunnegan"},
    )
    assert response.status_code == 401


def test_learner_post_lexicon_forbidden(client, learner_headers):
    response = client.post(
        "/api/v1/lexicon",
        json={"word_narragansett": "wunnegan", "english_gloss": "welcome"},
        headers=learner_headers,
    )
    assert response.status_code == 403
    assert response.json()["error"]["code"] == "FORBIDDEN"


def test_learner_bulk_forbidden(client, learner_headers):
    response = client.post(
        "/api/v1/lexicon/bulk",
        json=[{"word_narragansett": "wunnegan", "english_gloss": "welcome"}],
        headers=learner_headers,
    )
    assert response.status_code == 403


def test_learner_ai_forbidden(client, learner_headers):
    response = client.post(
        "/api/v1/ai/linguistic",
        json={"prompt_type": "translation", "text": "wunnegan"},
        headers=learner_headers,
    )
    assert response.status_code == 403


def test_learner_sacred_patch_forbidden(client, learner_headers):
    response = client.patch(
        f"/api/v1/lexicon/{uuid4()}",
        json={"is_sacred": True, "approval_status": "approved"},
        headers=learner_headers,
    )
    assert response.status_code == 403


def test_unlinked_clerk_is_not_a_keeper():
    actor = actor_from_speaker(
        subject="user_random_clerk",
        issuer="clerk",
        speaker=None,
    )
    assert actor.is_keeper is False
    assert actor.is_elder is False
    assert actor.can_view_sacred is False


def test_clerk_session_without_speaker_cannot_write(client):
    headers = {
        "Authorization": (
            f"Bearer {make_dev_token(role='unlinked', speaker_id=None, actor_issuer='clerk')}"
        )
    }
    response = client.post(
        "/api/v1/lexicon",
        json={"word_narragansett": "wunnegan", "english_gloss": "welcome"},
        headers=headers,
    )
    assert response.status_code == 403


def test_non_elder_cannot_include_sacred(client, keeper_headers, clerk_non_elder_headers):
    for headers in (keeper_headers, clerk_non_elder_headers):
        response = client.get("/api/v1/lexicon?include_sacred=true", headers=headers)
        assert response.status_code == 403
        assert response.json()["error"]["code"] == "FORBIDDEN"


def test_non_elder_cannot_get_sacred_by_id(client, keeper_headers, clerk_non_elder_headers, monkeypatch):
    monkeypatch.setattr("app.routers.lexicon.get_lexical_entry", lambda _id: SACRED_ENTRY)

    denied = client.get(f"/api/v1/lexicon/{SACRED_ID}", headers=keeper_headers)
    assert denied.status_code == 403
    assert denied.json()["error"]["code"] == "SACRED_CONTENT_RESTRICTED"
    assert "restricted-word" not in denied.text

    flagged = client.get(
        f"/api/v1/lexicon/{SACRED_ID}?include_sacred=true",
        headers=clerk_non_elder_headers,
    )
    assert flagged.status_code == 403
    assert flagged.json()["error"]["code"] == "FORBIDDEN"
    assert "restricted-word" not in flagged.text


def test_elder_can_get_sacred_by_id(client, elder_headers, monkeypatch):
    monkeypatch.setattr("app.routers.lexicon.get_lexical_entry", lambda _id: SACRED_ENTRY)
    response = client.get(
        f"/api/v1/lexicon/{SACRED_ID}?include_sacred=true",
        headers=elder_headers,
    )
    assert response.status_code == 200
    assert response.json()["word_narragansett"] == "restricted-word"


def test_authenticated_keeper_write_not_unauthorized(client, keeper_headers, monkeypatch):
    monkeypatch.setattr(
        "app.routers.lexicon.create_lexical_entry",
        lambda entry: {
            "id": str(uuid4()),
            "word_narragansett": entry.word_narragansett,
            "word_normalized": entry.word_narragansett.lower(),
            "english_gloss": entry.english_gloss,
            "category": "other",
            "visibility": "clan",
            "is_sacred": False,
            "approval_status": "pending",
            "created_at": "2026-01-01T00:00:00Z",
            "updated_at": "2026-01-01T00:00:00Z",
        },
    )
    response = client.post(
        "/api/v1/lexicon",
        json={"word_narragansett": "wunnegan", "english_gloss": "welcome"},
        headers=keeper_headers,
    )
    assert response.status_code == 201


def test_approve_uses_token_actor_not_client_uuid(client, keeper_headers, monkeypatch):
    captured: dict[str, str] = {}
    spoofed = str(uuid4())

    def fake_approve(recording_id: str, approved_by: str):
        captured["approved_by"] = approved_by
        return {"id": recording_id, "approval_status": "approved", "approved_by": approved_by}

    monkeypatch.setattr("app.routers.audio.approve_recording", fake_approve)
    response = client.post(
        f"/api/v1/audio/{uuid4()}/approve",
        params={"approved_by": spoofed},
        headers=keeper_headers,
    )
    assert response.status_code == 200
    assert captured["approved_by"] == KEEPER_SPEAKER_ID
    assert captured["approved_by"] != spoofed


def test_invalid_token_denied(client):
    response = client.get(
        "/api/v1/lexicon",
        headers={"Authorization": "Bearer not-a-real-token"},
    )
    assert response.status_code == 401
