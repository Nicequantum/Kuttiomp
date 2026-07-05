# Tribal Maintainer Guide – Auth (v2.0)

**Onboarding target:** < 45 minutes for bootstrap traceability.

## Purpose

Full Supabase Auth with custom JWT claims for mode, clan, and role (§3, §13, Component 6).

## Quick Navigation

1. **Locate bootstrap sequence in `app_bootstrap.dart` – entire foundation traceable in <45 minutes.**
2. Open `lib/features/auth/auth_service.dart` → `ensureSession()`, `syncModeClaim()`, `updateModeViaRpc()`.
3. Open `lib/features/auth/auth_state.dart` + `auth_state_provider.dart` → reactive snapshots.
4. Open `lib/core/routing/auth_redirect_guard.dart` → guest-permitted offline access.

## Auth Flow

1. Bootstrap calls `ensureSession()` — anonymous sign-in when Supabase available.
2. Claims extracted from JWT metadata → `KuttiompProtocolService.updateClaims()`.
3. Mode changes call `update_user_mode_secure` audited RPC (never direct tables).
4. Guest fallback (`guest-kuttiomp`) when offline.

## Verify

```bash
cd apps/mobile
flutter test test/offline/full_offline_functionality_test.dart
```

**(Protocol 12 compliance verified)**