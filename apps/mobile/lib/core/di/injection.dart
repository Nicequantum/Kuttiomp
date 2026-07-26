import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kuttiomp_mobile/core/di/isar_database.dart';

import 'package:kuttiomp_mobile/core/di/offline_quota_guard.dart';
import 'package:kuttiomp_mobile/core/offline/sync_worker.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_client.dart';

part 'injection.g.dart';

@Riverpod(keepAlive: true)
KuttiompProtocolService protocolService(ProtocolServiceRef ref) {
  return KuttiompProtocolService.instance;
}

@Riverpod(keepAlive: true)
ProtocolGateway protocolGateway(ProtocolGatewayRef ref) {
  return ProtocolGateway(protocolService: ref.watch(protocolServiceProvider));
}

@Riverpod(keepAlive: true)
AuditedSupabaseClient? auditedClient(AuditedClientRef ref) {
  try {
    return AuditedSupabaseClient(Supabase.instance.client);
  } catch (_) {
    return null;
  }
}

@Riverpod(keepAlive: true)
Isar? isarInstance(IsarInstanceRef ref) => IsarDatabase.instance;

@Riverpod(keepAlive: true)
OfflineQuotaGuard offlineQuotaGuard(OfflineQuotaGuardRef ref) {
  return OfflineQuotaGuard(protocolService: ref.watch(protocolServiceProvider));
}

@Riverpod(keepAlive: true)
SyncWorker syncWorker(SyncWorkerRef ref) {
  return SyncWorker(
    gateway: ref.watch(protocolGatewayProvider),
    auditedClient: ref.watch(auditedClientProvider),
    isar: ref.watch(isarInstanceProvider),
    quotaGuard: ref.watch(offlineQuotaGuardProvider),
  );
}

/// Provider overrides applied after Supabase + Isar bootstrap in main.
List<Override> buildProviderOverrides() {
  return [
    protocolServiceProvider.overrideWithValue(KuttiompProtocolService.instance),
  ];
}

void setupProviders({List<Override> extraOverrides = const []}) {
  // Called from main after ProtocolService.init(); overrides wired via ProviderScope.
  assert(KuttiompProtocolService.instance.isInitialized);
  assert(extraOverrides.isNotEmpty || true);
}