import type { ApprovalStatus, ContentVisibility } from "./cultural";
import type { LexicalCategory, SemanticDomain, SpiritualSignificance } from "./linguistic";

export type ForgeStatus =
  | "draft"
  | "proposed"
  | "under_review"
  | "needs_revision"
  | "approved"
  | "rejected"
  | "archived";

export type ForgeDerivationType =
  | "compound"
  | "derivation"
  | "calque"
  | "neologism_from_existing_root"
  | "analogical_formation"
  | "semantic_extension"
  | "reconstructed_from_cognates"
  | "borrowing_adapted";

export type ForgeAttestationStatus =
  | "fully_modern_creation"
  | "partial_historical_basis"
  | "analogical_from_attested"
  | "calque_of_english"
  | "reconstructed_from_cognates"
  | "semantic_extension";

export type CorpusMode = "demo_historical" | "keeper_only";

export type CorpusModules = {
  feedHistorical: boolean;
  feedApprovedLiving: boolean;
  feedForgeDemoMerge: boolean;
};

export function corpusModeFromModules(
  modules: Pick<CorpusModules, "feedForgeDemoMerge">,
): CorpusMode {
  return modules.feedForgeDemoMerge ? "demo_historical" : "keeper_only";
}

export type LearnerFeedPreview = {
  historical: number;
  approvedLiving: number;
  teachingDrafts: number;
  learnerTotal: number;
};

export type CorpusModuleAudit = {
  id: string;
  actor_id: string | null;
  module_key: string;
  old_value: string | null;
  new_value: string | null;
  summary: string;
  created_at: string;
};

export type CorpusDesk = {
  corpusMode: CorpusMode;
  modules: CorpusModules;
  preview: LearnerFeedPreview;
  updatedBy: string | null;
  updatedAt: string | null;
  audit: CorpusModuleAudit[];
};


export type ForgeRootStem = {
  form: string;
  language: string;
  gloss: string;
};

export type ForgeRelatedWord = {
  id: string;
  form: string;
  gloss: string;
};


export type LanguageForgeEntry = {
  id: string;
  proposed_word: string;
  word_normalized: string;
  english_gloss: string;
  english_meaning: string | null;
  part_of_speech: LexicalCategory;
  semantic_domain: SemanticDomain;
  spiritual_significance: SpiritualSignificance;
  visibility: ContentVisibility;
  orthographic_form: string | null;
  phonemic_transcription: string | null;
  ipa_transcription: string | null;
  pronunciation_notes: string | null;
  stress_pattern: string | null;
  morphological_breakdown: string | null;
  morpheme_gloss: string | null;
  derivation_type: ForgeDerivationType | null;
  generation_rule: string | null;
  source_roots_or_stems: ForgeRootStem[];
  related_existing_words: ForgeRelatedWord[];
  algonquian_cognates: string | null;
  proto_algonquian_or_deeper_roots: string | null;
  historical_attestation_status: ForgeAttestationStatus | null;
  source_citations: string | null;
  linguistic_justification: string | null;
  cultural_notes: string | null;
  confidence_score: number;
  confidence_rationale: string | null;
  potential_issues: string | null;
  usage_notes: string | null;
  collocations: string | null;
  status: ForgeStatus;
  submitted_by: string | null;
  submitted_at: string;
  last_updated_by: string | null;
  last_updated_at: string;
  reviewed_by: string | null;
  reviewed_at: string | null;
  approval_notes: string | null;
  version: number;
  is_demo_visible: boolean;
  is_production_ready: boolean;
  tags: string[];
  lexical_entry_id: string | null;
  created_at: string;
};

export type ForgeComment = {
  id: string;
  entry_id: string;
  author_id: string | null;
  body: string;
  created_at: string;
};

export type ForgeAuditEvent = {
  id: string;
  entry_id: string;
  actor_id: string | null;
  action: string;
  field_name: string | null;
  old_value: string | null;
  new_value: string | null;
  summary: string | null;
  created_at: string;
};

/** What kuttiomp-learn may receive from GET /api/v1/public/lexicon */
export type PublicForgeWord = {
  id: string;
  wordNarragansett: string;
  englishGloss: string;
  semanticDomain: SemanticDomain;
  source: "keeper_approved";
  authority: "living_speaker";
  elderApproved: boolean;
  isSacred: boolean;
  speakerAttribution: string;
};

export function forgeVisibleToLearners(
  entry: Pick<
    LanguageForgeEntry,
    "status" | "is_demo_visible" | "is_production_ready" | "spiritual_significance"
  >,
  corpus: CorpusMode | CorpusModules,
): boolean {
  if (
    entry.spiritual_significance === "sacred" ||
    entry.spiritual_significance === "restricted" ||
    entry.spiritual_significance === "ceremonial"
  ) {
    return false;
  }
  const modules: CorpusModules =
    typeof corpus === "string"
      ? {
          feedHistorical: true,
          feedApprovedLiving: true,
          feedForgeDemoMerge: corpus === "demo_historical",
        }
      : corpus;
  const released = entry.status === "approved" && entry.is_production_ready;
  const living = modules.feedApprovedLiving && released;
  const teaching =
    modules.feedForgeDemoMerge &&
    entry.is_demo_visible &&
    entry.status !== "rejected" &&
    entry.status !== "archived" &&
    !released;
  return living || teaching;
}

export type { ApprovalStatus };
