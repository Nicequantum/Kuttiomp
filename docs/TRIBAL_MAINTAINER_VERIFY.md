# Tribal Maintainer — Local Verification Commands

**Baseline:** origin/main (Isar 4 call-site alignment)  
**MAD §12 package pins:** Flutter ≥ 3.24, Riverpod ^2.5.1, Isar 4.x, Supabase Flutter ^2.8.0  

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
- `isar: 4.0.0-dev.14` (pub.dev current Isar 4 line; MAD targets ^4.1.0 when released)
- `isar_flutter_libs: 4.0.0-dev.14`
- `supabase_flutter: ^2.8.0`

Freezed decision: hand-written models — `lib/config/FREEZED_DECISION.md`.

## Isar 4 offline mirror (regenerate + call sites)

Schemas live in `lib/core/supabase/isar_schemas.dart`. Generated code: `isar_schemas.g.dart`.

```bash
cd apps/mobile
flutter pub get
# After schema field changes only:
dart run build_runner build --delete-conflicting-outputs
# Restore Riverpod .g.dart if build_runner wiped them:
# git checkout HEAD -- lib/core/di/injection.g.dart lib/core/di/mode_controller.g.dart
```

Isar 4 runtime API (must use these; Isar 3 patterns fail compile):

| Isar 3 | Isar 4 |
|--------|--------|
| `Isar.open([...], directory: …)` | `Isar.openAsync(schemas: [...], directory: …)` |
| `await isar.writeTxn(() async { … })` | `await isar.writeAsync((isar) { … })` |
| `await collection.put(obj)` | `obj.id = col.autoIncrement()` when `id == 0`; then `col.put(obj)` (sync void) |
| `collection.where().findAll()` | `await collection.where().findAllAsync()` |

Primary call sites:

- `lib/core/di/isar_database.dart` — open + auto-id helper
- `lib/core/supabase/audited_client.dart` — audit log put
- `lib/core/offline/isar_sync_metadata.dart`
- `lib/features/lexeme|phrases|lessons/data/isar_*_collection.dart`
- `lib/features/profile/user_profile_service.dart`

```bash
flutter analyze lib
# Zero analyzer *errors* required before launch (infos/warnings may remain).
```

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

## Launch prototype

```bash
cd apps/mobile
flutter pub get
flutter analyze lib   # zero errors
dart run scripts/dignity_lint.dart
flutter devices
# Prefer Android emulator when ANDROID_HOME is set:
# flutter run -d <device_id>
# Desktop (if windows/ scaffolded):
# flutter run -d windows
```

Manual verify after launch:

1. Sign-in (or guest offline) succeeds
2. Stewardship summary shows absolute counts (live RPC or offline fallback)
3. Lexemes / Phrases / Lessons load under ApprovedContentGate
4. Oral-first player presents speaker-attributed audio
5. No gamified or playful UI (Protocol 10)

## Speaker handoff docs

- `docs/SPEAKER_KEEPER_DEMO_PATH.md`
- `docs/CURRENT_PROTOTYPE_CAPABILITY_STATEMENT.md`
- `docs/MIGRATION_005_APPLY.md`

**(Protocol 12 compliance verified)**