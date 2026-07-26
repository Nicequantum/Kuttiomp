# Speaker / Keeper Demo Path

**Audience:** Speakers, Knowledge Keepers, and tribal stewards  
**Architecture:** Production Kuttiomp app (not a disposable prototype)  
**Baseline:** origin/main at `3e30ada` and later Stream F hygiene commits  

This document uses plain, respectful language. It describes the system as it exists today under the 12 Cultural Governance Protocols.

---

## What you are using

You are using the **real Kuttiomp architecture** — the same Flutter learner app, admin portal, protocol guards, and offline mirror that will serve households for decades. There is no separate “demo build.” Sparse sample words and phrases are elder-approvable teaching material, not a toy dataset.

---

## Path A — Speaker / Keeper entry (admin)

1. Open the **Knowledge Keeper portal** (`apps/admin`).
2. Sign in with your Keeper credentials.
3. Optionally switch **Portal visual path** in the sidebar (Little Ones / Young Learner / Core Adult / Elder) to preview how each generation experiences the same dignified workspace — see `docs/ADMIN_UI_MODES.md`. No gamification appears in any path.
4. Go to **Lexicon** (or **Lexicon Editor**) to enter or review a word.
   - Each entry carries **speaker attribution** (who said it).
   - Entries wait for **elder approval** before they join the living learner corpus.
4. On the Lexicon page (and under **Stewardship** in the sidebar), open the **Corpus Stewardship** panel.
5. You will see **absolute counts only**, for example:
   - Submitted  
   - Pending elder review  
   - Approved living  
   - Primary audio attributions  
   - Total approved lexemes in the living corpus  
6. The affirmation text is service-oriented:  
   *“Your attributed contributions strengthen the living language for the generations.”*

There are **no points, ranks, streaks, badges, or leaderboards**. That is intentional and permanent under Protocol 10 (dignity).

---

## Path B — How that content reaches learners (Flutter)

1. Open the **Kuttiomp mobile app**.
2. The app starts with cultural governance armed (protocol service + learning mode).
3. Choose or switch among the **four modes**: Little Ones, Young Learner, Core Adult, Elder.  
   Each mode adapts type size and presentation; Elder uses larger type and accessibility overlays.
4. From the **dashboard**:
   - **Lexemes** — mastery petal → list → word detail  
   - **Phrases** — list → phrase detail  
   - **Lessons** — list → lesson detail (oral sequence)  
5. On every detail path you should notice:
   - **Oral-first** audio control (voice before text)  
   - **Speaker attribution** and **living authority** badge  
   - **Elder-approval gate** (pending content does not show as living)  
   - **Land context** when a place is attached  
   - **Sacred / ceremonial** content requires consent and does not appear casually for all ages  
6. Use **Search** to find words, phrases, and lessons under the same gates.
7. In **Core Adult** or **Elder** mode, open **Profile** (or the dashboard stewardship section) to see the same style of **absolute contribution counts** for attributed speakers.

Offline: approved, non-sacred content can remain available on the device under clan and quota rules.

---

## Continuity percentages and communal targets

Today, the system shows **counts**, not a “percent complete” toward a communal goal.

- A **target lexicon size** and **priority domains** have **not** been defined by Keepers in configuration.
- The system will **not invent** those numbers.
- When Keepers, under living authority, set a target, the Continuity panel can show a simple high-contrast linear path toward that target — still without points or competition.

See also: `docs/KEEPER_STEWARDSHIP_TARGETS.md`.

---

## Applying Stewardship RPCs (technical stewards)

Until Supabase has the stewardship functions applied, Flutter and admin use **offline absolute counts**.

1. Open the Supabase project SQL Editor (or CLI).
2. Run the contents of:  
   `supabase/migrations/005_stewardship_continuity_views.sql`
3. Confirm in SQL:

```sql
SELECT * FROM corpus_continuity_metrics();
-- Expect total_approved_lexemes (number), target_lexemes NULL, continuity_pct NULL

SELECT * FROM speaker_stewardship_summary('b0000000-0000-0000-0000-000000000001'::uuid);
-- Expect absolute counts for that speaker when data exists
```

4. Restart the Flutter app / refresh admin. Live RPC will be preferred; offline fallback remains if the network fails.

---

## Closing respect

Every attributed recording and entry is a gift to the living language. Kuttiomp exists to hold that gift with care — under elder approval, speaker sovereignty, and dignity for every generation.

**(Protocol 12 — tribal handoff document)**