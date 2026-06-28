-- =============================================================================
-- Kuttiomp Migration 002: Advanced Linguistic & Cultural Schema
-- PostGIS land knowledge, orthographies, cultural contexts, contributions
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS postgis;

-- =============================================================================
-- NEW ENUMS
-- =============================================================================

CREATE TYPE gender_expression AS ENUM (
  'feminine', 'masculine', 'two_spirit', 'non_binary',
  'not_specified', 'culturally_specific'
);

CREATE TYPE cultural_authority_level AS ENUM (
  'elder_keeper', 'knowledge_keeper', 'sharente_keeper',
  'clan_teacher', 'family_teacher', 'learner', 'guest'
);

CREATE TYPE semantic_domain AS ENUM (
  'flora', 'fauna', 'weather', 'water', 'geography', 'kinship',
  'ceremony', 'tools', 'food', 'medicine', 'spiritual', 'governance',
  'emotion', 'movement', 'time', 'color', 'other'
);

CREATE TYPE seasonal_usage AS ENUM (
  'spring', 'summer', 'fall', 'winter', 'year_round',
  'ceremonial_season', 'harvest', 'planting'
);

CREATE TYPE spiritual_significance AS ENUM (
  'none', 'respectful', 'ceremonial', 'sacred', 'restricted'
);

CREATE TYPE orthography_system AS ENUM (
  'costa_transcription', 'jopson_modern', 'ipa',
  'historical_manuscript', 'community_preferred', 'learner_phonetic'
);

CREATE TYPE cultural_context_type AS ENUM (
  'mother_earth', 'ceremony', 'traditional_ecological_knowledge',
  'kinship', 'seasonal_cycle', 'spiritual_significance',
  'historical', 'contemporary_usage'
);

CREATE TYPE contribution_type AS ENUM (
  'lexical_entry', 'audio_recording', 'pronunciation_variant',
  'cultural_narrative', 'land_knowledge', 'example_sentence', 'orthography_note'
);

-- Extend approval_status
ALTER TYPE approval_status ADD VALUE IF NOT EXISTS 'draft';
ALTER TYPE approval_status ADD VALUE IF NOT EXISTS 'under_review';
ALTER TYPE approval_status ADD VALUE IF NOT EXISTS 'archived';

-- =============================================================================
-- SPEAKER PROFILE ENHANCEMENTS
-- =============================================================================

ALTER TABLE speakers
  ADD COLUMN IF NOT EXISTS gender_expression gender_expression DEFAULT 'not_specified',
  ADD COLUMN IF NOT EXISTS cultural_authority cultural_authority_level DEFAULT 'family_teacher',
  ADD COLUMN IF NOT EXISTS voice_pitch_range TEXT,
  ADD COLUMN IF NOT EXISTS voice_tempo TEXT,
  ADD COLUMN IF NOT EXISTS voice_quality_notes TEXT,
  ADD COLUMN IF NOT EXISTS languages_spoken TEXT[] DEFAULT '{}';

ALTER TABLE clans
  ADD COLUMN IF NOT EXISTS clan_plant TEXT;

UPDATE speakers SET
  gender_expression = 'two_spirit',
  cultural_authority = 'sharente_keeper'
WHERE role = 'sharente';

UPDATE speakers SET
  cultural_authority = 'elder_keeper'
WHERE is_elder = true AND role IN ('grandmother', 'grandfather');

-- =============================================================================
-- ORTHOGRAPHY SYSTEMS
-- =============================================================================

CREATE TABLE orthographies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  system_key orthography_system NOT NULL UNIQUE,
  name TEXT NOT NULL,
  description TEXT,
  character_inventory TEXT,
  is_primary BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO orthographies (system_key, name, description, is_primary) VALUES
('costa_transcription', 'Costa Transcription', 'Historical transcription system used in early Narragansett documentation', false),
('jopson_modern', 'Jopson Modern Orthography', 'Contemporary community-preferred spelling conventions', true),
('ipa', 'International Phonetic Alphabet', 'Phonetic transcription for linguistic analysis', false),
('community_preferred', 'Community Preferred', 'Preferred spelling as determined by Knowledge Keepers', true),
('learner_phonetic', 'Learner Phonetic', 'Simplified phonetic guide for language learners', false);

-- =============================================================================
-- LEXICAL ENTRY ENHANCEMENTS
-- =============================================================================

ALTER TABLE lexical_entries
  ADD COLUMN IF NOT EXISTS english_gloss_extended TEXT,
  ADD COLUMN IF NOT EXISTS phonemic_transcription TEXT,
  ADD COLUMN IF NOT EXISTS morpheme_gloss TEXT,
  ADD COLUMN IF NOT EXISTS etymology_source TEXT,
  ADD COLUMN IF NOT EXISTS register TEXT,
  ADD COLUMN IF NOT EXISTS semantic_domain semantic_domain DEFAULT 'other',
  ADD COLUMN IF NOT EXISTS ecological_connection TEXT,
  ADD COLUMN IF NOT EXISTS seasonal_usage seasonal_usage[] DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS spiritual_significance spiritual_significance DEFAULT 'none',
  ADD COLUMN IF NOT EXISTS cultural_context_summary TEXT,
  ADD COLUMN IF NOT EXISTS is_neologism BOOLEAN DEFAULT false,
  ADD COLUMN IF NOT EXISTS primary_orthography_id UUID REFERENCES orthographies(id);

CREATE TABLE spelling_variants (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  lexical_entry_id UUID NOT NULL REFERENCES lexical_entries(id) ON DELETE CASCADE,
  orthography_id UUID NOT NULL REFERENCES orthographies(id),
  spelling TEXT NOT NULL,
  notes TEXT,
  speaker_id UUID REFERENCES speakers(id),
  is_preferred BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(lexical_entry_id, orthography_id, spelling)
);

CREATE TABLE example_sentences (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  lexical_entry_id UUID NOT NULL REFERENCES lexical_entries(id) ON DELETE CASCADE,
  sentence_narragansett TEXT NOT NULL,
  sentence_english TEXT NOT NULL,
  literal_gloss TEXT,
  cultural_context TEXT,
  speaker_id UUID REFERENCES speakers(id),
  audio_recording_id UUID,
  approval_status approval_status DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================================================
-- CULTURAL CONTEXT SYSTEM
-- =============================================================================

CREATE TABLE cultural_contexts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  lexical_entry_id UUID REFERENCES lexical_entries(id) ON DELETE CASCADE,
  context_type cultural_context_type NOT NULL,
  title TEXT NOT NULL,
  narrative TEXT NOT NULL,
  mother_earth_connection TEXT,
  ceremonial_notes TEXT,
  tek_notes TEXT,
  seasonal_usage TEXT,
  spiritual_significance TEXT,
  speaker_id UUID REFERENCES speakers(id),
  visibility content_visibility DEFAULT 'clan',
  approval_status approval_status DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_cultural_contexts_entry ON cultural_contexts(lexical_entry_id);
CREATE INDEX idx_cultural_contexts_type ON cultural_contexts(context_type);

-- =============================================================================
-- CULTURAL NARRATIVES (enhanced stories)
-- =============================================================================

ALTER TABLE stories RENAME TO cultural_narratives;

ALTER TABLE cultural_narratives
  ADD COLUMN IF NOT EXISTS narrative_type TEXT DEFAULT 'teaching',
  ADD COLUMN IF NOT EXISTS land_site_id UUID,
  ADD COLUMN IF NOT EXISTS linked_lexical_entries UUID[] DEFAULT '{}';

CREATE TABLE lexical_narrative_links (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  lexical_entry_id UUID NOT NULL REFERENCES lexical_entries(id) ON DELETE CASCADE,
  narrative_id UUID NOT NULL REFERENCES cultural_narratives(id) ON DELETE CASCADE,
  relationship_type TEXT NOT NULL DEFAULT 'appears_in',
  notes TEXT,
  UNIQUE(lexical_entry_id, narrative_id)
);

-- =============================================================================
-- LAND-BASED KNOWLEDGE (PostGIS)
-- =============================================================================

CREATE TABLE land_knowledge_sites (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name_narragansett TEXT NOT NULL,
  name_english TEXT,
  description TEXT,
  site_type TEXT NOT NULL DEFAULT 'general',
  location GEOGRAPHY(POINT, 4326) NOT NULL,
  elevation_meters NUMERIC(8,2),
  ecological_zone TEXT,
  cultural_significance TEXT,
  seasonal_relevance TEXT,
  tek_description TEXT,
  speaker_id UUID REFERENCES speakers(id),
  visibility content_visibility DEFAULT 'clan',
  approval_status approval_status DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_land_sites_location ON land_knowledge_sites USING GIST(location);

CREATE TABLE lexical_land_links (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  lexical_entry_id UUID NOT NULL REFERENCES lexical_entries(id) ON DELETE CASCADE,
  land_site_id UUID NOT NULL REFERENCES land_knowledge_sites(id) ON DELETE CASCADE,
  relationship_type TEXT DEFAULT 'found_at',
  notes TEXT,
  UNIQUE(lexical_entry_id, land_site_id)
);

-- Add FK for cultural_narratives.land_site_id
ALTER TABLE cultural_narratives
  ADD CONSTRAINT fk_narrative_land_site
  FOREIGN KEY (land_site_id) REFERENCES land_knowledge_sites(id) ON DELETE SET NULL;

-- =============================================================================
-- AUDIO RECORDING ENHANCEMENTS
-- =============================================================================

ALTER TABLE audio_recordings
  ADD COLUMN IF NOT EXISTS bit_depth INTEGER,
  ADD COLUMN IF NOT EXISTS channels INTEGER DEFAULT 1,
  ADD COLUMN IF NOT EXISTS signal_to_noise NUMERIC(5,2),
  ADD COLUMN IF NOT EXISTS context_tags TEXT[] DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS land_site_id UUID REFERENCES land_knowledge_sites(id),
  ADD COLUMN IF NOT EXISTS waveform_data JSONB;

-- =============================================================================
-- KNOWLEDGE KEEPER CONTRIBUTION WORKFLOW
-- =============================================================================

CREATE TABLE knowledge_contributions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  contributor_speaker_id UUID NOT NULL REFERENCES speakers(id),
  contribution_type contribution_type NOT NULL,
  entity_id UUID NOT NULL,
  entity_type TEXT NOT NULL,
  submission_notes TEXT,
  status approval_status DEFAULT 'draft',
  reviewed_by UUID REFERENCES speakers(id),
  reviewed_at TIMESTAMPTZ,
  review_notes TEXT,
  protocol_acknowledgments INTEGER[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_contributions_status ON knowledge_contributions(status);
CREATE INDEX idx_contributions_contributor ON knowledge_contributions(contributor_speaker_id);

-- =============================================================================
-- CULTURAL DOMAIN HIERARCHY
-- =============================================================================

ALTER TABLE cultural_domains
  ADD COLUMN IF NOT EXISTS parent_domain_id UUID REFERENCES cultural_domains(id);

-- =============================================================================
-- GOVERNANCE: PROTOCOL VERSION TRACKING
-- =============================================================================

CREATE TABLE protocol_versions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  version TEXT NOT NULL,
  protocol_count INTEGER NOT NULL DEFAULT 12,
  changelog TEXT,
  approved_by UUID REFERENCES speakers(id),
  effective_date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO protocol_versions (version, changelog, effective_date) VALUES
('1.0', 'Initial 10 protocols', '2026-01-01'),
('2.0', 'Added Protocol 11 (Land Relationship) and Protocol 12 (Orthographic Integrity)', '2026-06-28');

-- =============================================================================
-- RLS FOR NEW TABLES
-- =============================================================================

ALTER TABLE cultural_contexts ENABLE ROW LEVEL SECURITY;
ALTER TABLE land_knowledge_sites ENABLE ROW LEVEL SECURITY;
ALTER TABLE knowledge_contributions ENABLE ROW LEVEL SECURITY;
ALTER TABLE orthographies ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Service role full access on cultural_contexts"
  ON cultural_contexts FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on land_knowledge_sites"
  ON land_knowledge_sites FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on knowledge_contributions"
  ON knowledge_contributions FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on orthographies"
  ON orthographies FOR ALL USING (auth.role() = 'service_role');

-- =============================================================================
-- SEED: Cultural Context for sample entries
-- =============================================================================

INSERT INTO cultural_contexts (lexical_entry_id, context_type, title, narrative, mother_earth_connection, speaker_id, visibility, approval_status)
SELECT id, 'mother_earth', 'Greeting the Day',
  'Wunnegan is spoken upon meeting another person or entering a shared space. It acknowledges both the person and the land beneath your feet.',
  'The greeting connects speaker to place — you do not greet only the person, but the earth that holds you both.',
  'b0000000-0000-0000-0000-000000000001', 'public', 'approved'
FROM lexical_entries WHERE word_normalized = 'wunnegan' LIMIT 1;

INSERT INTO cultural_contexts (lexical_entry_id, context_type, title, narrative, ceremonial_notes, speaker_id, visibility, approval_status)
SELECT id, 'kinship', 'Two-Spirit Kinship Honor',
  'Sharente is used with deep respect to honor those who carry Two-Spirit roles in Narragansett society. This term must never be used dismissively or without cultural understanding.',
  'Used in contexts of respect and acknowledgment, not casual reference.',
  'b0000000-0000-0000-0000-000000000003', 'clan', 'approved'
FROM lexical_entries WHERE word_normalized = 'sharente' LIMIT 1;

-- =============================================================================
-- TRIGGERS
-- =============================================================================

CREATE TRIGGER cultural_contexts_updated_at
  BEFORE UPDATE ON cultural_contexts
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER land_knowledge_sites_updated_at
  BEFORE UPDATE ON land_knowledge_sites
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER knowledge_contributions_updated_at
  BEFORE UPDATE ON knowledge_contributions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();