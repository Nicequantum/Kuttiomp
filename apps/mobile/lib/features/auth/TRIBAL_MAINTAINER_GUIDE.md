# Tribal Maintainer Guide – Auth

**Onboarding target:** &lt; 45 minutes  
**Constitution:** MAD v2.0 §§3, 4, 13

## Directory map (Stream F alignment)

```
features/auth/
├── data/auth_service.dart           # KuttiompAuthService (session + JWT claims)
├── domain/auth_state.dart           # KuttiompAuthSnapshot
├── presentation/auth_providers.dart # Riverpod authSnapshotProvider
├── auth_service.dart                # re-export (stable import path)
├── auth_state.dart                  # re-export
└── auth_state_provider.dart         # re-export
```

## One-hour path

1. Bootstrap: `core/bootstrap/app_bootstrap.dart` → `ensureSession()`.
2. Claims: `data/auth_service.dart` → `extractClaimsFromSession()` / `syncModeClaim()`.
3. Snapshot: `domain/auth_state.dart` → `KuttiompAuthSnapshot`.
4. Routing: `core/routing/auth_redirect_guard.dart` → guest offline path.

## Rules

- Mode updates go through audited RPC `update_user_mode_secure` (never direct tables).
- Guest id: `kGuestUserId` / `guest-kuttiomp` when offline.
- ProtocolService claims must update on every mode switch.

## Verify

```bash
flutter test test/offline/full_offline_functionality_test.dart
```

**(Protocol 12 compliance verified)**