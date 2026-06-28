/**
 * The Twelve Cultural Governance Protocols of Kuttiomp
 * These protocols are encoded in database constraints, API logic, and UI workflows.
 */
export const CULTURAL_PROTOCOLS = [
  {
    id: 1,
    key: "speaker_sovereignty",
    title: "Speaker Sovereignty",
    principle: "Every voice belongs to a person.",
    enforcement: ["audio_recordings.speaker_id NOT NULL", "recorded_by attribution"],
  },
  {
    id: 2,
    key: "generational_respect",
    title: "Generational Respect",
    principle: "Knowledge flows through generations, not around them.",
    enforcement: ["generation_tier enum", "elder authority on pronunciation"],
  },
  {
    id: 3,
    key: "two_spirit_honor",
    title: "Two-Spirit Honor",
    principle: "Sharente hold a sacred role that must be explicitly honored.",
    enforcement: ["sharente role", "gender_expression field", "dedicated review path"],
  },
  {
    id: 4,
    key: "sacred_content_protection",
    title: "Sacred Content Protection",
    principle: "Ceremonial knowledge is not educational content.",
    enforcement: ["visibility: sacred", "requires_elder_review auto-flag"],
  },
  {
    id: 5,
    key: "clan_boundaries",
    title: "Clan Boundaries",
    principle: "Clan knowledge belongs to the clan.",
    enforcement: ["default visibility: clan", "clan_id on speakers"],
  },
  {
    id: 6,
    key: "ai_boundaries",
    title: "AI Boundaries",
    principle: "AI assists learners; it does not speak for the people.",
    enforcement: ["ai_interactions log", "sacred content exclusion"],
  },
  {
    id: 7,
    key: "audit_accountability",
    title: "Audit and Accountability",
    principle: "All changes are traceable.",
    enforcement: ["audit_log table", "contribution workflow states"],
  },
  {
    id: 8,
    key: "pronunciation_variation",
    title: "Pronunciation Variation",
    principle: "Living languages have living variation.",
    enforcement: ["pronunciation_variants per speaker", "no incorrect flag"],
  },
  {
    id: 9,
    key: "external_sharing",
    title: "External Sharing",
    principle: "Platform existence does not authorize external use.",
    enforcement: ["export requires elder approval", "citation requires speaker name"],
  },
  {
    id: 10,
    key: "platform_modifications",
    title: "Platform Modifications",
    principle: "Technology changes require cultural review.",
    enforcement: ["schema change review", "protocol version tracking"],
  },
  {
    id: 11,
    key: "land_relationship",
    title: "Land Relationship",
    principle: "Language is inseparable from place.",
    enforcement: ["land_knowledge_sites PostGIS", "ecological_connections on lexicon"],
  },
  {
    id: 12,
    key: "orthographic_integrity",
    title: "Orthographic Integrity",
    principle: "Writing systems serve speakers, not the reverse.",
    enforcement: ["orthographies table", "spelling_variants per system"],
  },
] as const;

export type CulturalProtocolKey = (typeof CULTURAL_PROTOCOLS)[number]["key"];