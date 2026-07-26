# Tribal Maintainer Guide – Core Infrastructure (v2.0)

**Onboarding target:** < 60 minutes (Components 1–2).

## Purpose

This module is the cultural and technical firewall for the Kuttiomp mobile application. It enforces all 12 Cultural Governance Protocols before any UI or data layer code can execute.

## Quick Navigation

1. Open `lib/core/protocol/protocol_service.dart` → search `assertCompliant` to see all 12 guards.
2. Open `lib/core/protocol/guards/` → one file per protocol.
3. Open `lib/core/protocol/protocol_gateway.dart` → entry point for repositories and widgets.
4. Open `lib/core/supabase/audited_client.dart` → audited RPC-only data access (Protocol 9).
5. Open `lib/core/utils/integrity_validator.dart` → build-time compliance checks (Protocol 12).
6. Open `lib/core/di/injection.dart` → Riverpod providers (Component 2).
7. Open `lib/core/di/isar_database.dart` → offline mirror bootstrap.
8. Open `lib/core/supabase/isar_schemas.dart` → `ProtocolMetadata` + audit collections.

## Component 4 – Mode System & Instant Switching

Search **`ProtocolBaseWidget`** or **`KuttiompThemeExtension.forMode`** to locate cultural enforcement points.

- `lib/modes/mode_controller.dart` (via `lib/core/di/`) — `switchMode()` + `enforceNewMode`
- `lib/modes/content_renderer.dart` — `adaptForMode()` strategy pattern
- `lib/core/routing/app_router.dart` — StatefulShellRoute + FadeScaleTransition
- `lib/core/di/mode_redirect_middleware.dart` — tier + first-launch redirects
- `lib/features/profile/first_launch_mode_selection.dart` — §13 audio-guided selection

## Component 3 – Theme & Design System

Search **`ProtocolBaseWidget`** or **`KuttiompThemeExtension.forMode`** to locate cultural enforcement points.

- `lib/core/theme/kuttiomp_theme.dart` + `kuttiomp_theme_extension.dart` — mode-adaptive typography and land palette.
- `lib/core/theme/accessibility_engine.dart` — Protocol 11 elder-centric overrides.
- `lib/shared/design_system/` — dignified primitives (button, card, oral-first player).
- `lib/shared/widgets/` — protocol gates, badges, elder overlay.
- `lib/config/build_guards/dignity_lint.yaml` — Protocol 10 strengthened rules.

## Component 6 – Foundation Golden Lock

**Locate bootstrap sequence in `app_bootstrap.dart` – entire foundation traceable in <45 minutes.**

- `lib/features/auth/auth_service.dart` — full session: `ensureSession()`, `updateModeViaRpc()`.
- `lib/features/profile/profile_page.dart` — sync, mastery stages, elder override simulation.
- `lib/features/dashboard/widgets/` — `dashboard_header.dart`, `mastery_stage_indicator.dart`.
- `lib/core/constants/mastery_stages.dart` — six canonical stages (§6).
- `test/foundation/foundation_golden_lock_test.dart` — per-mode dashboard golden lock.
- `test/offline/full_offline_functionality_test.dart` — zero-external-service verification.

```bash
cd apps/mobile
flutter test test/foundation/ test/offline/ test/protocol_compliance/ test/mode_consistency/
```

## Component 5 – Application Bootstrap & Navigation

**Locate bootstrap sequence in `app_bootstrap.dart` – entire foundation traceable in <45 minutes.**

- `AppBootstrap.initialize()` runs: Protocol → Supabase Auth → Isar → Riverpod → Modes → Profile → Navigation.
- `lib/features/auth/auth_service.dart` — JWT claims for mode/clan/role.
- `lib/features/profile/persistence_provider.dart` — encrypted Isar mirror + Protocol 9 audit.
- `lib/core/routing/app_router.dart` — `_TierGatedShell` + `ApprovedContentGate` on every route.
- `lib/features/dashboard/dashboard_shell_page.dart` — four mode petals stub.

## Component 2 – DI & Audited Data Layer

- `AppBootstrap.initialize()` in `lib/core/bootstrap/app_bootstrap.dart` runs the full bootstrap sequence.
- `AuditedSupabaseClient.initialize()` enforces RPC-only access (Protocol 9).
- `OfflineQuotaGuard` enforces per-mode offline limits (Protocol 7).
- Regenerate providers: `dart run build_runner build --delete-conflicting-outputs`.

## Common Tasks

### Add a new protocol guard

1. Create `lib/core/protocol/guards/your_guard.dart` extending `ProtocolGuard`.
2. Register it in `KuttiompProtocolService._registerGuards()`.
3. Add enum entry in `lib/core/constants/protocols.dart` if needed.
4. Add test case in `test/protocol_compliance/full_12_protocol_suite_test.dart`.

### Verify compliance

```bash
cd apps/mobile
flutter test test/protocol_compliance/full_12_protocol_suite_test.dart
flutter analyze --no-pub
```

## Cultural Commitment

This module enforces sovereignty so that our small team can protect sacred knowledge for generations.

**(Protocol 12 compliance verified)**