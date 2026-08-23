-- =============================================================================
-- Kuttiomp Migration 006: Narragansett Language Forge
-- Knowledge Keeper–only neologism dossiers. Not a public creation surface.
-- Approved + production-ready rows may publish into lexical_entries (is_neologism).
-- Learner app (kuttiomp-learn) consumes only what public lexicon endpoints allow.
-- =============================================================================

CREATE TYPE forge_status AS ENUM (
  'draft',
  'proposed',
  'under_review',
  'needs_revision',
  'approved',
  'rejected',
  'archived'
);

CREATE TYPE forge_derivation_type AS ENUM (
  'compound',
  'derivation',
  'calque',
  'neologism_from_existing_root',
  'analogical_formation',
  'semantic_extension',
  'reconstructed_from_cognates',
  'borrowing_adapted'
);

CREATE TYPE forge_attestation_status AS ENUM (
  'fully_modern_creation',
  'partial_historical_basis',
  'analogical_from_attested',
  'calque_of_english',
  'reconstructed_from_cognates',
  'semantic_extension'
);

CREATE TABLE IF NOT EXISTS app_environment (
  id TEXT PRIMARY KEY DEFAULT 'default',
  corpus_mode TEXT NOT NULL DEFAULT 'demo_historical'
    CHECK (corpus_mode IN ('demo_historical', 'keeper_only')),
  updated_by UUID REFERENCES speakers(id),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO app_environment (id, corpus_mode)
VALUES ('default', 'demo_historical')
ON CONFLICT (id) DO NOTHING;

CREATE TABLE language_forge_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  proposed_word TEXT NOT NULL,
  word_normalized TEXT NOT NULL,
  english_gloss TEXT NOT NULL,
  english_meaning TEXT,
  part_of_speech lexical_category NOT NULL DEFAULT 'other',
  semantic_domain semantic_domain NOT NULL DEFAULT 'other',
  spiritual_significance spiritual_significance NOT NULL DEFAULT 'none',
  visibility content_visibility NOT NULL DEFAULT 'clan',
  orthographic_form TEXT,
  phonemic_transcription TEXT,
  ipa_transcription TEXT,
  pronunciation_notes TEXT,
  stress_pattern TEXT,
  morphological_breakdown TEXT,
  morpheme_gloss TEXT,
  derivation_type forge_derivation_type,
  generation_rule TEXT,
  source_roots_or_stems JSONB NOT NULL DEFAULT '[]'::jsonb,
  related_existing_words JSONB NOT NULL DEFAULT '[]'::jsonb,
  algonquian_cognates TEXT,
  proto_algonquian_or_deeper_roots TEXT,
  historical_attestation_status forge_attestation_status,
  source_citations TEXT,
  linguistic_justification TEXT,
  cultural_notes TEXT,
  confidence_score INTEGER NOT NULL DEFAULT 50
    CHECK (confidence_score >= 0 AND confidence_score <= 100),
  confidence_rationale TEXT,
  potential_issues TEXT,
  usage_notes TEXT,
  collocations TEXT,
  status forge_status NOT NULL DEFAULT 'draft',
  submitted_by UUID REFERENCES speakers(id),
  submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_updated_by UUID REFERENCES speakers(id),
  last_updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  reviewed_by UUID REFERENCES speakers(id),
  reviewed_at TIMESTAMPTZ,
  approval_notes TEXT,
  version INTEGER NOT NULL DEFAULT 1,
  is_demo_visible BOOLEAN NOT NULL DEFAULT false,
  is_production_ready BOOLEAN NOT NULL DEFAULT false,
  tags TEXT[] NOT NULL DEFAULT '{}',
  lexical_entry_id UUID REFERENCES lexical_entries(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX forge_status_idx ON language_forge_entries (status);
CREATE INDEX forge_domain_idx ON language_forge_entries (semantic_domain);
CREATE INDEX forge_word_trgm_idx ON language_forge_entries USING gin (word_normalized gin_trgm_ops);
CREATE INDEX forge_updated_idx ON language_forge_entries (last_updated_at DESC);
CREATE INDEX forge_submitter_idx ON language_forge_entries (submitted_by);

CREATE TABLE forge_example_sentences (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  entry_id UUID NOT NULL REFERENCES language_forge_entries(id) ON DELETE CASCADE,
  narragansett TEXT NOT NULL,
  english TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE forge_comments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  entry_id UUID NOT NULL REFERENCES language_forge_entries(id) ON DELETE CASCADE,
  author_id UUID REFERENCES speakers(id),
  body TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE forge_audit_log (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  entry_id UUID NOT NULL REFERENCES language_forge_entries(id) ON DELETE CASCADE,
  actor_id UUID REFERENCES speakers(id),
  action TEXT NOT NULL,
  field_name TEXT,
  old_value TEXT,
  new_value TEXT,
  summary TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE forge_attachments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  entry_id UUID NOT NULL REFERENCES language_forge_entries(id) ON DELETE CASCADE,
  uploaded_by UUID REFERENCES speakers(id),
  title TEXT NOT NULL,
  kind TEXT NOT NULL DEFAULT 'note',
  url_or_note TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE forge_cognate_references (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  entry_id UUID NOT NULL REFERENCES language_forge_entries(id) ON DELETE CASCADE,
  language_name TEXT NOT NULL,
  form TEXT NOT NULL,
  gloss TEXT,
  source TEXT,
  notes TEXT
);

CREATE TABLE forge_related_entries (
  entry_id UUID NOT NULL REFERENCES language_forge_entries(id) ON DELETE CASCADE,
  related_entry_id UUID NOT NULL REFERENCES language_forge_entries(id) ON DELETE CASCADE,
  relation_type TEXT NOT NULL DEFAULT 'related',
  PRIMARY KEY (entry_id, related_entry_id)
);

CREATE INDEX forge_comments_entry_idx ON forge_comments (entry_id, created_at);
CREATE INDEX forge_audit_entry_idx ON forge_audit_log (entry_id, created_at);

COMMENT ON TABLE language_forge_entries IS
  'Keeper-only neologism dossiers. Never expose create/update on kuttiomp-learn.';
COMMENT ON COLUMN language_forge_entries.is_demo_visible IS
  'If true and corpus_mode=demo_historical, unapproved entries may surface to learners for teaching the method.';
COMMENT ON COLUMN language_forge_entries.is_production_ready IS
  'Sharente/elder flag. Required with status=approved before learner production (keeper_only).';

-- Keeper-only: learners never query these tables via PostgREST.
-- FastAPI public forge-feed uses the service role, then filters sacred/status in Python.
ALTER TABLE app_environment ENABLE ROW LEVEL SECURITY;
ALTER TABLE language_forge_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE forge_example_sentences ENABLE ROW LEVEL SECURITY;
ALTER TABLE forge_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE forge_audit_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE forge_attachments ENABLE ROW LEVEL SECURITY;
ALTER TABLE forge_cognate_references ENABLE ROW LEVEL SECURITY;
ALTER TABLE forge_related_entries ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Service role full access on app_environment"
  ON app_environment FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on language_forge_entries"
  ON language_forge_entries FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on forge_example_sentences"
  ON forge_example_sentences FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on forge_comments"
  ON forge_comments FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on forge_audit_log"
  ON forge_audit_log FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on forge_attachments"
  ON forge_attachments FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on forge_cognate_references"
  ON forge_cognate_references FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on forge_related_entries"
  ON forge_related_entries FOR ALL
  USING (auth.role() = 'service_role');

