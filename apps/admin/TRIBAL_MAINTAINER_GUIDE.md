# Tribal Maintainer Guide — Admin portal UI

**Locate in < 1 hour:** search `ModeThemeProvider` or open `packages/admin-design-system/src/modes.ts`.

## Change mode colors / type

1. Edit tokens in `packages/admin-design-system/src/modes.ts`.
2. Do **not** invent gamification classes (points, streak, leaderboard).
3. Elder content type must stay ≥ `2rem` (32px) — Protocol 11.

## Wire a new page to the theme

Use Tailwind semantic tokens (`bg-background`, `text-foreground`, `bg-primary`, `border-border`) or CSS variables (`var(--mode-font-content)`). Avoid hard-coded `stone-*` / `emerald-*` when mode-adaptive UI is required.

## Mode switcher

`apps/admin/src/components/layout/sidebar.tsx` renders `<ModeSwitcher />` from `@kuttiomp/admin-design-system`.

## Stewardship

Absolute counts only — `continuity-panel.tsx`. Targets stay `null` until Keepers define them.

## Full docs

`docs/ADMIN_UI_MODES.md`
