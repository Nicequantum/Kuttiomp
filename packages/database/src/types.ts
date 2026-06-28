export type SpeakerRole =
  | "grandmother"
  | "grandfather"
  | "sharente"
  | "parent"
  | "sibling"
  | "clan_member"
  | "learner"
  | "guest_speaker";

export type GenerationTier = "elder" | "middle" | "younger" | "ancestral";

export type ContentVisibility =
  | "public"
  | "clan"
  | "family"
  | "elders_only"
  | "sacred";

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
  | "other";

export type AudioQuality =
  | "archival"
  | "studio"
  | "field"
  | "practice"
  | "live_ceremony";

export type ApprovalStatus =
  | "pending"
  | "approved"
  | "rejected"
  | "requires_elder_review";

export interface Clan {
  id: string;
  name_narragansett: string;
  name_english: string | null;
  clan_animal: string | null;
  clan_color: string | null;
  territory_description: string | null;
  cultural_notes: string | null;
  is_primary_family_clan: boolean;
  created_at: string;
  updated_at: string;
}

export interface Speaker {
  id: string;
  clerk_user_id: string | null;
  display_name: string;
  name_narragansett: string | null;
  role: SpeakerRole;
  generation: GenerationTier;
  clan_id: string | null;
  parent_speaker_id: string | null;
  biography: string | null;
  cultural_title: string | null;
  is_two_spirit: boolean;
  is_elder: boolean;
  is_active: boolean;
  birth_year: number | null;
  photo_url: string | null;
  voice_description: string | null;
  teaching_domains: string[];
  created_at: string;
  updated_at: string;
}

export interface SpeakerWithRelations extends Speaker {
  clan?: Clan | null;
  parent?: Speaker | null;
  children?: Speaker[];
}

export interface CulturalDomain {
  id: string;
  name_narragansett: string;
  name_english: string;
  description: string | null;
  visibility: ContentVisibility;
  elder_approved: boolean;
  approved_by: string | null;
  approved_at: string | null;
  created_at: string;
}

export interface LexicalEntry {
  id: string;
  word_narragansett: string;
  word_normalized: string;
  english_gloss: string;
  alternate_spellings: string[];
  ipa_transcription: string | null;
  morphological_breakdown: string | null;
  etymology_notes: string | null;
  usage_notes: string | null;
  cultural_context: string | null;
  category: LexicalCategory;
  domain_id: string | null;
  visibility: ContentVisibility;
  is_sacred: boolean;
  is_archaic: boolean;
  primary_speaker_id: string | null;
  approval_status: ApprovalStatus;
  approved_by: string | null;
  approved_at: string | null;
  created_by: string | null;
  created_at: string;
  updated_at: string;
}

export interface PronunciationVariant {
  id: string;
  lexical_entry_id: string;
  speaker_id: string;
  variant_spelling: string | null;
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
  quality: AudioQuality;
  recording_context: string | null;
  location_description: string | null;
  visibility: ContentVisibility;
  is_primary_recording: boolean;
  approval_status: ApprovalStatus;
  approved_by: string | null;
  approved_at: string | null;
  transcript: string | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface AudioRecordingWithSpeaker extends AudioRecording {
  speaker?: Speaker;
  lexical_entry?: LexicalEntry;
}

export interface Phrase {
  id: string;
  phrase_narragansett: string;
  english_translation: string;
  literal_translation: string | null;
  cultural_context: string | null;
  usage_situation: string | null;
  visibility: ContentVisibility;
  is_sacred: boolean;
  primary_speaker_id: string | null;
  domain_id: string | null;
  approval_status: ApprovalStatus;
  created_at: string;
  updated_at: string;
}

export interface Story {
  id: string;
  title_narragansett: string | null;
  title_english: string;
  content_narragansett: string | null;
  content_english: string | null;
  story_type: string | null;
  narrator_id: string | null;
  visibility: ContentVisibility;
  is_sacred: boolean;
  seasonal_context: string | null;
  approval_status: ApprovalStatus;
  approved_by: string | null;
  created_at: string;
  updated_at: string;
}

export const SPEAKER_ROLE_LABELS: Record<SpeakerRole, string> = {
  grandmother: "Grandmother",
  grandfather: "Grandfather",
  sharente: "Sharente (Two-Spirit)",
  parent: "Parent",
  sibling: "Sibling",
  clan_member: "Clan Member",
  learner: "Learner",
  guest_speaker: "Guest Speaker",
};

export const GENERATION_LABELS: Record<GenerationTier, string> = {
  elder: "Elder Generation",
  middle: "Middle Generation",
  younger: "Younger Generation",
  ancestral: "Ancestral (Archival)",
};

export const VISIBILITY_LABELS: Record<ContentVisibility, string> = {
  public: "Public",
  clan: "Clan",
  family: "Family",
  elders_only: "Elders Only",
  sacred: "Sacred",
};