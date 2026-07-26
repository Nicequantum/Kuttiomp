# Tribal Maintainer Guide – Corpus Stewardship (Stream D)

**Onboarding:** &lt; 1 hour  
**Protocols:** 1, 2, 9, 10 (absolute — no gamification)

## Purpose

Show Knowledge Keepers and speakers **absolute** contribution counts as service to the living language. Never points, streaks, ranks, or playful progress games.

## Files

| Path | Role |
|------|------|
| `data/stewardship_repository.dart` | Audited absolute counts from living lexeme corpus |
| `domain/stewardship_models.dart` | Immutable summary + continuity metrics |
| `presentation/stewardship_summary_card.dart` | Flutter Core Adult / Elder card |
| `supabase/migrations/005_stewardship_continuity_views.sql` | RPC definitions |
| `apps/admin/.../continuity-panel.tsx` | Admin Continuity panel |
| `apps/admin/.../stewardship/page.tsx` | Admin Stewardship page |

## Keeper note

**Target lexicon size and priority domains are not configured.**  
`target_lexemes` and `continuity_pct` stay `null` until Keepers supply them. Do not invent values.

## Verify

```bash
flutter test test/features/stewardship/
dart run scripts/dignity_lint.dart
```

**(Protocol 12 compliance verified)**