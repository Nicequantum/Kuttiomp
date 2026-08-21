from uuid import uuid4

from tests.conftest import KEEPER_SPEAKER_ID, make_dev_token


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
    recording_id = uuid4()
    response = client.post(
        f"/api/v1/audio/{recording_id}/approve",
        params={"approved_by": str(uuid4())},
    )
    assert response.status_code == 401


def test_unauthenticated_ai_denied(client):
    response = client.post(
        "/api/v1/ai/linguistic",
        json={"prompt_type": "translation", "text": "wunnegan"},
    )
    assert response.status_code == 401


def test_unauthenticated_keeper_lexicon_denied(client):
    response = client.get("/api/v1/lexicon?include_sacred=true")
    assert response.status_code == 401


def test_unauthenticated_public_read_allowed(client, monkeypatch):
    monkeypatch.setattr(
        "app.routers.public_lexicon.list_public_words",
        lambda **kwargs: {
            "corpusVersion": "2026-01-01T00:00:00Z",
            "total": 0,
            "limit": 100,
            "offset": 0,
            "words": [],
        },
    )
    response = client.get("/api/v1/public/lexicon")
    assert response.status_code == 200
    body = response.json()
    assert body["words"] == []
    assert body["total"] == 0


def test_unauthenticated_health_allowed(client):
    response = client.get("/health")
    assert response.status_code == 200


def test_unauthenticated_public_health_allowed(client, monkeypatch):
    monkeypatch.setattr(
        "app.routers.public_lexicon.get_public_health",
        lambda: {
            "ok": True,
            "service": "kuttiomp-public",
            "corpusVersion": "2026-01-01T00:00:00Z",
            "wordCount": 0,
        },
    )
    response = client.get("/api/v1/public/health")
    assert response.status_code == 200


def test_include_sacred_learner_denied(client, learner_headers):
    response = client.get("/api/v1/lexicon?include_sacred=true", headers=learner_headers)
    assert response.status_code == 403
    assert response.json()["error"]["code"] == "FORBIDDEN"


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
    assert response.json()["word_narragansett"] == "wunnegan"


def test_approve_uses_token_actor_not_client_uuid(client, keeper_headers, monkeypatch):
    captured: dict[str, str] = {}
    spoofed = str(uuid4())

    def fake_approve(recording_id: str, approved_by: str):
        captured["recording_id"] = recording_id
        captured["approved_by"] = approved_by
        return {
            "id": recording_id,
            "approval_status": "approved",
            "approved_by": approved_by,
        }

    monkeypatch.setattr("app.routers.audio.approve_recording", fake_approve)
    recording_id = uuid4()
    response = client.post(
        f"/api/v1/audio/{recording_id}/approve",
        params={"approved_by": spoofed},
        headers=keeper_headers,
    )
    assert response.status_code == 200
    assert captured["approved_by"] == KEEPER_SPEAKER_ID
    assert captured["approved_by"] != spoofed


def test_review_uses_token_actor_not_client_uuid(client, keeper_headers, monkeypatch):
    captured: dict[str, object] = {}
    spoofed = str(uuid4())

    class FakeResult:
        data = [{"id": "contrib", "status": "approved", "reviewed_by": KEEPER_SPEAKER_ID}]

    class FakeQuery:
        def update(self, payload):
            captured.update(payload)
            return self

        def eq(self, *_args, **_kwargs):
            return self

        def execute(self):
            return FakeResult()

    class FakeTable:
        def update(self, payload):
            return FakeQuery().update(payload)

    class FakeClient:
        def table(self, _name):
            return FakeTable()

    monkeypatch.setattr("app.routers.contributions.get_supabase", lambda: FakeClient())
    contribution_id = uuid4()
    response = client.post(
        f"/api/v1/contributions/{contribution_id}/review",
        json={"status": "approved", "reviewed_by": spoofed},
        headers=keeper_headers,
    )
    assert response.status_code == 200
    assert captured["reviewed_by"] == KEEPER_SPEAKER_ID
    assert captured["reviewed_by"] != spoofed


def test_invalid_token_denied(client):
    response = client.get(
        "/api/v1/lexicon",
        headers={"Authorization": "Bearer not-a-real-token"},
    )
    assert response.status_code == 401


def test_wrong_dev_issuer_denied(client):
    token = jwt_with_other_issuer()
    response = client.get(
        "/api/v1/lexicon",
        headers={"Authorization": f"Bearer {token}"},
    )
    assert response.status_code == 401


def jwt_with_other_issuer() -> str:
    import jwt as pyjwt

    return pyjwt.encode(
        {"iss": "https://evil.example", "sub": "user_x", "role": "keeper"},
        "test-auth-dev-secret",
        algorithm="HS256",
    )


def test_dev_token_helper_roundtrip():
    token = make_dev_token()
    assert isinstance(token, str)
    assert token.count(".") == 2
