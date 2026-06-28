import { z } from "zod";

export const speakerRoleSchema = z.enum([
  "grandmother", "grandfather", "sharente", "parent", "sibling",
  "clan_member", "learner", "guest_speaker",
]);

export const contentVisibilitySchema = z.enum([
  "public", "clan", "family", "elders_only", "sacred",
]);

export const approvalStatusSchema = z.enum([
  "draft", "pending", "under_review", "requires_elder_review",
  "approved", "rejected", "archived",
]);

export const lexicalCategorySchema = z.enum([
  "noun", "verb", "adjective", "adverb", "pronoun", "particle",
  "interjection", "phrase", "proverb", "prayer", "ceremonial",
  "place_name", "personal_name", "kinship_term", "natural_world",
  "numeral", "classifier", "incorporative", "other",
]);

export const semanticDomainSchema = z.enum([
  "flora", "fauna", "weather", "water", "geography", "kinship",
  "ceremony", "tools", "food", "medicine", "spiritual", "governance",
  "emotion", "movement", "time", "color", "other",
]);

export const seasonalUsageSchema = z.enum([
  "spring", "summer", "fall", "winter", "year_round",
  "ceremonial_season", "harvest", "planting",
]);

export const spiritualSignificanceSchema = z.enum([
  "none", "respectful", "ceremonial", "sacred", "restricted",
]);

export const culturalContextTypeSchema = z.enum([
  "mother_earth", "ceremony", "traditional_ecological_knowledge",
  "kinship", "seasonal_cycle", "spiritual_significance",
  "historical", "contemporary_usage",
]);

export const spellingVariantSchema = z.object({
  orthography_id: z.string().uuid().optional(),
  orthography_system: z.string().optional(),
  spelling: z.string().min(1, "Spelling is required"),
  notes: z.string().optional(),
  is_preferred: z.boolean().default(false),
});

export const exampleSentenceSchema = z.object({
  sentence_narragansett: z.string().min(1),
  sentence_english: z.string().min(1),
  literal_gloss: z.string().optional(),
  cultural_context: z.string().optional(),
});

export const culturalContextInputSchema = z.object({
  context_type: culturalContextTypeSchema,
  title: z.string().min(1, "Title is required"),
  narrative: z.string().min(10, "Provide substantive cultural narrative"),
  mother_earth_connection: z.string().optional(),
  ceremonial_notes: z.string().optional(),
  tek_notes: z.string().optional(),
  seasonal_usage: z.string().optional(),
  spiritual_significance: z.string().optional(),
  visibility: contentVisibilitySchema.default("clan"),
});

export const lexicalEntryFormSchema = z.object({
  word_narragansett: z
    .string()
    .min(1, "The Narragansett word is required — language lives in every word")
    .max(500),
  english_gloss: z.string().min(1, "English gloss is required").max(1000),
  english_gloss_extended: z.string().max(5000).optional().nullable(),
  alternate_spellings: z.array(z.string()).default([]),
  phonemic_transcription: z.string().max(500).optional().nullable(),
  ipa_transcription: z.string().max(500).optional().nullable(),
  morphological_breakdown: z.string().max(2000).optional().nullable(),
  morpheme_gloss: z.string().max(1000).optional().nullable(),
  etymology_notes: z.string().max(3000).optional().nullable(),
  etymology_source: z.string().max(500).optional().nullable(),
  usage_notes: z.string().max(2000).optional().nullable(),
  register: z.string().max(200).optional().nullable(),
  category: lexicalCategorySchema.default("other"),
  semantic_domain: semanticDomainSchema.default("other"),
  domain_id: z.string().uuid().optional().nullable(),
  ecological_connection: z.string().max(3000).optional().nullable(),
  seasonal_usage: z.array(seasonalUsageSchema).default([]),
  spiritual_significance: spiritualSignificanceSchema.default("none"),
  cultural_context_summary: z.string().max(5000).optional().nullable(),
  visibility: contentVisibilitySchema.default("clan"),
  is_sacred: z.boolean().default(false),
  is_archaic: z.boolean().default(false),
  is_neologism: z.boolean().default(false),
  primary_speaker_id: z.string().uuid().optional().nullable(),
  primary_orthography_id: z.string().uuid().optional().nullable(),
  created_by: z.string().uuid().optional().nullable(),
  spelling_variants: z.array(spellingVariantSchema).default([]),
  example_sentences: z.array(exampleSentenceSchema).default([]),
  cultural_contexts: z.array(culturalContextInputSchema).default([]),
}).superRefine((data, ctx) => {
  if (data.is_sacred && data.visibility === "public") {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      message: "Sacred content cannot have public visibility (Protocol 4)",
      path: ["visibility"],
    });
  }
  if (data.spiritual_significance === "sacred" && !data.is_sacred) {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      message: "Spiritual significance 'sacred' requires marking entry as sacred",
      path: ["is_sacred"],
    });
  }
});

export const contributionSubmitSchema = z.object({
  contributor_speaker_id: z.string().uuid(),
  contribution_type: z.enum([
    "lexical_entry", "audio_recording", "pronunciation_variant",
    "cultural_narrative", "land_knowledge", "example_sentence", "orthography_note",
  ]),
  entity_id: z.string().uuid(),
  entity_type: z.string().min(1),
  submission_notes: z.string().max(2000).optional(),
  protocol_acknowledgments: z
    .array(z.number().int().min(1).max(12))
    .min(1, "Acknowledge at least one cultural protocol"),
});

export const audioUploadMetaSchema = z.object({
  speaker_id: z.string().uuid("Speaker attribution is required (Protocol 1)"),
  recorded_by: z.string().uuid().optional(),
  lexical_entry_id: z.string().uuid().optional(),
  recording_context: z.string().max(500).optional(),
  quality: z.enum(["archival", "studio", "field", "practice", "live_ceremony"]).default("field"),
  visibility: contentVisibilitySchema.default("clan"),
  context_tags: z.array(z.string()).default([]),
});

export type LexicalEntryForm = z.infer<typeof lexicalEntryFormSchema>;
export type CulturalContextInput = z.infer<typeof culturalContextInputSchema>;