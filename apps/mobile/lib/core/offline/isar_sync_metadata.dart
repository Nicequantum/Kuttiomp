import 'package:isar/isar.dart';
import 'package:kuttiomp_mobile/core/supabase/isar_schemas.dart';

/// Sync lifecycle for mirrored offline records (§7 extension of ProtocolMetadata).
enum SyncStatus {
  pending('pending'),
  synced('synced'),
  conflict('conflict'),
  blocked('blocked');

  const SyncStatus(this.id);

  final String id;

  static SyncStatus fromId(String? raw) {
    return SyncStatus.values.firstWhere(
      (s) => s.id == raw,
      orElse: () => SyncStatus.pending,
    );
  }
}

/// Delta-sync metadata carried alongside every mirrored content record.
class IsarSyncMetadata {
  IsarSyncMetadata({
    required this.recordId,
    required this.contentType,
    required this.syncStatus,
    required this.lastSyncedAt,
    this.remoteUpdatedAt,
    this.localChecksum = '',
    this.requiresSacredConsent = false,
    this.clanScope = const ['kuttiomp_clan'],
    this.sacredFlag = false,
    this.speakerId = 'unknown-speaker',
    this.primaryAudioId,
  });

  final String recordId;
  final String contentType;
  final SyncStatus syncStatus;
  final DateTime lastSyncedAt;
  final DateTime? remoteUpdatedAt;
  final String localChecksum;
  final bool requiresSacredConsent;
  final List<String> clanScope;
  final bool sacredFlag;
  final String speakerId;
  final String? primaryAudioId;

  String get compositeKey => '$contentType:$recordId';

  IsarSyncMetadata copyWith({
    SyncStatus? syncStatus,
    DateTime? lastSyncedAt,
    DateTime? remoteUpdatedAt,
    String? localChecksum,
    bool? requiresSacredConsent,
  }) {
    return IsarSyncMetadata(
      recordId: recordId,
      contentType: contentType,
      syncStatus: syncStatus ?? this.syncStatus,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
      localChecksum: localChecksum ?? this.localChecksum,
      requiresSacredConsent: requiresSacredConsent ?? this.requiresSacredConsent,
      clanScope: clanScope,
      sacredFlag: sacredFlag,
      speakerId: speakerId,
      primaryAudioId: primaryAudioId,
    );
  }

  /// Maps governed content into ProtocolMetadata for Isar persistence.
  ProtocolMetadata toProtocolMetadata() {
    final meta = ProtocolMetadata()
      ..recordId = compositeKey
      ..protocolId = syncStatus.id
      ..sacredFlag = sacredFlag
      ..clanScope = List<String>.from(clanScope)
      ..visibleToTiers = 0
      ..speakerId = speakerId
      ..elderApproved = true
      ..authoritySource = 'elder'
      ..primaryAudioId = primaryAudioId
      ..requiresLandContext = false
      ..schemaVersion = localChecksum.isEmpty ? '2.0' : localChecksum
      ..lastSyncedAt = lastSyncedAt;
    return meta;
  }

  factory IsarSyncMetadata.fromProtocolMetadata(ProtocolMetadata meta) {
    final parts = meta.recordId.split(':');
    final contentType = parts.length > 1 ? parts.first : 'unknown';
    final recordId = parts.length > 1 ? parts.sublist(1).join(':') : meta.recordId;

    return IsarSyncMetadata(
      recordId: recordId,
      contentType: contentType,
      syncStatus: SyncStatus.fromId(meta.protocolId),
      lastSyncedAt: meta.lastSyncedAt,
      localChecksum: meta.schemaVersion,
      requiresSacredConsent: meta.sacredFlag,
      clanScope: List<String>.from(meta.clanScope),
      sacredFlag: meta.sacredFlag,
      speakerId: meta.speakerId,
      primaryAudioId: meta.primaryAudioId,
    );
  }

  factory IsarSyncMetadata.fromContentMap({
    required String contentType,
    required Map<String, dynamic> json,
    SyncStatus status = SyncStatus.pending,
  }) {
    final id = json['id'] as String? ?? json['content_id'] as String? ?? 'unknown';
    final sacred = json['sacred_flag'] as bool? ??
        json['ceremonial_flag'] as bool? ??
        false;
    final clanRaw = json['clan_scope'];
    final clanScope = <String>[];
    if (clanRaw is List) {
      for (final item in clanRaw) {
        clanScope.add(item.toString());
      }
    }

    final speakerRaw = json['speaker_metadata'] ?? json['attribution_json'];
    final speakerId = speakerRaw is Map
        ? speakerRaw['speaker_id']?.toString() ?? 'unknown-speaker'
        : json['speaker_id']?.toString() ?? 'unknown-speaker';

    return IsarSyncMetadata(
      recordId: id,
      contentType: contentType,
      syncStatus: status,
      lastSyncedAt: DateTime.now().toUtc(),
      localChecksum: json['schema_version']?.toString() ?? '2.0',
      requiresSacredConsent: sacred,
      clanScope: clanScope.isEmpty ? ['kuttiomp_clan'] : clanScope,
      sacredFlag: sacred,
      speakerId: speakerId,
      primaryAudioId: json['primary_audio_id'] as String?,
    );
  }
}

/// In-memory mirror used when Isar native libs are unavailable (§11 tests).
class InMemorySyncMetadataStore {
  InMemorySyncMetadataStore._();
  static final InMemorySyncMetadataStore instance = InMemorySyncMetadataStore._();

  final Map<String, IsarSyncMetadata> _records = {};

  List<IsarSyncMetadata> all() => _records.values.toList();

  IsarSyncMetadata? get(String compositeKey) => _records[compositeKey];

  void upsert(IsarSyncMetadata metadata) {
    _records[metadata.compositeKey] = metadata;
  }

  void clear() => _records.clear();
}

/// Persists sync metadata through ProtocolMetadata collection or in-memory fallback.
class IsarSyncMetadataRepository {
  IsarSyncMetadataRepository({Isar? isar}) : _isar = isar;

  final Isar? _isar;

  Future<void> upsertAll(Iterable<IsarSyncMetadata> batch) async {
    if (_isar == null || !_isar!.isOpen) {
      for (final item in batch) {
        InMemorySyncMetadataStore.instance.upsert(item);
      }
      return;
    }

    await _isar!.writeTxn(() async {
      for (final item in batch) {
        await _isar!.protocolMetadatas.put(item.toProtocolMetadata());
      }
    });
  }

  Future<List<IsarSyncMetadata>> listAll() async {
    if (_isar == null || !_isar!.isOpen) {
      return InMemorySyncMetadataStore.instance.all();
    }

    final rows = await _isar!.protocolMetadatas.where().findAll();
    return rows.map(IsarSyncMetadata.fromProtocolMetadata).toList();
  }
}