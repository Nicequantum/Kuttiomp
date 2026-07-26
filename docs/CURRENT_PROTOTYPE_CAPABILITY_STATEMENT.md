# Current Prototype Capability Statement

**For:** Speakers, Knowledge Keepers, and tribal stewards  
**Architecture:** Production Kuttiomp platform (not a temporary demo)  
**Baseline:** origin/main at `030c0b2` and subsequent light hygiene commits  
**Constitution:** Kuttiomp Master Architecture Document v2.0 — 12 Cultural Governance Protocols  

---

## In plain language

What you can use **today** is the **real** Kuttiomp system: the same admin portal, Flutter learner app, cultural gates, and offline mirror that will serve households for decades. Sparse sample words and phrases are respectful teaching material—not a game and not a throwaway prototype.

---

## What a speaker or Knowledge Keeper can do today

1. Sign in to the **Knowledge Keeper portal**.
2. **Enter or review** lexicon entries with **speaker attribution** (who said the word).
3. Work under **elder approval**: content becomes “living” for learners only after approval paths allow it.
4. See **Corpus Stewardship** counts (absolute numbers only):
   - How many entries are submitted  
   - How many await elder review  
   - How many are approved and living  
   - How many carry primary audio attribution  
   - How large the approved living lexicon is overall  
5. Read the service affirmation:  
   *“Your attributed contributions strengthen the living language for the generations.”*

There are **no points, scores, streaks, ranks, badges, or leaderboards**. That is a permanent cultural rule (Protocol 10 — dignity).

If the Supabase stewardship functions are not yet applied, counts still appear from a **safe offline absolute-count path**. After migration `005` is applied, the panel prefers **live database RPCs** and falls back offline when the network is unavailable.

---

## What a learner experiences today (Flutter)

1. Open the **Kuttiomp mobile app** (protocol service and learning mode start first).
2. Move among **four modes**: Little Ones, Young Learner, Core Adult, Elder — each adapts presentation; Elder uses larger type and accessibility care.
3. From the **dashboard**, open:
   - **Lexemes** (words)  
   - **Phrases**  
   - **Lessons** (oral sequences)  
4. On content surfaces, expect:
   - **Oral-first** listening (voice before text)  
   - **Speaker attribution** and living authority  
   - **Elder-approval** gates (pending content is not treated as living)  
   - **Land context** when place is attached  
   - **Sacred / ceremonial** content behind consent, not casual display for all ages  
5. Use **Search** under the same cultural gates.
6. In **Core Adult** or **Elder** mode, view **Stewardship** absolute counts (dashboard and profile).

Offline: approved, non-sacred content may remain available under clan and quota rules.

---

## What this is — and what it is not

| This is | This is not |
|---------|-------------|
| Production architecture under MAD v2.0 | A disposable demo app |
| Culturally governed learning infrastructure | A points or ranking game |
| Absolute counts of attributed labor | Invented “percent complete” goals |
| Ready for sparse real dictionary growth | Dependent on a large artificial corpus |

---

## Communal targets and percentages

A **target lexicon size** and **priority domains** have **not** been defined by Keepers in configuration. The platform **will not invent** those numbers.

- `target_lexemes` and `continuity_pct` remain **null**.  
- Absolute counts are sufficient and respectful until Keepers, under **living authority**, set a target.  
- Then a simple high-contrast linear path may appear—still without competition.

See `docs/KEEPER_STEWARDSHIP_TARGETS.md` and `docs/MIGRATION_005_APPLY.md`.

---

## Steward operational note (migration)

To enable live stewardship RPCs in Supabase, apply:

`supabase/migrations/005_stewardship_continuity_views.sql`

Confirm with the SQL checks in `docs/MIGRATION_005_APPLY.md`.  
Flutter and admin already try live RPC first and fall back to absolute offline counts.

---

## Closing

Every attributed voice is a gift to the living language. Kuttiomp holds that gift under elder approval, speaker sovereignty, land relationship, and dignity for every generation—maintainable by a small tribal team through 2050 and beyond.

**(Protocol 12 — capability handoff statement)**