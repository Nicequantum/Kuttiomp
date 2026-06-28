-- =============================================================================
-- Kuttiomp Migration 004: Final Foundation Hardening
--
-- DEPENDS ON (apply in order):
--   001_initial_schema.sql
--   002_advanced_linguistic_schema.sql
--   003_performance_indexes.sql
--
-- After applying, foundation schema version = 004
-- =============================================================================

-- Migration tracking table
CREATE TABLE IF NOT EXISTS schema_migrations (
  version TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  applied_at TIMESTAMPTZ DEFAULT NOW(),
  description TEXT
);

-- Record all migrations (idempotent)
INSERT INTO schema_migrations (version, name, description) VALUES
  ('001', 'initial_schema', 'Core tables, speakers, lexicon, audio, seed data'),
  ('002', 'advanced_linguistic_schema', 'PostGIS, orthographies, cultural contexts, contributions'),
  ('003', 'performance_indexes', 'Performance indexes and integrity constraints'),
  ('004', 'final_hardening', 'Migration tracking, final constraints, foundation complete')
ON CONFLICT (version) DO NOTHING;

-- Ensure required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS postgis;

-- Final integrity constraints (idempotent)
DO $$ BEGIN
  ALTER TABLE lexical_entries
    ADD CONSTRAINT chk_lexical_sacred_visibility
    CHECK (NOT (is_sacred = true AND visibility = 'public'));
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  ALTER TABLE audio_recordings
    ADD CONSTRAINT chk_audio_speaker_required
    CHECK (speaker_id IS NOT NULL);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Link example_sentences audio FK if missing
DO $$ BEGIN
  ALTER TABLE example_sentences
    ADD CONSTRAINT fk_example_audio
    FOREIGN KEY (audio_recording_id) REFERENCES audio_recordings(id) ON DELETE SET NULL;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Protocol version for foundation complete
INSERT INTO protocol_versions (version, changelog, effective_date)
SELECT '2.1', 'Foundation phase complete — ready for data population', CURRENT_DATE
WHERE NOT EXISTS (SELECT 1 FROM protocol_versions WHERE version = '2.1');

-- Enable RLS on schema_migrations (service role only)
ALTER TABLE schema_migrations ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  CREATE POLICY "Service role access on schema_migrations"
    ON schema_migrations FOR ALL
    USING (auth.role() = 'service_role');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- Foundation readiness view
CREATE OR REPLACE VIEW foundation_status AS
SELECT
  (SELECT COUNT(*) FROM schema_migrations) AS migrations_applied,
  (SELECT MAX(version) FROM schema_migrations) AS latest_migration,
  (SELECT COUNT(*) FROM speakers WHERE is_active = true) AS active_speakers,
  (SELECT COUNT(*) FROM lexical_entries) AS lexical_entries,
  (SELECT COUNT(*) FROM orthographies) AS orthography_systems,
  '004' AS expected_migration,
  (SELECT MAX(version) FROM schema_migrations) = '004' AS foundation_ready;