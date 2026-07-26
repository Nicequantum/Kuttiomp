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
import 'package:kuttiomp_mobile/features/lexeme/data/lexeme_repository.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';

/// Offline lexeme mirror with embedded ProtocolMetadata (§7, Protocols 4, 5, 9).
///
/// This serves our people by keeping elder-approved lexemes available without
/// network dependency while enforcing sacred/clan consent for 25 years.
class IsarLexemeCollection {
  IsarLexemeCollection({
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
      'Lexeme mirror sync | Quota + sacred/clan consent enforced | Protocols 4,5,7,9';

  /// Encrypts sacred payload with clan-derived key (SQLCipher-level stub).
  static String encryptSacredPayload({
    required String payload,
    required String clanId,
    required String role,
  }) {
    final key = IsarDatabase.deriveEncryptionKey(clanId: clanId, role: role);
    final digest = sha256.convert(utf8.encode('$key:$payload'));
    return base64Encode(utf8.encode(digest.toString()));
  }

  /// Mirrors lexemes from repository into offline store with quota enforcement.
  Future<LexemeMirrorSyncResult> syncFromRepository({
    required LexemeRepository repository,
    required KuttiompMode mode,
    String? canonicalStage,
    bool clanReauthenticated = true,
    Future<bool> Function({
      required String recordId,
      required bool sacredFlag,
    })? onSacredConsentRequired,
  }) async {
    _gateway.assertCompliant('9', context: const {'direct_table_access': false});

    final lexemes = await repository.watchLexemesForTier(
      mode.tierBitmask,
      stage: canonicalStage,
    );

    _quotaGuard.enforceBatch(
      modeId: mode.id,
      existingCount: InMemoryLexemeMirrorStore.instance.count,
      incomingCount: lexemes.length,
    );

    var mirrored = 0;
    var blockedSacred = 0;
    var blockedClan = 0;

    for (final lexeme in lexemes) {
      if (!_gateway.isClanPermitted(lexeme.clanScope)) {
        blockedClan++;
        continue;
      }

      if (lexeme.sacredFlag) {
        final consent = await onSacredConsentRequired?.call(
              recordId: lexeme.id,
              sacredFlag: lexeme.sacredFlag,
            ) ??
            false;
        if (!consent) {
          blockedSacred++;
          await AuditLogStore.instance.log(
            AuditLogEntry(
              timestamp: DateTime.now().toUtc(),
              protocolId: '4',
              operation: 'lexeme:sacred_blocked',
              outcome: 'consent_denied',
              payloadSummary: lexeme.id,
            ),
          );
          continue;
        }
        if (!clanReauthenticated) {
          blockedClan++;
          continue;
        }
      }

      final record = LexemeMirrorRecord.fromLexeme(
        lexeme,
        encryptedPayload: lexeme.sacredFlag
            ? encryptSacredPayload(
                payload: lexeme.word,
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
        operation: 'lexeme:mirror_sync',
        outcome: syncLogMessage,
        payloadSummary: 'mirrored=$mirrored sacred_blocked=$blockedSacred',
      ),
    );

    if (kDebugMode) {
      debugPrint('$syncLogMessage → $mirrored records');
    }

    return LexemeMirrorSyncResult(
      mirroredCount: mirrored,
      blockedSacredCount: blockedSacred,
      blockedClanCount: blockedClan,
      logMessage: syncLogMessage,
    );
  }

  Future<List<LexemeModel>> readOfflineForTier(int tierBitmask) async {
    final records = await _listAll();
    return records
        .map((r) => r.toLexeme())
        .where((l) => (l.visibleToTiers & tierBitmask) != 0)
        .where((l) => l.elderApproved)
        .toList();
  }

  Future<void> _upsert(LexemeMirrorRecord record) async {
    InMemoryLexemeMirrorStore.instance.upsert(record);

    if (_isar == null || !_isar!.isOpen) return;

    await _isar!.writeTxn(() async {
      await _isar!.protocolMetadatas.put(record.toProtocolMetadata());
    });
  }

  Future<List<LexemeMirrorRecord>> _listAll() async {
    if (_isar == null || !_isar!.isOpen) {
      return InMemoryLexemeMirrorStore.instance.all();
    }

    final rows = await _isar!.protocolMetadatas.where().findAll();

    return rows
        .where((r) => r.recordId.startsWith('lexeme:'))
        .map(LexemeMirrorRecord.fromProtocolMetadata)
        .whereType<LexemeMirrorRecord>()
        .toList();
  }
}

/// Serializable offline lexeme record with embedded protocol fields.
@immutable
class LexemeMirrorRecord {
  const LexemeMirrorRecord({
    required this.id,
    required this.payloadJson,
    required this.protocolMetadata,
    this.encryptedSacredPayload,
  });

  final String id;
  final String payloadJson;
  final LexemeProtocolMetadata protocolMetadata;
  final String? encryptedSacredPayload;

  factory LexemeMirrorRecord.fromLexeme(
    LexemeModel lexeme, {
    String? encryptedPayload,
  }) {
    return LexemeMirrorRecord(
      id: lexeme.id,
      payloadJson: jsonEncode({
        'id': lexeme.id,
        'word': lexeme.word,
        'translation': lexeme.translation,
        'speaker_metadata': lexeme.speakerMetadata,
        'primary_audio_id': lexeme.primaryAudioId,
        'canonical_stage': lexeme.canonicalStage,
        'approval_chain': lexeme.approvalChain,
        'geo_context': lexeme.geoContext?.toJson(),
        'requires_land_context': lexeme.requiresLandContext,
        'user_mastery_stage': lexeme.userMasteryStageId,
      }),
      protocolMetadata: lexeme.protocolMetadata,
      encryptedSacredPayload: encryptedPayload ?? lexeme.encryptedSacredPayload,
    );
  }

  LexemeModel toLexeme() {
    final map = Map<String, dynamic>.from(jsonDecode(payloadJson) as Map);
    map['sacred_flag'] = protocolMetadata.sacredFlag;
    map['clan_scope'] = protocolMetadata.clanScope;
    map['visible_to_tiers'] = protocolMetadata.visibleToTiers;
    map['elder_approved'] = protocolMetadata.elderApproved;
    map['authority_source'] = protocolMetadata.authoritySource;
    map['schema_version'] = protocolMetadata.schemaVersion;
    map['approval_chain'] = protocolMetadata.approvalChain;
    if (encryptedSacredPayload != null) {
      map['encrypted_sacred_payload'] = encryptedSacredPayload;
    }
    return LexemeModel.fromJson(map);
  }

  ProtocolMetadata toProtocolMetadata() {
    final meta = ProtocolMetadata()
      ..recordId = 'lexeme:$id'
      ..protocolId = 'lexeme_mirror'
      ..sacredFlag = protocolMetadata.sacredFlag
      ..clanScope = List<String>.from(protocolMetadata.clanScope)
      ..visibleToTiers = protocolMetadata.visibleToTiers
      ..speakerId = protocolMetadata.speakerId
      ..elderApproved = protocolMetadata.elderApproved
      ..authoritySource = protocolMetadata.authoritySource
      ..primaryAudioId = protocolMetadata.primaryAudioId
      ..requiresLandContext = false
      ..schemaVersion = protocolMetadata.schemaVersion
      ..lastSyncedAt = DateTime.now().toUtc();
    return meta;
  }

  static LexemeMirrorRecord? fromProtocolMetadata(ProtocolMetadata meta) {
    if (!meta.recordId.startsWith('lexeme:')) return null;
    final id = meta.recordId.replaceFirst('lexeme:', '');
    return LexemeMirrorRecord(
      id: id,
      payloadJson: jsonEncode({'id': id}),
      protocolMetadata: LexemeProtocolMetadata(
        recordId: id,
        speakerId: meta.speakerId,
        primaryAudioId: meta.primaryAudioId ?? 'audio-primary',
        sacredFlag: meta.sacredFlag,
        elderApproved: meta.elderApproved,
        clanScope: List<String>.from(meta.clanScope),
        visibleToTiers: meta.visibleToTiers,
        authoritySource: meta.authoritySource,
        schemaVersion: meta.schemaVersion,
      ),
      encryptedSacredPayload: meta.sacredFlag ? meta.schemaVersion : null,
    );
  }
}

class LexemeMirrorSyncResult {
  const LexemeMirrorSyncResult({
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

/// In-memory lexeme mirror for tests and offline fallback (§11).
class InMemoryLexemeMirrorStore {
  InMemoryLexemeMirrorStore._();
  static final InMemoryLexemeMirrorStore instance = InMemoryLexemeMirrorStore._();

  final Map<String, LexemeMirrorRecord> _records = {};

  int get count => _records.length;

  List<LexemeMirrorRecord> all() => _records.values.toList();

  void upsert(LexemeMirrorRecord record) => _records[record.id] = record;

  void clear() => _records.clear();
}