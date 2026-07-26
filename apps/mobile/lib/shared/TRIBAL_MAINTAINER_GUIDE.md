# Tribal Maintainer Guide – Shared Layer (v2.0)

**Onboarding target:** < 45 minutes for bootstrap traceability.

## Purpose

Shared widgets, design system primitives, and cross-feature utilities. Every UI element extends or wraps `ProtocolBaseWidget` / `ApprovedContentGate`.

## Quick Navigation

1. **Locate bootstrap sequence in `app_bootstrap.dart` – entire foundation traceable in <45 minutes.**
2. Open `lib/shared/widgets/approved_content_gate.dart` → Protocol 2 elder-approval gate.
3. Open `lib/shared/widgets/tier_aware_page.dart` → Protocol 3 tier enforcement.
4. Open `lib/shared/design_system/kuttiomp_design_system.dart` → dignity + land palette.
5. Open `lib/core/routing/app_router.dart` → `_TierGatedShell` wraps all routed pages.

## Component 5 – Bootstrap & Navigation

- `lib/core/bootstrap/app_bootstrap.dart` — Protocol → Supabase Auth → Isar → Riverpod → Modes → Profile → Navigation.
- `lib/features/dashboard/dashboard_shell_page.dart` — four mode petals + unified mastery display.
- `lib/features/profile/persistence_provider.dart` — `UserProfilePersistence.syncWithSupabase()`.

## Verify

```bash
cd apps/mobile
flutter test test/offline/
flutter analyze --no-pub
```

**(Protocol 12 compliance verified)**