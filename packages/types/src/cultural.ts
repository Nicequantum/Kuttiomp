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

export type GenderExpression =
  | "feminine"
  | "masculine"
  | "two_spirit"
  | "non_binary"
  | "not_specified"
  | "culturally_specific";

export type CulturalAuthorityLevel =
  | "elder_keeper"
  | "knowledge_keeper"
  | "sharente_keeper"
  | "clan_teacher"
  | "family_teacher"
  | "learner"
  | "guest";

export type ContentVisibility =
  | "public"
  | "clan"
  | "family"
  | "elders_only"
  | "sacred";

export type ApprovalStatus =
  | "draft"
  | "pending"
  | "under_review"
  | "requires_elder_review"
  | "approved"
  | "rejected"
  | "archived";

export type ContributionType =
  | "lexical_entry"
  | "audio_recording"
  | "pronunciation_variant"
  | "cultural_narrative"
  | "land_knowledge"
  | "example_sentence"
  | "orthography_note";

export type CulturalContextType =
  | "mother_earth"
  | "ceremony"
  | "traditional_ecological_knowledge"
  | "kinship"
  | "seasonal_cycle"
  | "spiritual_significance"
  | "historical"
  | "contemporary_usage";

export interface Clan {
  id: string;
  name_narragansett: string;
  name_english: string | null;
  clan_animal: string | null;
  clan_color: string | null;
  clan_plant?: string | null;
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
  gender_expression: GenderExpression;
  cultural_authority: CulturalAuthorityLevel;
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
  voice_pitch_range: string | null;
  voice_tempo: string | null;
  voice_quality_notes: string | null;
  teaching_domains: string[];
  languages_spoken: string[];
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
  parent_domain_id: string | null;
  visibility: ContentVisibility;
  elder_approved: boolean;
  approved_by: string | null;
  approved_at: string | null;
  created_at: string;
}

export interface CulturalContext {
  id: string;
  lexical_entry_id: string | null;
  context_type: CulturalContextType;
  title: string;
  narrative: string;
  mother_earth_connection: string | null;
  ceremonial_notes: string | null;
  tek_notes: string | null;
  seasonal_usage: string | null;
  spiritual_significance: string | null;
  speaker_id: string | null;
  visibility: ContentVisibility;
  approval_status: ApprovalStatus;
  created_at: string;
  updated_at: string;
}

export interface CulturalNarrative {
  id: string;
  title_narragansett: string | null;
  title_english: string;
  narrative_narragansett: string | null;
  narrative_english: string | null;
  narrative_type: string;
  narrator_id: string | null;
  seasonal_context: string | null;
  land_site_id: string | null;
  visibility: ContentVisibility;
  is_sacred: boolean;
  approval_status: ApprovalStatus;
  approved_by: string | null;
  created_at: string;
  updated_at: string;
}

export interface LandKnowledgeSite {
  id: string;
  name_narragansett: string;
  name_english: string | null;
  description: string | null;
  site_type: string;
  latitude: number;
  longitude: number;
  elevation_meters: number | null;
  ecological_zone: string | null;
  cultural_significance: string | null;
  seasonal_relevance: string | null;
  visibility: ContentVisibility;
  speaker_id: string | null;
  approval_status: ApprovalStatus;
  created_at: string;
  updated_at: string;
}

export interface KnowledgeContribution {
  id: string;
  contributor_speaker_id: string;
  contribution_type: ContributionType;
  entity_id: string;
  entity_type: string;
  submission_notes: string | null;
  status: ApprovalStatus;
  reviewed_by: string | null;
  reviewed_at: string | null;
  review_notes: string | null;
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

export const AUTHORITY_LABELS: Record<CulturalAuthorityLevel, string> = {
  elder_keeper: "Elder Knowledge Keeper",
  knowledge_keeper: "Knowledge Keeper",
  sharente_keeper: "Sharente Knowledge Keeper",
  clan_teacher: "Clan Teacher",
  family_teacher: "Family Teacher",
  learner: "Learner",
  guest: "Guest",
};

export const CONTEXT_TYPE_LABELS: Record<CulturalContextType, string> = {
  mother_earth: "Mother Earth Connection",
  ceremony: "Ceremony",
  traditional_ecological_knowledge: "Traditional Ecological Knowledge",
  kinship: "Kinship",
  seasonal_cycle: "Seasonal Cycle",
  spiritual_significance: "Spiritual Significance",
  historical: "Historical Context",
  contemporary_usage: "Contemporary Usage",
};