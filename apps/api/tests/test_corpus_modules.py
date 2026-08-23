from tests.fakes import MutableClient
from tests.test_forge_authz import FORGE_ROWS


def _store(**env_extra):
    env = {
        "id": "default",
        "corpus_mode": "demo_historical",
        "feed_historical": True,
        "feed_approved_living": True,
        "feed_forge_demo_merge": True,
        "updated_by": None,
        "updated_at": "2026-08-17T00:00:00Z",
    }
    env.update(env_extra)
    return MutableClient(
        {
            "language_forge_entries": FORGE_ROWS,
            "app_environment": [env],
            "lexical_entries": [
                {
                    "id": "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee",
                    "word_narragansett": "nétop",
                    "english_gloss": "friend",
                    "is_neologism": False,
                }
            ],
            "corpus_module_audit": [],
            "forge_comments": [],
            "forge_audit_log": [],
            "forge_example_sentences": [],
            "forge_cognate_references": [],
        }
    )


def _words(client):
    body = client.get("/api/v1/forge/public/learner-feed").json()
    return [row["wordNarragansett"] for row in body["words"]], body


def test_keeper_cannot_patch_corpus(client, keeper_headers, monkeypatch):
    store = _store()
    monkeypatch.setattr("app.routers.forge.get_supabase", lambda: store)
    response = client.patch(
        "/api/v1/forge/corpus",
        json={"feedForgeDemoMerge": False},
        headers=keeper_headers,
    )
    assert response.status_code == 403
    assert store.rows_by_table["app_environment"][0]["feed_forge_demo_merge"] is True


def test_elder_converts_teaching_feed_off(client, elder_headers, monkeypatch):
    store = _store()
    monkeypatch.setattr("app.routers.forge.get_supabase", lambda: store)

    words, body = _words(client)
    assert "wunnegan" in words
    assert "anunckquat" in words
    assert "restricted-form" not in words
    assert body["corpusMode"] == "demo_historical"

    response = client.patch(
        "/api/v1/forge/corpus",
        json={"feedForgeDemoMerge": False},
        headers=elder_headers,
    )
    assert response.status_code == 200
    desk = response.json()
    assert desk["corpusMode"] == "keeper_only"
    assert desk["modules"]["feedForgeDemoMerge"] is False
    assert desk["modules"]["feedApprovedLiving"] is True
    assert desk["preview"]["teachingDrafts"] == 1
    assert desk["preview"]["learnerTotal"] == 2  # 1643 seed + released living

    words, body = _words(client)
    assert "wunnegan" not in words
    assert "anunckquat" in words
    assert "restricted-form" not in words
    assert body["corpusMode"] == "keeper_only"
    assert body["modules"]["feedForgeDemoMerge"] is False

    env = store.rows_by_table["app_environment"][0]
    assert env["corpus_mode"] == "keeper_only"
    assert env["feed_forge_demo_merge"] is False
    audit = store.rows_by_table["corpus_module_audit"]
    assert len(audit) == 1
    assert audit[0]["module_key"] == "feedForgeDemoMerge"
    assert "off" in audit[0]["summary"]


def test_elder_patch_accepts_snake_case(client, elder_headers, monkeypatch):
    store = _store()
    monkeypatch.setattr("app.routers.forge.get_supabase", lambda: store)
    response = client.patch(
        "/api/v1/forge/corpus",
        json={"feed_approved_living": False},
        headers=elder_headers,
    )
    assert response.status_code == 200
    words, _ = _words(client)
    assert "anunckquat" not in words
    assert "wunnegan" in words


def test_patch_noop_skips_audit(client, elder_headers, monkeypatch):
    store = _store()
    monkeypatch.setattr("app.routers.forge.get_supabase", lambda: store)
    response = client.patch(
        "/api/v1/forge/corpus",
        json={"feedForgeDemoMerge": True},
        headers=elder_headers,
    )
    assert response.status_code == 200
    assert response.json()["corpusMode"] == "demo_historical"
    assert store.rows_by_table["corpus_module_audit"] == []


def test_corpus_path_is_not_swallowed_as_entry_id(client, keeper_headers, monkeypatch):
    store = _store()
    monkeypatch.setattr("app.routers.forge.get_supabase", lambda: store)
    response = client.get("/api/v1/forge/corpus", headers=keeper_headers)
    assert response.status_code == 200
    assert "modules" in response.json()
