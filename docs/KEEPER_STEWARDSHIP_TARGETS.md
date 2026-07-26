# Keeper Action Required — Lexicon Target & Priority Domains

**Status:** Not present in repository or Supabase configuration as of Stream D (5 July 2026).

## What is missing

| Item | Status |
|------|--------|
| Target lexicon size (`target_lexemes`) | **Not configured** — continuity percentage remains `null` |
| Priority domains for entry | **Not configured** |

## What stewards must not do

Do **not** invent numbers, percentages, or fabricated targets. Absolute approved counts are sufficient and culturally appropriate until Keepers define targets under elder authority.

## When Keepers supply values

1. Store target under a protocol-controlled config (Supabase) with elder review.
2. Update `corpus_continuity_metrics()` to return non-null `target_lexemes` and computed `continuity_pct`.
3. Continuity panels (admin + Flutter) will display the linear path only when a Keeper target exists.

This serves our people by keeping goals under living authority rather than software invention through 2050.
