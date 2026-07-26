# Tribal Maintainer — Local Verification Commands

**Baseline:** origin/main (post Stream F hygiene)  
**MAD §12 package pins:** Flutter ≥ 3.24, Riverpod ^2.5.1, Isar ^4.1.0, Supabase Flutter ^2.8.0  

This serves our people by giving a 3–5 person team a single offline verification checklist for 25 years.

## Package pins (inspect)

```bash
cd apps/mobile
# Confirm environment flutter >= 3.24 and sdk >= 3.5
head -n 25 pubspec.yaml
```

Expected highlights in `pubspec.yaml`:

- `flutter: ">=3.24.0"`
- `flutter_riverpod: ^2.5.1`
- `isar: ^4.1.0`
- `supabase_flutter: ^2.8.0`

Freezed decision: hand-written models — `lib/config/FREEZED_DECISION.md`.

## Protocol 10 — DignityLint (must pass)

```bash
cd apps/mobile
dart run scripts/dignity_lint.dart
# Exit code 0 = pass; exit code 1 = Protocol 10 violation (build must fail)

flutter test test/protocol_compliance/dignity_lint_test.dart
```

## Protocol suite (offline)

```bash
cd apps/mobile
flutter test test/protocol_compliance/
flutter test test/features/lexeme/
flutter test test/features/phrases/
flutter test test/features/lessons/
flutter test test/features/stewardship/
flutter test test/offline/
flutter test test/mode_consistency/render_all_modes_test.dart
```

## Goldens (dashboard chrome / modes)

```bash
cd apps/mobile
# Compare against committed goldens
flutter test test/features/dashboard/dashboard_golden_per_mode_test.dart
flutter test test/golden/design_system_golden_test.dart

# Only if intentional visual change under elder review:
# flutter test test/features/dashboard/dashboard_golden_per_mode_test.dart --update-goldens
```

Stream F unified petals may require golden refresh after visual review—do not update goldens casually.

## Stewardship live RPC vs offline

```bash
# After applying migration 005 in Supabase (see MIGRATION_005_APPLY.md):
# Flutter: StewardshipRepository tries rawClient.rpc first, then absolute offline counts.
# Admin: ContinuityPanelLive shows "Data source: Live database..." or offline fallback.
flutter test test/features/stewardship/stewardship_protocol_compliance_test.dart
```

## Three content pathways (gated + oral-first)

| Pathway | List route | Detail route |
|---------|------------|--------------|
| Lexemes | `/lexemes` | `/lexeme/:id` |
| Phrases | `/phrases` | `/phrase/:id` |
| Lessons | `/lessons` | `/lesson/:id` |

Confirm each uses ApprovedContentGate / oral-first player / AuthorityBadge in feature presentation layers.

## Speaker handoff docs

- `docs/SPEAKER_KEEPER_DEMO_PATH.md`
- `docs/CURRENT_PROTOTYPE_CAPABILITY_STATEMENT.md`
- `docs/MIGRATION_005_APPLY.md`

**(Protocol 12 compliance verified)**