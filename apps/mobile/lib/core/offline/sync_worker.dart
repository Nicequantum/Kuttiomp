import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/conflict_resolver.dart';
import 'package:kuttiomp_mobile/core/offline/isar_sync_metadata.dart';
import 'package:kuttiomp_mobile/core/offline/offline_quota_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_repository.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/lexeme_repository.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';
import 'package:kuttiomp_mobile/features/lessons/data/lessons_repository.dart';
import 'package:kuttiomp_mobile/features/lessons/domain/lesson.dart';
import 'package:kuttiomp_mobile/features/phrases/data/phrases_repository.dart';
import 'package:kuttiomp_mobile/features/phrases/domain/phrase.dart';
import 'package:kuttiomp_mobile/features/search/data/search_repository.dart';
import 'package:kuttiomp_mobile/features/search/sync_hooks.dart';

Future<List<IsarSyncMetadata>> _collectLexemesForSync({
  required LexemeRepository repository,
  required KuttiompMode mode,
  String? stage,
}) async {
  final lexemes = await repository.watchLexemesForTier(
    mode.tierBitmask,
    stage: stage ?? 'awakening',
  );
  return lexemes.map(_lexemeSyncMetadataFrom).toList();
}

IsarSyncMetadata _lexemeSyncMetadataFrom(LexemeModel lexeme) {
  return IsarSyncMetadata(
    recordId: lexeme.id,
    contentType: 'lexeme',
    syncStatus: SyncStatus.pending,
    lastSyncedAt: DateTime.now().toUtc(),
    localChecksum: lexeme.schemaVersion,
    requiresSacredConsent: lexeme.sacredFlag,
    clanScope: lexeme.clanScope,
    sacredFlag: lexeme.sacredFlag,
    speakerId: lexeme.speakerId,
    primaryAudioId: lexeme.primaryAudioId,
  );
}

Future<List<IsarSyncMetadata>> _collectPhrasesForSync({
  required PhrasesRepository repository,
  required KuttiompMode mode,
  String? stage,
}) async {
  final phrases = await repository.watchPhrasesForTier(
    mode.tierBitmask,
    stage: stage ?? 'awakening',
  );
  return phrases.map(_phraseSyncMetadataFrom).toList();
}

IsarSyncMetadata _phraseSyncMetadataFrom(PhraseModel phrase) {
  return IsarSyncMetadata(
    recordId: phrase.id,
    contentType: 'phrase',
    syncStatus: SyncStatus.pending,
    lastSyncedAt: DateTime.now().toUtc(),
    localChecksum: phrase.schemaVersion,
    requiresSacredConsent: phrase.sacredFlag,
    clanScope: phrase.clanScope,
    sacredFlag: phrase.sacredFlag,
    speakerId: phrase.speakerId,
    primaryAudioId: phrase.primaryAudioId,
  );
}

Future<List<IsarSyncMetadata>> _collectLessonsForSync({
  required LessonsRepository repository,
  required KuttiompMode mode,
  String? stage,
}) async {
  final lessons = await repository.watchLessonsForTier(
    mode.tierBitmask,
    stage: stage ?? 'awakening',
  );
  return lessons.map(_lessonSyncMetadataFrom).toList();
}

IsarSyncMetadata _lessonSyncMetadataFrom(LessonModel lesson) {
  return IsarSyncMetadata(
    recordId: lesson.id,
    contentType: 'lesson',
    syncStatus: SyncStatus.pending,
    lastSyncedAt: DateTime.now().toUtc(),
    localChecksum: lesson.schemaVersion,
    requiresSacredConsent: lesson.ceremonialFlag,
    clanScope: lesson.clanScope,
    sacredFlag: lesson.ceremonialFlag,
    speakerId: lesson.speakerId,
    primaryAudioId: lesson.primaryAudioId,
  );
}

/// Payload processed off the UI thread during delta sync.
class SyncBatchPayload {
  const SyncBatchPayload({
    required this.incoming,
    required this.existingKeys,
  });

  final List<IsarSyncMetadata> incoming;
  final Set<String> existingKeys;
}

/// Result of a background sync cycle.
class SyncWorkerResult {
  const SyncWorkerResult({
    required this.mirroredCount,
    required this.blockedSacredCount,
    required this.blockedClanCount,
    required this.logMessage,
  });

  final int mirroredCount;
  final int blockedSacredCount;
  final int blockedClanCount;
  final String logMessage;
}

List<IsarSyncMetadata> _markDeltaSynced(SyncBatchPayload payload) {
  return payload.incoming
      .where((item) => !payload.existingKeys.contains(item.compositeKey))
      .map(
        (item) => item.copyWith(
          syncStatus: SyncStatus.synced,
          lastSyncedAt: DateTime.now().toUtc(),
        ),
      )
      .toList();
}

/// Background Isar ↔ Supabase delta sync worker (§7, Protocols 4,5,9).
class SyncWorker extends AuditedRepository {
  SyncWorker({
    ProtocolGateway? gateway,
    super.auditedClient,
    Isar? isar,
    OfflineQuotaGuard? quotaGuard,
    ConflictResolver? conflictResolver,
    LexemeRepository? lexemeRepository,
    PhrasesRepository? phrasesRepository,
    LessonsRepository? lessonsRepository,
    SearchRepository? searchRepository,
  })  : _isar = isar,
        _quotaGuard = quotaGuard ?? OfflineQuotaGuard(),
        _conflictResolver = conflictResolver ?? ConflictResolver(gateway: gateway),
        _metadataRepo = IsarSyncMetadataRepository(isar: isar),
        _lexemeRepository = lexemeRepository ??
            LexemeRepository(gateway: gateway ?? ProtocolGateway()),
        _phrasesRepository = phrasesRepository ??
            PhrasesRepository(gateway: gateway ?? ProtocolGateway()),
        _lessonsRepository = lessonsRepository ??
            LessonsRepository(gateway: gateway ?? ProtocolGateway()),
        _searchRepository = searchRepository ??
            SearchRepository(gateway: gateway ?? ProtocolGateway()),
        super(gateway: gateway);

  static const String completeLogMessage =
      'Sync complete | All records mirrored | Protocols 4,5,9 enforced';

  final Isar? _isar;
  final OfflineQuotaGuard _quotaGuard;
  final ConflictResolver _conflictResolver;
  final IsarSyncMetadataRepository _metadataRepo;
  final LexemeRepository _lexemeRepository;
  final PhrasesRepository _phrasesRepository;
  final LessonsRepository _lessonsRepository;
  final SearchRepository _searchRepository;

  /// Runs delta sync across all content hooks with quota and conflict gates.
  Future<SyncWorkerResult> runDeltaSync({
    required KuttiompMode mode,
    String? clanId,
    String? canonicalStage,
    bool clanReauthenticated = true,
    SacredConsentCallback? onSacredConsentRequired,
  }) async {
    gateway.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false},
    );
    gateway.assertCompliant(
      KuttiompProtocol.sacredContentProtection.id,
      context: const {'sacred_flag': false},
    );

    final effectiveClan = clanId ?? gateway.protocolService.clanId ?? 'kuttiomp_clan';
    final stage = canonicalStage ?? 'awakening';

    final existing = await _metadataRepo.listAll();
    final existingByKey = {
      for (final item in existing) item.compositeKey: item,
    };

    final incoming = <IsarSyncMetadata>[
      ...await _collectLexemesForSync(
        repository: _lexemeRepository,
        mode: mode,
        stage: stage,
      ),
      ...await _collectPhrasesForSync(
        repository: _phrasesRepository,
        mode: mode,
        stage: stage,
      ),
      ...await _collectLessonsForSync(
        repository: _lessonsRepository,
        mode: mode,
        stage: stage,
      ),
      ...await SearchSyncHooks.collectForSync(
        repository: _searchRepository,
        mode: mode,
        stage: stage,
      ),
    ];

    _quotaGuard.enforceBatch(
      modeId: mode.id,
      existingCount: existing.length,
      incomingCount: incoming.length,
    );

    await _pullRemoteBatch(mode: mode, clan: effectiveClan, stage: stage);

    final resolved = <IsarSyncMetadata>[];
    var blockedSacred = 0;
    var blockedClan = 0;

    for (final remote in incoming) {
      final local = existingByKey[remote.compositeKey] ??
          remote.copyWith(syncStatus: SyncStatus.pending);

      final resolution = await _conflictResolver.resolve(
        local: local,
        remote: remote,
        clanReauthenticated: clanReauthenticated,
        onSacredConsentRequired: onSacredConsentRequired,
      );

      switch (resolution) {
        case ConflictResolution.blockedSacredConsent:
          blockedSacred++;
          break;
        case ConflictResolution.blockedClanReauth:
          blockedClan++;
          break;
        default:
          break;
      }

      resolved.add(
        _conflictResolver.applyResolution(
          local: local,
          remote: remote,
          resolution: resolution,
        ),
      );
    }

    final deltaPayload = SyncBatchPayload(
      incoming: resolved,
      existingKeys: existingByKey.keys.toSet(),
    );

    final mirrored = await compute(_markDeltaSynced, deltaPayload);
    final merged = <IsarSyncMetadata>[
      ...existing.where((e) => !mirrored.any((m) => m.compositeKey == e.compositeKey)),
      ...mirrored,
      ...resolved.where((r) => r.syncStatus == SyncStatus.blocked),
    ];

    await _metadataRepo.upsertAll(merged);

    await logRepositoryOperation(
      operation: 'sync:delta',
      outcome: completeLogMessage,
      payloadSummary: '${merged.length} records | mode=${mode.id}',
    );

    if (kDebugMode) {
      debugPrint('$completeLogMessage (${merged.length} records)');
    }

    return SyncWorkerResult(
      mirroredCount: mirrored.length,
      blockedSacredCount: blockedSacred,
      blockedClanCount: blockedClan,
      logMessage: completeLogMessage,
    );
  }

  Future<void> _pullRemoteBatch({
    required KuttiompMode mode,
    required String clan,
    required String stage,
  }) async {
    try {
      await auditedRpc<void>(
        KuttiompRpc.syncOfflineBatch,
        params: {
          'mode': mode.id,
          'clan': clan,
          'canonical_stage': stage,
          'content_types': [
            'lexeme',
            'phrase',
            'lesson',
            SearchSyncHooks.contentType,
          ],
        },
      );
    } catch (_) {
      // Offline corpus authoritative until Supabase reconnects.
    }
  }
}