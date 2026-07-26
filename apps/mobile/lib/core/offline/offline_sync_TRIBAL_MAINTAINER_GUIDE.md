# Tribal Maintainer Guide – Offline Sync Worker (v2.0)

**Onboarding target:** < 45 minutes.

## Purpose

Background Isar ↔ Supabase delta sync with sacred/clan conflict resolution and per-mode quotas (§7, Protocols 4,5,9).

## Quick Navigation

**Search `sync_worker` to see delta sync flow; onboarding <45 minutes.**

1. Open `lib/core/offline/sync_worker.dart` → `runDeltaSync()` orchestrates all content hooks.
2. Open `lib/core/offline/conflict_resolver.dart` → sacred consent + clan re-auth gates.
3. Open `lib/core/offline/offline_quota_guard.dart` → per-mode record limits.
4. Open `lib/core/offline/isar_sync_metadata.dart` → `ProtocolMetadata` sync extensions.
5. Open `lib/features/*/sync_hooks.dart` → lexeme, phrase, lesson, search batch collectors.
6. Open `lib/core/di/injection.dart` → `syncWorkerProvider`.

## Data Flow

1. `SyncWorker.runDeltaSync()` pulls `sync_offline_batch_secure` RPC.
2. Feature `sync_hooks` collect governed records for the active stage/mode.
3. `ConflictResolver` applies backend-wins policy; sacred records require consent callback.
4. `OfflineQuotaGuard.enforceBatch()` blocks over-quota mirrors.
5. Delta batch processed via `compute()` isolate; metadata written to Isar `ProtocolMetadata`.
6. Every successful cycle logs: `Sync complete | All records mirrored | Protocols 4,5,9 enforced`.

## Verify

```bash
cd apps/mobile
flutter test test/offline/full_offline_functionality_test.dart
flutter run
```

Expected: background sync simulation → sacred record triggers consent → quota respected → completion log.

**(Protocol 12 compliance verified)**