import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/offline/isar_sync_metadata.dart';
import 'package:kuttiomp_mobile/features/search/data/search_repository.dart';
import 'package:kuttiomp_mobile/features/search/domain/search_result_model.dart';

/// Search index offline sync hooks for SyncWorker delta batches (§7).
class SearchSyncHooks {
  SearchSyncHooks._();

  static const String contentType = 'search_index';

  static Future<List<IsarSyncMetadata>> collectForSync({
    required SearchRepository repository,
    required KuttiompMode mode,
    String? stage,
  }) async {
    final results = await repository.search(
      query: '',
      mode: mode,
      canonicalStage: stage,
    );
    return results.map(_fromResult).toList();
  }

  static IsarSyncMetadata _fromResult(SearchResultModel result) {
    return IsarSyncMetadata(
      recordId: result.id,
      contentType: '${contentType}:${result.contentType.id}',
      syncStatus: SyncStatus.pending,
      lastSyncedAt: DateTime.now().toUtc(),
      localChecksum: result.schemaVersion,
      requiresSacredConsent: result.requiresSacredGate,
      clanScope: result.clanScope,
      sacredFlag: result.sacredFlag || result.ceremonialFlag,
      speakerId: result.speakerId,
      primaryAudioId: result.primaryAudioId,
    );
  }
}