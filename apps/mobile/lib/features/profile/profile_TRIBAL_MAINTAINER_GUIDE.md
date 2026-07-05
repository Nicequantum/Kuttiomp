# Tribal Maintainer Guide – Profile Module (v2.2.0+1)

**Onboarding target:** < 45 minutes.

## Purpose

Persistent mode selection, first-launch onboarding, profile sync, Elder override, and Keeper dashboard (§13, Protocol 9).

## Quick Navigation

1. `data/profile_repository.dart` → `syncProfile()`, `updateMode()`, `getAuditLog()`, `getCorpusStats()`.
2. `domain/profile_model.dart` → `ProfileModel`, `ProfilePreferences`.
3. `domain/mode_persistence_service.dart` → `persistAndSyncMode()`, `applyElderOverride()`.
4. `domain/profile_providers.dart` → Riverpod providers for profile, audit, corpus stats.
5. `presentation/first_launch_onboarding.dart` → audio-guided tour + consent + mode selection.
6. `presentation/mode_selection_bottom_sheet.dart` → persistent save from shell FAB long-press.
7. `presentation/profile_page.dart` → settings, accessibility toggles, Keeper dashboard, audit viewer.
8. `presentation/keeper_dashboard_view.dart` → approval queue + corpus statistics.
9. `core/bootstrap/first_launch_service.dart` → clean-install detection + onboarding completion.

## Data Flow

1. Clean install → `FirstLaunchService.shouldShowOnboarding()` → `/first-launch`.
2. User selects mode → `ModePersistenceService.persistAndSyncMode()` → SharedPreferences + JWT + Isar + RPC.
3. Shell FAB → cycle mode with full persistence; long-press → `ModeSelectionBottomSheet`.
4. Profile page → sync, accessibility prefs, quick links to all petals, Keeper panel, audit log.

## Verify

```bash
cd apps/mobile
flutter test test/features/profile/
flutter test test/offline/profile_persistence_test.dart
flutter run
```

**(Protocol 12 compliance verified)**