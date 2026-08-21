from app.services.public_lexicon import is_publishable_row


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


def test_publish_gate_excludes_sacred_flag():
    assert is_publishable_row(_row(is_sacred=True)) is False


def test_publish_gate_excludes_sacred_visibility():
    assert is_publishable_row(_row(visibility="sacred")) is False


def test_publish_gate_excludes_elders_only():
    assert is_publishable_row(_row(visibility="elders_only")) is False


def test_publish_gate_excludes_clan():
    assert is_publishable_row(_row(visibility="clan")) is False


def test_publish_gate_excludes_family():
    assert is_publishable_row(_row(visibility="family")) is False


def test_publish_gate_excludes_pending():
    assert is_publishable_row(_row(approval_status="pending")) is False


def test_publish_gate_excludes_restricted_spiritual():
    assert is_publishable_row(_row(spiritual_significance="sacred")) is False
    assert is_publishable_row(_row(spiritual_significance="ceremonial")) is False
    assert is_publishable_row(_row(spiritual_significance="restricted")) is False


def test_publish_gate_excludes_empty_gloss():
    assert is_publishable_row(_row(english_gloss="   ")) is False


def test_public_list_filters_non_publishable(client, monkeypatch):
    sacred = {
        "id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "word_narragansett": "restricted-word",
        "english_gloss": "should not leak",
        "approval_status": "approved",
        "visibility": "public",
        "is_sacred": True,
        "spiritual_significance": "none",
        "semantic_domain": "other",
        "updated_at": "2026-01-01T00:00:00Z",
    }
    public = {
        "id": "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb",
        "word_narragansett": "wunnegan",
        "english_gloss": "welcome",
        "approval_status": "approved",
        "visibility": "public",
        "is_sacred": False,
        "spiritual_significance": "none",
        "semantic_domain": "other",
        "updated_at": "2026-01-01T00:00:00Z",
        "category": "interjection",
    }

    class FakeResult:
        def __init__(self, data):
            self.data = data
            self.count = len(data)

    class FakeQuery:
        def __init__(self, rows):
            self._rows = rows

        def eq(self, *_args, **_kwargs):
            return self

        def in_(self, *_args, **_kwargs):
            return self

        def neq(self, *_args, **_kwargs):
            return self

        def or_(self, *_args, **_kwargs):
            return self

        def order(self, *_args, **_kwargs):
            return self

        def range(self, *_args, **_kwargs):
            return self

        def execute(self):
            return FakeResult(self._rows)

    class FakeTable:
        def select(self, *_args, **_kwargs):
            return FakeQuery([sacred, public])

    class FakeClient:
        def table(self, name):
            assert name == "lexical_entries"
            return FakeTable()

    monkeypatch.setattr(
        "app.services.public_lexicon.get_anon_supabase", lambda: FakeClient()
    )
    monkeypatch.setattr("app.services.public_lexicon._load_primary_audio", lambda _ids: {})

    response = client.get("/api/v1/public/lexicon")
    assert response.status_code == 200
    words = response.json()["words"]
    ids = {word["id"] for word in words}
    assert "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb" in ids
    assert "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa" not in ids
    assert all(word["isSacred"] is False for word in words)
