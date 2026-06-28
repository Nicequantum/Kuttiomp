export * from "./cultural";
export * from "./linguistic";
export * from "./governance";

export const VISIBILITY_LABELS = {
  public: "Public",
  clan: "Clan",
  family: "Family",
  elders_only: "Elders Only",
  sacred: "Sacred",
} as const;

export const GENERATION_LABELS = {
  elder: "Elder Generation",
  middle: "Middle Generation",
  younger: "Younger Generation",
  ancestral: "Ancestral (Archival)",
} as const;