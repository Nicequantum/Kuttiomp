# Apply Migration 005 — Stewardship Continuity RPCs

**File:** `supabase/migrations/005_stewardship_continuity_views.sql`  
**Status in repo:** Present (committed with Stream D).  
**Status in hosted Supabase:** Must be applied by the steward (not auto-applied from git alone).

## Exact steps

### Option A — Supabase SQL Editor

1. Open [Supabase Dashboard](https://supabase.com/dashboard) → your Kuttiomp project.
2. Left nav → **SQL Editor** → New query.
3. Paste the full contents of `supabase/migrations/005_stewardship_continuity_views.sql`.
4. Click **Run**.
5. Confirm no errors in the result pane.

### Option B — Supabase CLI

```bash
# From monorepo root, linked project
supabase db push
# or apply single file:
# psql "$DATABASE_URL" -f supabase/migrations/005_stewardship_continuity_views.sql
```

## Confirmation method

```sql
-- 1) Functions exist
SELECT proname FROM pg_proc
WHERE proname IN ('speaker_stewardship_summary', 'corpus_continuity_metrics');

-- 2) Corpus metrics return absolute counts; targets stay null
SELECT
  total_approved_lexemes,
  target_lexemes,
  continuity_pct
FROM corpus_continuity_metrics();
-- Expect: total_approved_lexemes >= 0, target_lexemes IS NULL, continuity_pct IS NULL

-- 3) Speaker summary (use a real speaker UUID from speakers table)
SELECT * FROM speaker_stewardship_summary(
  (SELECT id FROM speakers LIMIT 1)
);
```

## Client behavior before / after

| Stage | Admin Continuity panel | Flutter Stewardship card |
|-------|------------------------|---------------------------|
| Before apply | Sample / offline absolute counts | Offline absolute counts from approved non-sacred lexemes |
| After apply + network | Prefer live RPC | Prefer live RPC; fallback if offline |

**Never invent `target_lexemes` or `continuity_pct`.** Keepers define targets under living authority (see `KEEPER_STEWARDSHIP_TARGETS.md`).