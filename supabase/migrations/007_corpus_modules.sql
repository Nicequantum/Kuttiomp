-- Modular learner-corpus feeds.
-- The Forge itself stays Keepers-only. These flags only control what
-- families see in kuttiomp-learn / GET /api/v1/forge/public/learner-feed.
--
-- feed_historical        — 1643 attested seed (stored for Stewardship; public lexicon gate is unchanged)
-- feed_approved_living   — Forge words Sharente marked production-ready
-- feed_forge_demo_merge  — unapproved demo-visible Forge drafts (teaching feed)
--
-- corpus_mode stays as a derived alias:
--   demo_historical <=> teaching-feed ON
--   keeper_only     <=> teaching-feed OFF

ALTER TABLE app_environment
  ADD COLUMN IF NOT EXISTS feed_historical BOOLEAN NOT NULL DEFAULT true;

ALTER TABLE app_environment
  ADD COLUMN IF NOT EXISTS feed_approved_living BOOLEAN NOT NULL DEFAULT true;

ALTER TABLE app_environment
  ADD COLUMN IF NOT EXISTS feed_forge_demo_merge BOOLEAN NOT NULL DEFAULT true;

UPDATE app_environment
   SET feed_forge_demo_merge = (corpus_mode = 'demo_historical')
 WHERE id = 'default';

COMMENT ON COLUMN app_environment.feed_forge_demo_merge IS
  'Teaching feed. When true, unapproved demo-visible Forge drafts may surface to learners. Turning this off converts the public desk from demo to real keeper knowledge.';
COMMENT ON COLUMN app_environment.feed_approved_living IS
  'When true, Forge words that are approved and production-ready appear in the learner feed.';
COMMENT ON COLUMN app_environment.feed_historical IS
  'When true, 1643 attested seed may appear on the learner desk. Does not delete records.';
COMMENT ON COLUMN app_environment.corpus_mode IS
  'Derived alias of feed_forge_demo_merge: demo_historical when teaching feed is on, keeper_only when off.';

CREATE TABLE IF NOT EXISTS corpus_module_audit (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  actor_id UUID REFERENCES speakers(id),
  module_key TEXT NOT NULL,
  old_value TEXT,
  new_value TEXT,
  summary TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS corpus_module_audit_created_idx
  ON corpus_module_audit (created_at DESC);

ALTER TABLE corpus_module_audit ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Service role full access on corpus_module_audit"
  ON corpus_module_audit FOR ALL
  USING (auth.role() = 'service_role');
