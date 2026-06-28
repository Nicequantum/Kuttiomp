-- =============================================================================
-- Kuttiomp Database Schema
-- Narragansett Language Revitalization Platform
--
-- This schema honors multi-generational clan-based knowledge transmission,
-- speaker attribution, and cultural protocol for sacred content.
-- =============================================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- =============================================================================
-- ENUMS
-- =============================================================================

CREATE TYPE speaker_role AS ENUM (
  'grandmother',      -- Grandmother Comus and elder matriarchs
  'grandfather',      -- Grandfather and elder patriarchs
  'sharente',         -- Two-Spirit knowledge keepers
  'parent',           -- Parents / aunties / uncles
  'sibling',          -- Siblings and cousins
  'clan_member',      -- Extended clan members
  'learner',          -- Language learners (attributed separately)
  'guest_speaker'     -- Honored guests with limited attribution
);

CREATE TYPE generation_tier AS ENUM (
  'elder',            -- First-generation knowledge keepers
  'middle',           -- Second generation
  'younger',          -- Third generation and beyond
  'ancestral'         -- Recorded ancestral voices (archival)
);

CREATE TYPE content_visibility AS ENUM (
  'public',           -- Open educational content
  'clan',             -- Clan members and enrolled family
  'family',           -- Immediate family only
  'elders_only',      -- Requires elder approval
  'sacred'            -- Restricted ceremonial knowledge
);

CREATE TYPE lexical_category AS ENUM (
  'noun',
  'verb',
  'adjective',
  'adverb',
  'pronoun',
  'particle',
  'interjection',
  'phrase',
  'proverb',
  'prayer',
  'ceremonial',
  'place_name',
  'personal_name',
  'kinship_term',
  'natural_world',
  'other'
);

CREATE TYPE audio_quality AS ENUM (
  'archival',         -- Historical recordings
  'studio',           -- Professional studio quality
  'field',            -- Field recordings
  'practice',         -- Learner practice sessions
  'live_ceremony'     -- Live ceremonial context (restricted)
);

CREATE TYPE approval_status AS ENUM (
  'pending',
  'approved',
  'rejected',
  'requires_elder_review'
);

-- =============================================================================
-- CLANS
-- =============================================================================

CREATE TABLE clans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name_narragansett TEXT NOT NULL,
  name_english TEXT,
  clan_animal TEXT,                    -- Clan totem/animal association
  clan_color TEXT,                     -- Traditional color association
  territory_description TEXT,          -- Historical territory context
  cultural_notes TEXT,
  is_primary_family_clan BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================================================
-- SPEAKERS (Multi-generational clan-based system)
-- =============================================================================

CREATE TABLE speakers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  clerk_user_id TEXT UNIQUE,           -- Link to Clerk auth when applicable
  display_name TEXT NOT NULL,
  name_narragansett TEXT,              -- Name in Narragansett if known
  role speaker_role NOT NULL,
  generation generation_tier NOT NULL DEFAULT 'middle',
  clan_id UUID REFERENCES clans(id) ON DELETE SET NULL,
  parent_speaker_id UUID REFERENCES speakers(id) ON DELETE SET NULL,
  biography TEXT,
  cultural_title TEXT,                 -- e.g., "Knowledge Keeper", "Elder"
  is_two_spirit BOOLEAN DEFAULT false,
  is_elder BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  birth_year INTEGER,
  photo_url TEXT,
  voice_description TEXT,              -- Describing vocal qualities for learners
  teaching_domains TEXT[],             -- Areas of linguistic expertise
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_speakers_clan ON speakers(clan_id);
CREATE INDEX idx_speakers_role ON speakers(role);
CREATE INDEX idx_speakers_parent ON speakers(parent_speaker_id);

-- =============================================================================
-- CULTURAL DOMAINS & KNOWLEDGE AREAS
-- =============================================================================

CREATE TABLE cultural_domains (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name_narragansett TEXT NOT NULL,
  name_english TEXT NOT NULL,
  description TEXT,
  visibility content_visibility DEFAULT 'clan',
  elder_approved BOOLEAN DEFAULT false,
  approved_by UUID REFERENCES speakers(id),
  approved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================================================
-- LEXICAL ENTRIES (Rich linguistic database)
-- =============================================================================

CREATE TABLE lexical_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  word_narragansett TEXT NOT NULL,
  word_normalized TEXT NOT NULL,       -- Lowercase, diacritic-normalized for search
  english_gloss TEXT NOT NULL,
  alternate_spellings TEXT[],
  ipa_transcription TEXT,
  morphological_breakdown TEXT,        -- Morpheme analysis
  etymology_notes TEXT,
  usage_notes TEXT,
  cultural_context TEXT,               -- When/how the word is used culturally
  category lexical_category NOT NULL DEFAULT 'other',
  domain_id UUID REFERENCES cultural_domains(id),
  visibility content_visibility DEFAULT 'clan',
  is_sacred BOOLEAN DEFAULT false,
  is_archaic BOOLEAN DEFAULT false,
  primary_speaker_id UUID REFERENCES speakers(id),
  approval_status approval_status DEFAULT 'pending',
  approved_by UUID REFERENCES speakers(id),
  approved_at TIMESTAMPTZ,
  created_by UUID REFERENCES speakers(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_lexical_word ON lexical_entries USING gin(word_normalized gin_trgm_ops);
CREATE INDEX idx_lexical_category ON lexical_entries(category);
CREATE INDEX idx_lexical_visibility ON lexical_entries(visibility);

-- =============================================================================
-- PRONUNCIATION VARIANTS (Speaker-specific variations)
-- =============================================================================

CREATE TABLE pronunciation_variants (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  lexical_entry_id UUID NOT NULL REFERENCES lexical_entries(id) ON DELETE CASCADE,
  speaker_id UUID NOT NULL REFERENCES speakers(id),
  variant_spelling TEXT,
  ipa_variant TEXT,
  dialect_notes TEXT,                  -- Regional/clan dialect differences
  is_preferred BOOLEAN DEFAULT false,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(lexical_entry_id, speaker_id)
);

-- =============================================================================
-- AUDIO RECORDINGS (Speaker-attributed audio system)
-- =============================================================================

CREATE TABLE audio_recordings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  lexical_entry_id UUID REFERENCES lexical_entries(id) ON DELETE SET NULL,
  speaker_id UUID NOT NULL REFERENCES speakers(id),
  recorded_by UUID REFERENCES speakers(id),  -- Who pressed record
  storage_path TEXT NOT NULL,          -- Supabase storage path
  storage_bucket TEXT DEFAULT 'kuttiomp-audio',
  file_format TEXT DEFAULT 'webm',
  duration_seconds NUMERIC(10,2),
  sample_rate INTEGER,
  quality audio_quality DEFAULT 'field',
  recording_context TEXT,              -- e.g., "kitchen conversation", "formal lesson"
  location_description TEXT,           -- Where recorded (if appropriate to share)
  visibility content_visibility DEFAULT 'clan',
  is_primary_recording BOOLEAN DEFAULT false,
  approval_status approval_status DEFAULT 'pending',
  approved_by UUID REFERENCES speakers(id),
  approved_at TIMESTAMPTZ,
  transcript TEXT,                     -- Optional transcription
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_audio_speaker ON audio_recordings(speaker_id);
CREATE INDEX idx_audio_lexical ON audio_recordings(lexical_entry_id);

-- =============================================================================
-- PHRASES & SENTENCES (Extended linguistic content)
-- =============================================================================

CREATE TABLE phrases (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  phrase_narragansett TEXT NOT NULL,
  english_translation TEXT NOT NULL,
  literal_translation TEXT,
  cultural_context TEXT,
  usage_situation TEXT,                -- When this phrase is appropriate
  visibility content_visibility DEFAULT 'clan',
  is_sacred BOOLEAN DEFAULT false,
  primary_speaker_id UUID REFERENCES speakers(id),
  domain_id UUID REFERENCES cultural_domains(id),
  approval_status approval_status DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE phrase_audio (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  phrase_id UUID NOT NULL REFERENCES phrases(id) ON DELETE CASCADE,
  audio_recording_id UUID NOT NULL REFERENCES audio_recordings(id) ON DELETE CASCADE,
  UNIQUE(phrase_id, audio_recording_id)
);

-- =============================================================================
-- STORIES & ORAL TRADITIONS
-- =============================================================================

CREATE TABLE stories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title_narragansett TEXT,
  title_english TEXT NOT NULL,
  content_narragansett TEXT,
  content_english TEXT,
  story_type TEXT,                     -- creation, teaching, historical, etc.
  narrator_id UUID REFERENCES speakers(id),
  visibility content_visibility DEFAULT 'family',
  is_sacred BOOLEAN DEFAULT false,
  seasonal_context TEXT,               -- When story is traditionally told
  approval_status approval_status DEFAULT 'requires_elder_review',
  approved_by UUID REFERENCES speakers(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================================================
-- GROK AI INTERACTIONS (Linguistic assistance log)
-- =============================================================================

CREATE TABLE ai_interactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id TEXT,                        -- Clerk user ID
  speaker_context_id UUID REFERENCES speakers(id),
  prompt_type TEXT,                    -- translation, etymology, pronunciation_help
  prompt_text TEXT NOT NULL,
  response_text TEXT,
  lexical_entry_id UUID REFERENCES lexical_entries(id),
  was_helpful BOOLEAN,
  elder_reviewed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================================================
-- AUDIT LOG (Cultural content governance)
-- =============================================================================

CREATE TABLE audit_log (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  actor_id TEXT,
  actor_speaker_id UUID REFERENCES speakers(id),
  action TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id UUID NOT NULL,
  previous_values JSONB,
  new_values JSONB,
  cultural_notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================================================
-- ROW LEVEL SECURITY
-- =============================================================================

ALTER TABLE clans ENABLE ROW LEVEL SECURITY;
ALTER TABLE speakers ENABLE ROW LEVEL SECURITY;
ALTER TABLE lexical_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE audio_recordings ENABLE ROW LEVEL SECURITY;
ALTER TABLE phrases ENABLE ROW LEVEL SECURITY;
ALTER TABLE stories ENABLE ROW LEVEL SECURITY;
ALTER TABLE cultural_domains ENABLE ROW LEVEL SECURITY;

-- Public read for non-sacred, approved content
CREATE POLICY "Public can read approved public lexical entries"
  ON lexical_entries FOR SELECT
  USING (visibility = 'public' AND approval_status = 'approved');

CREATE POLICY "Authenticated users can read clan content"
  ON lexical_entries FOR SELECT
  USING (visibility IN ('public', 'clan') AND approval_status = 'approved');

-- Service role has full access (backend uses service role key)
CREATE POLICY "Service role full access on lexical_entries"
  ON lexical_entries FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on speakers"
  ON speakers FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on audio_recordings"
  ON audio_recordings FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Service role full access on clans"
  ON clans FOR ALL
  USING (auth.role() = 'service_role');

-- =============================================================================
-- SEED DATA: Primary Family Clan & Speakers
-- =============================================================================

INSERT INTO clans (id, name_narragansett, name_english, clan_animal, is_primary_family_clan, cultural_notes)
VALUES (
  'a0000000-0000-0000-0000-000000000001',
  'Kuttiomp Clan',
  'Kuttiomp Family Clan',
  'Turtle',
  true,
  'The primary family clan of the Kuttiomp language revitalization project. Turtle carries the teachings of patience, longevity, and the carrying of ancestral knowledge upon its back.'
);

-- Grandmother Comus (Elder matriarch)
INSERT INTO speakers (id, display_name, name_narragansett, role, generation, clan_id, is_elder, cultural_title, biography, teaching_domains)
VALUES (
  'b0000000-0000-0000-0000-000000000001',
  'Grandmother Comus',
  'Mush8n8m8s',
  'grandmother',
  'elder',
  'a0000000-0000-0000-0000-000000000001',
  true,
  'Elder Knowledge Keeper',
  'Grandmother Comus is a revered elder and primary keeper of Narragansett language and cultural knowledge. Her voice carries generations of teaching, stories, and the sacred responsibility of language transmission.',
  ARRAY['kinship_terms', 'ceremonial_language', 'traditional_stories', 'plant_medicine']
);

-- Grandfather
INSERT INTO speakers (id, display_name, role, generation, clan_id, parent_speaker_id, is_elder, cultural_title, biography, teaching_domains)
VALUES (
  'b0000000-0000-0000-0000-000000000002',
  'Grandfather',
  'grandfather',
  'elder',
  'a0000000-0000-0000-0000-000000000001',
  NULL,
  true,
  'Elder Knowledge Keeper',
  'Grandfather carries the teachings of hunting language, land knowledge, and the protocols of respect for all living beings.',
  ARRAY['natural_world', 'hunting_language', 'land_knowledge', 'protocols']
);

-- Sharente (Two-Spirit Knowledge Keeper)
INSERT INTO speakers (id, display_name, name_narragansett, role, generation, clan_id, is_two_spirit, cultural_title, biography, teaching_domains)
VALUES (
  'b0000000-0000-0000-0000-000000000003',
  'Sharente',
  'Sharente',
  'sharente',
  'middle',
  'a0000000-0000-0000-0000-000000000001',
  true,
  'Two-Spirit Knowledge Keeper',
  'Sharente holds the sacred role of Two-Spirit knowledge keeper, bridging traditional and contemporary understanding. They steward linguistic nuance, gender-inclusive kinship terms, and the living evolution of Narragansett expression.',
  ARRAY['kinship_terms', 'contemporary_usage', 'cultural_bridge', 'inclusive_language']
);

-- Parents
INSERT INTO speakers (id, display_name, role, generation, clan_id, parent_speaker_id, cultural_title, biography, teaching_domains)
VALUES
(
  'b0000000-0000-0000-0000-000000000004',
  'Mother',
  'parent',
  'middle',
  'a0000000-0000-0000-0000-000000000001',
  'b0000000-0000-0000-0000-000000000001',
  'Parent & Language Teacher',
  'Mother teaches daily household language, food preparation terms, and the rhythms of family conversation in Narragansett.',
  ARRAY['daily_life', 'food_language', 'family_conversation']
),
(
  'b0000000-0000-0000-0000-000000000005',
  'Father',
  'parent',
  'middle',
  'a0000000-0000-0000-0000-000000000001',
  'b0000000-0000-0000-0000-000000000002',
  'Parent & Language Teacher',
  'Father shares outdoor teachings, weather language, and the words of working with the land.',
  ARRAY['outdoor_language', 'weather', 'tools_and_craft']
);

-- Siblings
INSERT INTO speakers (id, display_name, role, generation, clan_id, parent_speaker_id, biography, teaching_domains)
VALUES
(
  'b0000000-0000-0000-0000-000000000006',
  'Older Sibling',
  'sibling',
  'younger',
  'a0000000-0000-0000-0000-000000000001',
  'b0000000-0000-0000-0000-000000000004',
  'The older sibling helps younger family members practice conversational Narragansett in everyday settings.',
  ARRAY['conversational_practice', 'youth_language']
),
(
  'b0000000-0000-0000-0000-000000000007',
  'Younger Sibling',
  'sibling',
  'younger',
  'a0000000-0000-0000-0000-000000000001',
  'b0000000-0000-0000-0000-000000000004',
  'The younger sibling represents the newest generation of language learners, bringing fresh energy to revitalization.',
  ARRAY['learner_perspective', 'modern_context']
);

-- Clan Members
INSERT INTO speakers (id, display_name, role, generation, clan_id, biography, teaching_domains)
VALUES
(
  'b0000000-0000-0000-0000-000000000008',
  'Auntie',
  'clan_member',
  'middle',
  'a0000000-0000-0000-0000-000000000001',
  'A respected clan auntie who shares stories, songs, and the language of gathering and celebration.',
  ARRAY['songs', 'gathering_language', 'stories']
),
(
  'b0000000-0000-0000-0000-000000000009',
  'Uncle',
  'clan_member',
  'middle',
  'a0000000-0000-0000-0000-000000000001',
  'A clan uncle who teaches fishing vocabulary, water knowledge, and coastal place names.',
  ARRAY['fishing', 'water_knowledge', 'place_names']
);

-- Cultural Domains
INSERT INTO cultural_domains (name_narragansett, name_english, description, visibility, elder_approved)
VALUES
('Wunneganash', 'Greetings & Respect', 'Words and phrases of greeting, respect, and acknowledgment', 'public', true),
('Mishqunnaqut', 'Kinship', 'Family and clan relationship terms', 'clan', true),
('Msh8m8s', 'Natural World', 'Plants, animals, seasons, and land', 'public', true),
('Wutchek', 'Ceremony', 'Ceremonial and sacred language (restricted)', 'sacred', false);

-- Sample Lexical Entries
INSERT INTO lexical_entries (word_narragansett, word_normalized, english_gloss, category, cultural_context, visibility, primary_speaker_id, approval_status)
VALUES
('Wunnegan', 'wunnegan', 'Greeting / Good day', 'phrase', 'A traditional greeting used to acknowledge presence and show respect. Often the first word taught to learners.', 'public', 'b0000000-0000-0000-0000-000000000001', 'approved'),
('Mush8n8m8s', 'mush8n8m8s', 'Grandmother', 'kinship_term', 'Term of deep respect for elder women who carry cultural knowledge.', 'clan', 'b0000000-0000-0000-0000-000000000001', 'approved'),
('Sharente', 'sharente', 'Two-Spirit person', 'kinship_term', 'Honors the sacred Two-Spirit role in Narragansett culture. Used with respect and cultural understanding.', 'clan', 'b0000000-0000-0000-0000-000000000003', 'approved'),
('Kuttiomp', 'kuttiomp', 'Family / Home', 'noun', 'The name of this platform — representing family, home, and the gathering place for language.', 'public', 'b0000000-0000-0000-0000-000000000001', 'approved');

-- =============================================================================
-- FUNCTIONS & TRIGGERS
-- =============================================================================

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER speakers_updated_at
  BEFORE UPDATE ON speakers
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER lexical_entries_updated_at
  BEFORE UPDATE ON lexical_entries
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER audio_recordings_updated_at
  BEFORE UPDATE ON audio_recordings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Normalize lexical entries on insert/update
CREATE OR REPLACE FUNCTION normalize_lexical_word()
RETURNS TRIGGER AS $$
BEGIN
  NEW.word_normalized = LOWER(TRIM(NEW.word_narragansett));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER lexical_normalize
  BEFORE INSERT OR UPDATE ON lexical_entries
  FOR EACH ROW EXECUTE FUNCTION normalize_lexical_word();

-- =============================================================================
-- STORAGE BUCKET (run via Supabase dashboard or API)
-- =============================================================================
-- CREATE BUCKET: kuttiomp-audio (private, RLS enabled)
-- Allowed MIME types: audio/webm, audio/wav, audio/mpeg, audio/ogg