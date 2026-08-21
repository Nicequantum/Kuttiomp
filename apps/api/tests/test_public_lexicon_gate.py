from app.services.public_lexicon import ALLOWED_SPIRITUAL, apply_publish_gate, is_publishable_row
from tests.fakes import FilteringClient, FilteringQuery

SACRED_ID = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
PUBLIC_ID = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
CLAN_ID = "cccccccc-cccc-cccc-cccc-cccccccccccc"
PENDING_ID = "dddddddd-dddd-dddd-dddd-dddddddddddd"

CORPUS = [
    {
        "id": SACRED_ID,
        "word_narragansett": "restricted-word",
        "english_gloss": "should not leak",
        "approval_status": "approved",
        "visibility": "public",
        "is_sacred": True,
        "spiritual_significance": "none",
        "semantic_domain": "other",
        "updated_at": "2026-01-01T00:00:00Z",
        "category": "other",
    },
    {
        "id": PUBLIC_ID,
        "word_narragansett": "wunnegan",
        "english_gloss": "welcome",
        "approval_status": "approved",
        "visibility": "public",
        "is_sacred": False,
        "spiritual_significance": "none",
        "semantic_domain": "other",
        "updated_at": "2026-01-01T00:00:00Z",
        "category": "interjection",
    },
    {
        "id": CLAN_ID,
        "word_narragansett": "clan-word",
        "english_gloss": "clan only",
        "approval_status": "approved",
        "visibility": "clan",
        "is_sacred": False,
        "spiritual_significance": "none",
        "semantic_domain": "other",
        "updated_at": "2026-01-01T00:00:00Z",
        "category": "other",
    },
    {
        "id": PENDING_ID,
        "word_narragansett": "draft-word",
        "english_gloss": "not approved",
        "approval_status": "pending",
        "visibility": "public",
        "is_sacred": False,
        "spiritual_significance": "none",
        "semantic_domain": "other",
        "updated_at": "2026-01-01T00:00:00Z",
        "category": "other",
    },
]


def _row(**overrides):
    base = {
        "approval_status": "approved",
        "visibility": "public",
        "is_sacred": False,
        "spiritual_significance": "none",
        "english_gloss": "welcome",
    }
    base.update(overrides)
    return base


def test_publish_gate_allows_public_approved():
    assert is_publishable_row(_row()) is True


def test_publish_gate_excludes_sacred_and_restricted_visibility():
    assert is_publishable_row(_row(is_sacred=True)) is False
    assert is_publishable_row(_row(visibility="sacred")) is False
    assert is_publishable_row(_row(visibility="elders_only")) is False
    assert is_publishable_row(_row(visibility="clan")) is False
    assert is_publishable_row(_row(visibility="family")) is False


def test_apply_publish_gate_sql_filters():
    query = FilteringQuery(CORPUS)
    gated = apply_publish_gate(query)
    result = gated.execute()
    ids = {row["id"] for row in result.data}
    assert ids == {PUBLIC_ID}
    assert ("eq", "approval_status", "approved") in query.applied
    assert ("eq", "visibility", "public") in query.applied
    assert ("eq", "is_sacred", False) in query.applied
    assert ("in_", "spiritual_significance", list(ALLOWED_SPIRITUAL)) in query.applied
    assert ("neq", "english_gloss", "") in query.applied


def test_unauthenticated_public_list_filters_via_sql(client, monkeypatch):
    monkeypatch.setattr(
        "app.services.public_lexicon.get_anon_supabase",
        lambda: FilteringClient({"lexical_entries": CORPUS}),
    )
    monkeypatch.setattr("app.services.public_lexicon._load_primary_audio", lambda _ids: {})

    response = client.get("/api/v1/public/lexicon")
    assert response.status_code == 200
    words = response.json()["words"]
    ids = {word["id"] for word in words}
    assert PUBLIC_ID in ids
    assert SACRED_ID not in ids
    assert CLAN_ID not in ids
    assert PENDING_ID not in ids
    assert all(word["isSacred"] is False for word in words)


def test_public_sacred_id_is_404(client, monkeypatch):
    monkeypatch.setattr(
        "app.services.public_lexicon.get_anon_supabase",
        lambda: FilteringClient({"lexical_entries": CORPUS}),
    )
    monkeypatch.setattr("app.services.public_lexicon._load_primary_audio", lambda _ids: {})

    response = client.get(f"/api/v1/public/lexicon/{SACRED_ID}")
    assert response.status_code == 404
    assert "restricted-word" not in response.text
    assert response.json()["error"]["code"] == "NOT_FOUND"


def test_unauthenticated_public_health_allowed(client, monkeypatch):
    monkeypatch.setattr(
        "app.services.public_lexicon.get_anon_supabase",
        lambda: FilteringClient({"lexical_entries": CORPUS}),
    )
    response = client.get("/api/v1/public/health")
    assert response.status_code == 200
    assert response.json()["service"] == "kuttiomp-public"
