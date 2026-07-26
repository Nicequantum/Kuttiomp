import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/di/isar_database.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/offline/offline_quota_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/supabase/isar_schemas.dart';
import 'package:kuttiomp_mobile/features/phrases/data/phrases_repository.dart';
import 'package:kuttiomp_mobile/features/phrases/domain/phrase.dart';

/// Offline phrase mirror with embedded ProtocolMetadata (§7, Protocols 4, 5, 9).
///
/// This serves our people by keeping elder-approved phrases available offline
/// with sacred/clan consent for 25 years of household learning.
class IsarPhraseCollection {
  IsarPhraseCollection({
    Isar? isar,
    OfflineQuotaGuard? quotaGuard,
    ProtocolGateway? gateway,
  })  : _isar = isar ?? IsarDatabase.instance,
        _quotaGuard = quotaGuard ?? OfflineQuotaGuard(),
        _gateway = gateway ?? ProtocolGateway();

  final Isar? _isar;
  final OfflineQuotaGuard _quotaGuard;
  final ProtocolGateway _gateway;

  static const String syncLogMessage =
      'Phrase mirror sync | Quota + sacred/clan consent enforced | Protocols 4,5,7,9';

  static String encryptSacredPayload({
    required String payload,
    required String clanId,
    required String role,
  }) {
    final key = IsarDatabase.deriveEncryptionKey(clanId: clanId, role: role);
    final digest = sha256.convert(utf8.encode('$key:$payload'));
    return base64Encode(utf8.encode(digest.toString()));
  }

  Future<PhraseMirrorSyncResult> syncFromRepository({
    required PhrasesRepository repository,
    required KuttiompMode mode,
    String? canonicalStage,
    bool clanReauthenticated = true,
    Future<bool> Function({
      required String recordId,
      required bool sacredFlag,
    })? onSacredConsentRequired,
  }) async {
    _gateway.assertCompliant('9', context: const {'direct_table_access': false});

    final phrases = await repository.watchPhrasesForTier(
      mode.tierBitmask,
      stage: canonicalStage,
    );

    _quotaGuard.enforceBatch(
      modeId: mode.id,
      existingCount: InMemoryPhraseMirrorStore.instance.count,
      incomingCount: phrases.length,
    );

    var mirrored = 0;
    var blockedSacred = 0;
    var blockedClan = 0;

    for (final phrase in phrases) {
      if (!_gateway.isClanPermitted(phrase.clanScope)) {
        blockedClan++;
        continue;
      }

      if (phrase.sacredFlag) {
        final consent = await onSacredConsentRequired?.call(
              recordId: phrase.id,
              sacredFlag: phrase.sacredFlag,
            ) ??
            false;
        if (!consent) {
          blockedSacred++;
          await AuditLogStore.instance.log(
            AuditLogEntry(
              timestamp: DateTime.now().toUtc(),
              protocolId: '4',
              operation: 'phrase:sacred_blocked',
              outcome: 'consent_denied',
              payloadSummary: phrase.id,
            ),
          );
          continue;
        }
        if (!clanReauthenticated) {
          blockedClan++;
          continue;
        }
      }

      final record = PhraseMirrorRecord.fromPhrase(
        phrase,
        encryptedPayload: phrase.sacredFlag
            ? encryptSacredPayload(
                payload: phrase.phrase,
                clanId: _gateway.protocolService.clanId ?? 'kuttiomp_clan',
                role: _gateway.protocolService.role ?? 'learner',
              )
            : null,
      );
      await _upsert(record);
      mirrored++;
    }

    await AuditLogStore.instance.log(
      AuditLogEntry(
        timestamp: DateTime.now().toUtc(),
        protocolId: '9',
        operation: 'phrase:mirror_sync',
        outcome: syncLogMessage,
        payloadSummary: 'mirrored=$mirrored sacred_blocked=$blockedSacred',
      ),
    );

    if (kDebugMode) debugPrint('$syncLogMessage → $mirrored records');

    return PhraseMirrorSyncResult(
      mirroredCount: mirrored,
      blockedSacredCount: blockedSacred,
      blockedClanCount: blockedClan,
      logMessage: syncLogMessage,
    );
  }

  Future<List<PhraseModel>> readOfflineForTier(int tierBitmask) async {
    final records = await _listAll();
    return records
        .map((r) => r.toPhrase())
        .where((p) => (p.visibleToTiers & tierBitmask) != 0)
        .where((p) => p.elderApproved)
        .toList();
  }

  Future<void> _upsert(PhraseMirrorRecord record) async {
    InMemoryPhraseMirrorStore.instance.upsert(record);
    if (_isar == null || !_isar!.isOpen) return;
    await _isar!.writeAsync((isar) {
      final col = isar.protocolMetadatas;
      final meta = record.toProtocolMetadata();
      if (meta.id == 0) {
        meta.id = col.autoIncrement();
      }
      col.put(meta);
    });
  }

  Future<List<PhraseMirrorRecord>> _listAll() async {
    if (_isar == null || !_isar!.isOpen) {
      return InMemoryPhraseMirrorStore.instance.all();
    }
    final rows = await _isar!.protocolMetadatas.where().findAllAsync();
    return rows
        .where((r) => r.recordId.startsWith('phrase:'))
        .map(PhraseMirrorRecord.fromProtocolMetadata)
        .whereType<PhraseMirrorRecord>()
        .toList();
  }
}

@immutable
class PhraseMirrorRecord {
  const PhraseMirrorRecord({
    required this.id,
    required this.payloadJson,
    required this.speakerId,
    required this.primaryAudioId,
    required this.sacredFlag,
    required this.elderApproved,
    required this.clanScope,
    required this.visibleToTiers,
    required this.authoritySource,
    required this.schemaVersion,
    this.encryptedSacredPayload,
  });

  final String id;
  final String payloadJson;
  final String speakerId;
  final String primaryAudioId;
  final bool sacredFlag;
  final bool elderApproved;
  final List<String> clanScope;
  final int visibleToTiers;
  final String authoritySource;
  final String schemaVersion;
  final String? encryptedSacredPayload;

  factory PhraseMirrorRecord.fromPhrase(
    PhraseModel phrase, {
    String? encryptedPayload,
  }) {
    return PhraseMirrorRecord(
      id: phrase.id,
      payloadJson: jsonEncode({
        'id': phrase.id,
        'phrase': phrase.phrase,
        'translation': phrase.translation,
        'speaker_metadata': phrase.speakerMetadata,
        'primary_audio_id': phrase.primaryAudioId,
        'category': phrase.category,
        'land_context': phrase.landContext,
        'family_context': phrase.familyContext,
        'seasonal_window': phrase.seasonalWindow,
        'canonical_stage': phrase.canonicalStage,
        'related_lexeme_ids': phrase.relatedLexemeIds,
        'conversation_prompt': phrase.conversationPrompt,
      }),
      speakerId: phrase.speakerId,
      primaryAudioId: phrase.primaryAudioId,
      sacredFlag: phrase.sacredFlag,
      elderApproved: phrase.elderApproved,
      clanScope: phrase.clanScope,
      visibleToTiers: phrase.visibleToTiers,
      authoritySource: phrase.authoritySource,
      schemaVersion: phrase.schemaVersion,
      encryptedSacredPayload: encryptedPayload,
    );
  }

  PhraseModel toPhrase() {
    final map = Map<String, dynamic>.from(jsonDecode(payloadJson) as Map);
    map['sacred_flag'] = sacredFlag;
    map['clan_scope'] = clanScope;
    map['visible_to_tiers'] = visibleToTiers;
    map['elder_approved'] = elderApproved;
    map['authority_source'] = authoritySource;
    map['schema_version'] = schemaVersion;
    return PhraseModel.fromJson(map);
  }

  ProtocolMetadata toProtocolMetadata() {
    final meta = ProtocolMetadata()
      ..recordId = 'phrase:$id'
      ..protocolId = 'phrase_mirror'
      ..sacredFlag = sacredFlag
      ..clanScope = List<String>.from(clanScope)
      ..visibleToTiers = visibleToTiers
      ..speakerId = speakerId
      ..elderApproved = elderApproved
      ..authoritySource = authoritySource
      ..primaryAudioId = primaryAudioId
      ..requiresLandContext = false
      ..schemaVersion = schemaVersion
      ..lastSyncedAt = DateTime.now().toUtc();
    return meta;
  }

  static PhraseMirrorRecord? fromProtocolMetadata(ProtocolMetadata meta) {
    if (!meta.recordId.startsWith('phrase:')) return null;
    final id = meta.recordId.replaceFirst('phrase:', '');
    return PhraseMirrorRecord(
      id: id,
      payloadJson: jsonEncode({'id': id}),
      speakerId: meta.speakerId,
      primaryAudioId: meta.primaryAudioId ?? 'audio-primary',
      sacredFlag: meta.sacredFlag,
      elderApproved: meta.elderApproved,
      clanScope: List<String>.from(meta.clanScope),
      visibleToTiers: meta.visibleToTiers,
      authoritySource: meta.authoritySource,
      schemaVersion: meta.schemaVersion,
    );
  }
}

class PhraseMirrorSyncResult {
  const PhraseMirrorSyncResult({
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

class InMemoryPhraseMirrorStore {
  InMemoryPhraseMirrorStore._();
  static final InMemoryPhraseMirrorStore instance = InMemoryPhraseMirrorStore._();

  final Map<String, PhraseMirrorRecord> _records = {};

  int get count => _records.length;

  List<PhraseMirrorRecord> all() => _records.values.toList();

  void upsert(PhraseMirrorRecord record) => _records[record.id] = record;

  void clear() => _records.clear();
}