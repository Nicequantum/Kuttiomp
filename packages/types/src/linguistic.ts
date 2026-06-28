import type { ApprovalStatus, ContentVisibility } from "./cultural";

export type LexicalCategory =
  | "noun"
  | "verb"
  | "adjective"
  | "adverb"
  | "pronoun"
  | "particle"
  | "interjection"
  | "phrase"
  | "proverb"
  | "prayer"
  | "ceremonial"
  | "place_name"
  | "personal_name"
  | "kinship_term"
  | "natural_world"
  | "numeral"
  | "classifier"
  | "incorporative"
  | "other";

export type SemanticDomain =
  | "flora"
  | "fauna"
  | "weather"
  | "water"
  | "geography"
  | "kinship"
  | "ceremony"
  | "tools"
  | "food"
  | "medicine"
  | "spiritual"
  | "governance"
  | "emotion"
  | "movement"
  | "time"
  | "color"
  | "other";

export type SeasonalUsage =
  | "spring"
  | "summer"
  | "fall"
  | "winter"
  | "year_round"
  | "ceremonial_season"
  | "harvest"
  | "planting";

export type SpiritualSignificance =
  | "none"
  | "respectful"
  | "ceremonial"
  | "sacred"
  | "restricted";

export type OrthographySystem =
  | "costa_transcription"
  | "jopson_modern"
  | "ipa"
  | "historical_manuscript"
  | "community_preferred"
  | "learner_phonetic";

export type AudioQuality =
  | "archival"
  | "studio"
  | "field"
  | "practice"
  | "live_ceremony";

export interface Orthography {
  id: string;
  system_key: OrthographySystem;
  name: string;
  description: string | null;
  character_inventory: string | null;
  is_primary: boolean;
  created_at: string;
}

export interface LexicalEntry {
  id: string;
  word_narragansett: string;
  word_normalized: string;
  english_gloss: string;
  english_gloss_extended: string | null;
  alternate_spellings: string[];
  phonemic_transcription: string | null;
  ipa_transcription: string | null;
  morphological_breakdown: string | null;
  morpheme_gloss: string | null;
  etymology_notes: string | null;
  etymology_source: string | null;
  usage_notes: string | null;
  register: string | null;
  category: LexicalCategory;
  semantic_domain: SemanticDomain;
  cultural_domain_id: string | null;
  ecological_connection: string | null;
  seasonal_usage: SeasonalUsage[];
  spiritual_significance: SpiritualSignificance;
  cultural_context_summary: string | null;
  visibility: ContentVisibility;
  is_sacred: boolean;
  is_archaic: boolean;
  is_neologism: boolean;
  primary_speaker_id: string | null;
  primary_orthography_id: string | null;
  approval_status: ApprovalStatus;
  approved_by: string | null;
  approved_at: string | null;
  created_by: string | null;
  created_at: string;
  updated_at: string;
}

export interface SpellingVariant {
  id: string;
  lexical_entry_id: string;
  orthography_id: string;
  spelling: string;
  notes: string | null;
  speaker_id: string | null;
  is_preferred: boolean;
  created_at: string;
}

export interface ExampleSentence {
  id: string;
  lexical_entry_id: string;
  sentence_narragansett: string;
  sentence_english: string;
  literal_gloss: string | null;
  cultural_context: string | null;
  speaker_id: string | null;
  audio_recording_id: string | null;
  approval_status: ApprovalStatus;
  created_at: string;
}

export interface PronunciationVariant {
  id: string;
  lexical_entry_id: string;
  speaker_id: string;
  variant_spelling: string | null;
  phonemic_variant: string | null;
  ipa_variant: string | null;
  dialect_notes: string | null;
  is_preferred: boolean;
  notes: string | null;
  created_at: string;
}

export interface AudioRecording {
  id: string;
  lexical_entry_id: string | null;
  speaker_id: string;
  recorded_by: string | null;
  storage_path: string;
  storage_bucket: string;
  file_format: string;
  duration_seconds: number | null;
  sample_rate: number | null;
  bit_depth: number | null;
  channels: number | null;
  quality: AudioQuality;
  signal_to_noise: number | null;
  recording_context: string | null;
  context_tags: string[];
  location_description: string | null;
  land_site_id: string | null;
  visibility: ContentVisibility;
  is_primary_recording: boolean;
  approval_status: ApprovalStatus;
  approved_by: string | null;
  approved_at: string | null;
  transcript: string | null;
  waveform_data: number[] | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface LexicalNarrativeLink {
  id: string;
  lexical_entry_id: string;
  narrative_id: string;
  relationship_type: string;
  notes: string | null;
}

export const SEMANTIC_DOMAIN_LABELS: Record<SemanticDomain, string> = {
  flora: "Flora (Plants)",
  fauna: "Fauna (Animals)",
  weather: "Weather & Sky",
  water: "Water",
  geography: "Geography & Land",
  kinship: "Kinship",
  ceremony: "Ceremony",
  tools: "Tools & Craft",
  food: "Food & Sustenance",
  medicine: "Medicine",
  spiritual: "Spiritual",
  governance: "Governance & Protocol",
  emotion: "Emotion & State",
  movement: "Movement & Action",
  time: "Time",
  color: "Color",
  other: "Other",
};