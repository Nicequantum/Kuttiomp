# Admin UI Modes — Four Dignified Visual Paths

**Package:** `@kuttiomp/admin-design-system`  
**App:** `apps/admin`  
**MAD:** v2.0 §5 (modes) · Protocol 10 (dignity) · Protocol 11 (elder accessibility)  

This serves our people by giving Knowledge Keepers a clear, respectful portal that can preview how each generation experiences the work — without gamification or cartoon chrome.

---

## Inventory (Stream 1 audit summary)

| Area | Path | Notes |
|------|------|--------|
| Shell layout | `src/app/(dashboard)/layout.tsx` | Sidebar + main; wraps `ModeThemeProvider` |
| Navigation | `src/components/layout/sidebar.tsx` | Mode switcher + nav links |
| Dashboard | `src/app/(dashboard)/page.tsx` | Protocols, stats, quick actions |
| Stewardship | `src/app/(dashboard)/stewardship/` + `continuity-panel*.tsx` | Absolute counts only |
| Lexicon / editor | `lexicon/`, `lexicon/editor/` | Existing forms; inherit CSS variables |
| Speakers / clans | `speakers/`, `clans/` | Inherit theme tokens |
| Contributions / approvals | `contributions/`, `approvals/` | Protocol workflows unchanged |
| Design tokens (legacy) | `globals.css`, `tailwind.config.ts` | Now driven by mode CSS variables |

**Baseline palette (pre-mode):** stone/emerald shadcn HSL tokens, Geist sans, Georgia serif, `kuttiomp.*` land colors in Tailwind.

---

## Four modes (Stream 2)

| Mode id | Visual language | Body / content type |
|---------|-----------------|---------------------|
| `little_ones` | Warm clay-dawn, large radius, soft surfaces | ≥18px body |
| `young_learner` | Land-sky blue + sage, clean modern hierarchy | ≥16px body |
| `core_adult` | Turtle green + neutral professional (default) | Efficient density |
| `elder` | High-contrast ink/white, minimal radius | Content **32px** (`2rem`) |

**Hard gates (Protocol 10):** no points, streaks, badges, leaderboards, confetti, cartoon mascots, or playful motion. Linear progress only when a **Keeper-defined** target exists.

---

## How to switch modes

1. Open the Knowledge Keeper portal (`npm run dev` in `apps/admin`).
2. Use **Portal visual path** in the sidebar footer.
3. Choice persists in `localStorage` key `kuttiomp.admin.learningMode`.
4. Document root receives `data-admin-mode="<id>"` and updated CSS variables.

---

## Package API

```ts
import {
  ModeThemeProvider,
  ModeSwitcher,
  ModePanel,
  useModeTheme,
  MODE_TOKENS,
  type AdminLearningMode,
} from "@kuttiomp/admin-design-system";
```

- `ModeThemeProvider` — applies HSL tokens to `--background`, `--primary`, `--radius`, `--mode-font-*`, etc.
- `ModeSwitcher` — dignified four-button control (sidebar).
- `ModePanel` / `ModeMetricRow` — mode-scaled surfaces for custom sections.

---

## Maintainer checklist

```bash
cd apps/admin
npm install          # workspace links @kuttiomp/admin-design-system
npm run typecheck
npm run build
```

To change a mode palette: edit `packages/admin-design-system/src/modes.ts` only — all themed surfaces follow CSS variables.

---

## Demo script (short)

1. Sign in as Keeper.  
2. Dashboard → note Core Adult (default) crisp layout.  
3. Sidebar → switch to **Little Ones** → warmer rounded chrome.  
4. Switch to **Young Learner** → sky accent, clear hierarchy.  
5. Switch to **Elder** → high contrast, large type.  
6. Open **Stewardship** → absolute counts retheme; still no scores.  

**(Protocol 12: one package, one provider — findable in under an hour.)**
