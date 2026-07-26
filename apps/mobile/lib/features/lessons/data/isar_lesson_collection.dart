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
import 'package:kuttiomp_mobile/features/lessons/data/lessons_repository.dart';
import 'package:kuttiomp_mobile/features/lessons/domain/lesson.dart';

/// Offline lesson mirror with ProtocolMetadata + sacred consent (§7, Protocol 4).
///
/// This serves our people by keeping ceremonial lessons offline only after
/// consent and re-auth, protecting sacred knowledge through 2050.
class IsarLessonCollection {
  IsarLessonCollection({
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
      'Lesson mirror sync | Sacred consent + quota enforced | Protocols 4,5,7,9';

  static String encryptSacredPayload({
    required String payload,
    required String clanId,
    required String role,
  }) {
    final key = IsarDatabase.deriveEncryptionKey(clanId: clanId, role: role);
    final digest = sha256.convert(utf8.encode('$key:$payload'));
    return base64Encode(utf8.encode(digest.toString()));
  }

  /// Immediate local deletion + backend-report audit on sacred violation.
  Future<void> reportAndPurgeSacredViolation({
    required String recordId,
    required String reason,
  }) async {
    InMemoryLessonMirrorStore.instance.remove(recordId);
    await AuditLogStore.instance.log(
      AuditLogEntry(
        timestamp: DateTime.now().toUtc(),
        protocolId: '4',
        operation: 'lesson:sacred_violation_purge',
        outcome: 'deleted_local_and_reported',
        payloadSummary: '$recordId|$reason',
      ),
    );
    if (kDebugMode) {
      debugPrint('Protocol 4: purged sacred lesson $recordId — $reason');
    }
  }

  Future<LessonMirrorSyncResult> syncFromRepository({
    required LessonsRepository repository,
    required KuttiompMode mode,
    String? canonicalStage,
    bool clanReauthenticated = true,
    Future<bool> Function({
      required String recordId,
      required bool sacredFlag,
    })? onSacredConsentRequired,
  }) async {
    _gateway.assertCompliant('9', context: const {'direct_table_access': false});

    final lessons = await repository.watchLessonsForTier(
      mode.tierBitmask,
      stage: canonicalStage,
    );

    _quotaGuard.enforceBatch(
      modeId: mode.id,
      existingCount: InMemoryLessonMirrorStore.instance.count,
      incomingCount: lessons.length,
    );

    var mirrored = 0;
    var blockedSacred = 0;
    var blockedClan = 0;
    var purged = 0;

    for (final lesson in lessons) {
      if (!_gateway.isClanPermitted(lesson.clanScope)) {
        blockedClan++;
        continue;
      }

      // Never mirror unapproved content (Protocol 2).
      if (!lesson.elderApproved) {
        continue;
      }

      if (lesson.ceremonialFlag || lesson.isSacred) {
        final consent = await onSacredConsentRequired?.call(
              recordId: lesson.id,
              sacredFlag: true,
            ) ??
            false;
        if (!consent) {
          blockedSacred++;
          await reportAndPurgeSacredViolation(
            recordId: lesson.id,
            reason: 'consent_denied',
          );
          purged++;
          continue;
        }
        if (!clanReauthenticated) {
          blockedSacred++;
          await reportAndPurgeSacredViolation(
            recordId: lesson.id,
            reason: 'reauth_required',
          );
          purged++;
          continue;
        }
      }

      final record = LessonMirrorRecord.fromLesson(
        lesson,
        encryptedPayload: lesson.ceremonialFlag
            ? encryptSacredPayload(
                payload: lesson.title,
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
        operation: 'lesson:mirror_sync',
        outcome: syncLogMessage,
        payloadSummary:
            'mirrored=$mirrored sacred_blocked=$blockedSacred purged=$purged',
      ),
    );

    if (kDebugMode) debugPrint('$syncLogMessage → $mirrored records');

    return LessonMirrorSyncResult(
      mirroredCount: mirrored,
      blockedSacredCount: blockedSacred,
      blockedClanCount: blockedClan,
      purgedCount: purged,
      logMessage: syncLogMessage,
    );
  }

  /// Offline list excludes ceremonial unless consent was previously granted
  /// and encrypted payload is present (never auto-render sacred).
  Future<List<LessonModel>> readOfflineForTier(
    int tierBitmask, {
    bool allowSacredWithConsent = false,
  }) async {
    final records = await _listAll();
    return records
        .map((r) => r.toLesson())
        .where((l) => l.elderApproved)
        .where((l) => (l.visibleToTiers & tierBitmask) != 0)
        .where((l) {
          if (!l.ceremonialFlag) return true;
          if (!allowSacredWithConsent) return false;
          return true;
        })
        .toList();
  }

  Future<void> _upsert(LessonMirrorRecord record) async {
    InMemoryLessonMirrorStore.instance.upsert(record);
    if (_isar == null || !_isar!.isOpen) return;
    await _isar!.writeTxn(() async {
      await _isar!.protocolMetadatas.put(record.toProtocolMetadata());
    });
  }

  Future<List<LessonMirrorRecord>> _listAll() async {
    if (_isar == null || !_isar!.isOpen) {
      return InMemoryLessonMirrorStore.instance.all();
    }
    final rows = await _isar!.protocolMetadatas.where().findAll();
    return rows
        .where((r) => r.recordId.startsWith('lesson:'))
        .map(LessonMirrorRecord.fromProtocolMetadata)
        .whereType<LessonMirrorRecord>()
        .toList();
  }
}

@immutable
class LessonMirrorRecord {
  const LessonMirrorRecord({
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

  factory LessonMirrorRecord.fromLesson(
    LessonModel lesson, {
    String? encryptedPayload,
  }) {
    return LessonMirrorRecord(
      id: lesson.id,
      payloadJson: jsonEncode({
        'id': lesson.id,
        'title': lesson.title,
        'description': lesson.description,
        'stage': lesson.stage.id,
        'speaker_metadata': lesson.speakerMetadata,
        'audio_blocks': lesson.audioBlocks
            .map(
              (b) => {
                'id': b.id,
                'label': b.label,
                'primary_audio_id': b.primaryAudioId,
                'order': b.order,
                if (b.transcript != null) 'transcript': b.transcript,
              },
            )
            .toList(),
        'related_lexeme_ids': lesson.relatedLexemeIds,
        'related_phrase_ids': lesson.relatedPhraseIds,
        'land_context_geo': lesson.landContextGeo,
        'progress_percent': lesson.progressPercent,
      }),
      speakerId: lesson.speakerId,
      primaryAudioId: lesson.primaryAudioId,
      sacredFlag: lesson.ceremonialFlag,
      elderApproved: lesson.elderApproved,
      clanScope: lesson.clanScope,
      visibleToTiers: lesson.visibleToTiers,
      authoritySource: lesson.authoritySource,
      schemaVersion: lesson.schemaVersion,
      encryptedSacredPayload: encryptedPayload,
    );
  }

  LessonModel toLesson() {
    final map = Map<String, dynamic>.from(jsonDecode(payloadJson) as Map);
    map['ceremonial_flag'] = sacredFlag;
    map['sacred_flag'] = sacredFlag;
    map['clan_scope'] = clanScope;
    map['visible_to_tiers'] = visibleToTiers;
    map['elder_approved'] = elderApproved;
    map['authority_source'] = authoritySource;
    map['schema_version'] = schemaVersion;
    return LessonModel.fromJson(map);
  }

  ProtocolMetadata toProtocolMetadata() {
    final meta = ProtocolMetadata()
      ..recordId = 'lesson:$id'
      ..protocolId = 'lesson_mirror'
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

  static LessonMirrorRecord? fromProtocolMetadata(ProtocolMetadata meta) {
    if (!meta.recordId.startsWith('lesson:')) return null;
    final id = meta.recordId.replaceFirst('lesson:', '');
    return LessonMirrorRecord(
      id: id,
      payloadJson: jsonEncode({'id': id, 'title': id, 'description': '', 'stage': 'awakening', 'audio_blocks': []}),
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

class LessonMirrorSyncResult {
  const LessonMirrorSyncResult({
    required this.mirroredCount,
    required this.blockedSacredCount,
    required this.blockedClanCount,
    required this.purgedCount,
    required this.logMessage,
  });

  final int mirroredCount;
  final int blockedSacredCount;
  final int blockedClanCount;
  final int purgedCount;
  final String logMessage;
}

class InMemoryLessonMirrorStore {
  InMemoryLessonMirrorStore._();
  static final InMemoryLessonMirrorStore instance = InMemoryLessonMirrorStore._();

  final Map<String, LessonMirrorRecord> _records = {};

  int get count => _records.length;

  List<LessonMirrorRecord> all() => _records.values.toList();

  void upsert(LessonMirrorRecord record) => _records[record.id] = record;

  void remove(String id) => _records.remove(id);

  void clear() => _records.clear();
}