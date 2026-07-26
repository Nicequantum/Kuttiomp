import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/offline/conflict_resolver.dart';
import 'package:kuttiomp_mobile/core/offline/offline_quota_guard.dart';
import 'package:kuttiomp_mobile/core/offline/sync_worker.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/features/lessons/data/lessons_repository.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/lexeme_repository.dart';
import 'package:kuttiomp_mobile/features/phrases/data/phrases_repository.dart';
import 'package:kuttiomp_mobile/features/search/data/search_repository.dart';

/// Tribal bootstrap entry for background Isar ↔ Supabase sync (§7, Protocols 4,5,9).
///
/// Enforces sacred/clan consent gates and per-mode offline quotas before mirroring.
class OfflineWorker {
  OfflineWorker({
    ProtocolGateway? gateway,
    SyncWorker? syncWorker,
    OfflineQuotaGuard? quotaGuard,
  })  : _gateway = gateway ?? ProtocolGateway(),
        _syncWorker = syncWorker ??
            SyncWorker(
              gateway: gateway,
              quotaGuard: quotaGuard ?? OfflineQuotaGuard(),
              lexemeRepository: LexemeRepository(gateway: gateway),
              phrasesRepository: PhrasesRepository(gateway: gateway),
              lessonsRepository: LessonsRepository(gateway: gateway),
              searchRepository: SearchRepository(gateway: gateway),
            );

  final ProtocolGateway _gateway;
  final SyncWorker _syncWorker;

  static const String bootstrapLogMessage =
      'OfflineWorker bootstrap | Sacred/clan consent + quota enforced | Protocols 4,5,9';

  /// Runs one background delta sync cycle during app startup or manual refresh.
  static Future<SyncWorkerResult> bootstrap({
    required KuttiompMode mode,
    String? clanId,
    String? canonicalStage,
    SacredConsentCallback? onSacredConsentRequired,
    bool clanReauthenticated = true,
  }) async {
    final worker = OfflineWorker();
    return worker.runBackgroundSync(
      mode: mode,
      clanId: clanId,
      canonicalStage: canonicalStage,
      onSacredConsentRequired: onSacredConsentRequired,
      clanReauthenticated: clanReauthenticated,
    );
  }

  Future<SyncWorkerResult> runBackgroundSync({
    required KuttiompMode mode,
    String? clanId,
    String? canonicalStage,
    SacredConsentCallback? onSacredConsentRequired,
    bool clanReauthenticated = true,
  }) async {
    _gateway.assertCompliant(
      '9',
      context: const {'direct_table_access': false},
    );

    final result = await _syncWorker.runDeltaSync(
      mode: mode,
      clanId: clanId,
      canonicalStage: canonicalStage,
      clanReauthenticated: clanReauthenticated,
      onSacredConsentRequired: onSacredConsentRequired,
    );

    if (kDebugMode) {
      debugPrint('$bootstrapLogMessage → ${result.logMessage}');
    }

    return result;
  }
}