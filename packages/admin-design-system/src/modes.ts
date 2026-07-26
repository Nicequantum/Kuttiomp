/**
 * Four admin visual identities aligned with MAD v2.0 §5 learning modes.
 *
 * Protocol 10 hard gate: calm, dignified, no gamification, no cartoons,
 * no playful motion. Elder mode prioritizes Protocol 11 readability.
 */

export type AdminLearningMode =
  | "little_ones"
  | "young_learner"
  | "core_adult"
  | "elder";

export type ModeTokens = {
  id: AdminLearningMode;
  label: string;
  description: string;
  /** HSL components without hsl() — for CSS variables */
  background: string;
  foreground: string;
  card: string;
  cardForeground: string;
  primary: string;
  primaryForeground: string;
  secondary: string;
  secondaryForeground: string;
  muted: string;
  mutedForeground: string;
  accent: string;
  accentForeground: string;
  border: string;
  ring: string;
  /** px string for --radius */
  radius: string;
  /** rem — body / UI chrome */
  fontBody: string;
  /** rem — page titles */
  fontTitle: string;
  /** rem — content paragraphs (elder ≥ 2rem / 32px) */
  fontContent: string;
  /** sidebar surface tint */
  sidebar: string;
  sidebarBorder: string;
  navActive: string;
  navActiveFg: string;
  navIdle: string;
  surfaceTint: string;
  /** land-based accent name for maintainers */
  landAccentName: string;
};

/** Little Ones — warm earth, rounded, large clear type (Protocol 10 calm). */
export const littleOnesTokens: ModeTokens = {
  id: "little_ones",
  label: "Little Ones",
  description: "Warm, rounded surfaces for our youngest path — gentle and clear.",
  background: "32 40% 97%",
  foreground: "25 35% 18%",
  card: "36 45% 99%",
  cardForeground: "25 35% 18%",
  primary: "28 42% 38%",
  primaryForeground: "36 40% 98%",
  secondary: "30 35% 92%",
  secondaryForeground: "25 30% 22%",
  muted: "32 25% 93%",
  mutedForeground: "25 18% 40%",
  accent: "24 48% 52%",
  accentForeground: "25 35% 12%",
  border: "30 28% 86%",
  ring: "28 42% 38%",
  radius: "1rem",
  fontBody: "1.125rem",
  fontTitle: "1.75rem",
  fontContent: "1.25rem",
  sidebar: "32 35% 96%",
  sidebarBorder: "30 28% 88%",
  navActive: "28 42% 38%",
  navActiveFg: "36 40% 98%",
  navIdle: "25 18% 38%",
  surfaceTint: "radial-gradient(ellipse at 15% 0%, rgba(180, 120, 70, 0.08) 0%, transparent 55%)",
  landAccentName: "clay-dawn",
};

/** Young Learner — clear modern hierarchy, land sky accent, restrained motion. */
export const youngLearnerTokens: ModeTokens = {
  id: "young_learner",
  label: "Young Learner",
  description: "Clear modern layout for students — bright land-sky, no playfulness.",
  background: "210 25% 98%",
  foreground: "220 30% 14%",
  card: "0 0% 100%",
  cardForeground: "220 30% 14%",
  primary: "205 48% 36%",
  primaryForeground: "210 40% 98%",
  secondary: "200 22% 92%",
  secondaryForeground: "220 25% 20%",
  muted: "210 18% 94%",
  mutedForeground: "215 14% 42%",
  accent: "145 28% 36%",
  accentForeground: "0 0% 100%",
  border: "210 18% 88%",
  ring: "205 48% 36%",
  radius: "0.5rem",
  fontBody: "1rem",
  fontTitle: "1.5rem",
  fontContent: "1.0625rem",
  sidebar: "210 22% 97%",
  sidebarBorder: "210 18% 90%",
  navActive: "205 48% 36%",
  navActiveFg: "210 40% 98%",
  navIdle: "215 14% 38%",
  surfaceTint: "radial-gradient(ellipse at 80% 0%, rgba(74, 111, 165, 0.07) 0%, transparent 50%)",
  landAccentName: "sky-sage",
};

/** Core Adult — crisp professional neutral + turtle primary. */
export const coreAdultTokens: ModeTokens = {
  id: "core_adult",
  label: "Core Adult",
  description: "Crisp, efficient Keeper workspace for tribal members.",
  background: "40 12% 97%",
  foreground: "30 20% 12%",
  card: "0 0% 100%",
  cardForeground: "30 20% 12%",
  primary: "145 35% 26%",
  primaryForeground: "40 20% 98%",
  secondary: "35 12% 92%",
  secondaryForeground: "30 18% 18%",
  muted: "35 10% 93%",
  mutedForeground: "30 10% 42%",
  accent: "30 35% 42%",
  accentForeground: "0 0% 100%",
  border: "35 12% 86%",
  ring: "145 35% 26%",
  radius: "0.375rem",
  fontBody: "0.9375rem",
  fontTitle: "1.375rem",
  fontContent: "1rem",
  sidebar: "40 10% 96%",
  sidebarBorder: "35 12% 88%",
  navActive: "145 35% 26%",
  navActiveFg: "40 20% 98%",
  navIdle: "30 12% 36%",
  surfaceTint: "radial-gradient(ellipse at 20% 0%, rgba(45, 90, 61, 0.05) 0%, transparent 50%)",
  landAccentName: "turtle-bark",
};

/** Elder — high contrast, traditional calm, Protocol 11 content ≥ 32px. */
export const elderTokens: ModeTokens = {
  id: "elder",
  label: "Elder",
  description: "Maximum readability — high contrast, traditional calm, large type.",
  background: "0 0% 100%",
  foreground: "0 0% 0%",
  card: "0 0% 100%",
  cardForeground: "0 0% 0%",
  primary: "0 0% 0%",
  primaryForeground: "0 0% 100%",
  secondary: "0 0% 96%",
  secondaryForeground: "0 0% 0%",
  muted: "0 0% 94%",
  mutedForeground: "0 0% 20%",
  accent: "205 40% 32%",
  accentForeground: "0 0% 100%",
  border: "0 0% 12%",
  ring: "0 0% 0%",
  radius: "0.25rem",
  fontBody: "1.25rem",
  fontTitle: "2rem",
  fontContent: "2rem",
  sidebar: "0 0% 100%",
  sidebarBorder: "0 0% 12%",
  navActive: "0 0% 0%",
  navActiveFg: "0 0% 100%",
  navIdle: "0 0% 15%",
  surfaceTint: "none",
  landAccentName: "ink-sky",
};

export const MODE_TOKENS: Record<AdminLearningMode, ModeTokens> = {
  little_ones: littleOnesTokens,
  young_learner: youngLearnerTokens,
  core_adult: coreAdultTokens,
  elder: elderTokens,
};

export const ADMIN_MODES: AdminLearningMode[] = [
  "little_ones",
  "young_learner",
  "core_adult",
  "elder",
];

export const DEFAULT_ADMIN_MODE: AdminLearningMode = "core_adult";

export function isAdminLearningMode(value: string): value is AdminLearningMode {
  return (ADMIN_MODES as string[]).includes(value);
}
