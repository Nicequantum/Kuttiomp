# Tribal Maintainer Guide – DI & Audited Data Layer (v2.0)

**Onboarding target:** < 20 minutes (Component 2 of Core Infrastructure).

## Purpose

This folder wires Riverpod 2.0 providers, audited Supabase access, Isar offline mirror, and offline quota enforcement.

## Key Files

| File | Purpose |
|------|---------|
| `injection.dart` | Riverpod `@Riverpod` providers + `setupProviders()` |
| `injection.g.dart` | Generated provider wiring (do not edit by hand) |
| `isar_database.dart` | Opens encrypted Isar mirror with tribal key derivation |
| `offline_quota_guard.dart` | Re-exports `OfflineQuotaGuard` (Protocol 7 quotas) |
| `mode_controller.dart` | Mode switching stub (expanded in Component 4) |

## Regenerate Code

```bash
cd apps/mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

## Trace a Data Flow (minutes, not hours)

1. UI → `ref.watch(auditedClientProvider)` in `injection.dart`
2. `AuditedSupabaseClient.rpc()` in `../supabase/audited_client.dart`
3. Protocol 9 assertion → Isar `IsarAuditLogEntry` persistence
4. Offline reads → `IsarDatabase.instance` + `ProtocolMetadata` collections

## Verify

```bash
flutter test test/protocol_compliance/full_12_protocol_suite_test.dart
```

**(Protocol 12 compliance verified)**