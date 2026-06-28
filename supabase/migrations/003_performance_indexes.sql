-- =============================================================================
-- Kuttiomp Migration 003: Performance & Integrity Indexes
-- =============================================================================

-- Lexical entries: common query patterns
CREATE INDEX IF NOT EXISTS idx_lexical_approval ON lexical_entries(approval_status);
CREATE INDEX IF NOT EXISTS idx_lexical_visibility_approval ON lexical_entries(visibility, approval_status);
CREATE INDEX IF NOT EXISTS idx_lexical_semantic_domain ON lexical_entries(semantic_domain);
CREATE INDEX IF NOT EXISTS idx_lexical_primary_speaker ON lexical_entries(primary_speaker_id);
CREATE INDEX IF NOT EXISTS idx_lexical_spiritual ON lexical_entries(spiritual_significance) WHERE spiritual_significance != 'none';
CREATE INDEX IF NOT EXISTS idx_lexical_sacred ON lexical_entries(is_sacred) WHERE is_sacred = true;

-- Audio recordings
CREATE INDEX IF NOT EXISTS idx_audio_approval ON audio_recordings(approval_status);
CREATE INDEX IF NOT EXISTS idx_audio_quality ON audio_recordings(quality);
CREATE INDEX IF NOT EXISTS idx_audio_created ON audio_recordings(created_at DESC);

-- Cultural contexts
CREATE INDEX IF NOT EXISTS idx_cultural_contexts_approval ON cultural_contexts(approval_status);
CREATE INDEX IF NOT EXISTS idx_cultural_contexts_visibility ON cultural_contexts(visibility);

-- Knowledge contributions
CREATE INDEX IF NOT EXISTS idx_contributions_type ON knowledge_contributions(contribution_type);
CREATE INDEX IF NOT EXISTS idx_contributions_entity ON knowledge_contributions(entity_type, entity_id);

-- Land sites
CREATE INDEX IF NOT EXISTS idx_land_sites_type ON land_knowledge_sites(site_type);
CREATE INDEX IF NOT EXISTS idx_land_sites_approval ON land_knowledge_sites(approval_status);

-- Speakers
CREATE INDEX IF NOT EXISTS idx_speakers_authority ON speakers(cultural_authority);
CREATE INDEX IF NOT EXISTS idx_speakers_active_clan ON speakers(clan_id) WHERE is_active = true;

-- Spelling variants
CREATE INDEX IF NOT EXISTS idx_spelling_variants_entry ON spelling_variants(lexical_entry_id);
CREATE INDEX IF NOT EXISTS idx_spelling_variants_orthography ON spelling_variants(orthography_id);

-- Example sentences
CREATE INDEX IF NOT EXISTS idx_example_sentences_entry ON example_sentences(lexical_entry_id);

-- Audit log (temporal queries)
CREATE INDEX IF NOT EXISTS idx_audit_log_created ON audit_log(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_log_entity ON audit_log(entity_type, entity_id);

-- Integrity: prevent self-referential speaker parent
ALTER TABLE speakers DROP CONSTRAINT IF EXISTS speakers_no_self_parent;
ALTER TABLE speakers ADD CONSTRAINT speakers_no_self_parent
  CHECK (parent_speaker_id IS NULL OR parent_speaker_id != id);