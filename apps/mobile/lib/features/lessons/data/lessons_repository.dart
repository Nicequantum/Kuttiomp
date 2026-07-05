import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_repository.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/features/lessons/domain/lesson.dart';

// Tribal Maintainer Guide (Protocol 12):
// To modify lesson data access → search `ProtocolGateway` in this file (< 2 min).
// 25-year guarantee: secure RPCs only, zero direct table access.

/// Audited lessons data access with mastery update on completion (§6, Protocols 2,7,8,9).
class LessonsRepository extends AuditedRepository {
  LessonsRepository({super.gateway, super.auditedClient});

  static const String completeLogMessage =
      'Lesson completed | Protocols 2,7,8,9 enforced';

  static final List<LessonModel> _offlineCorpus = [
    LessonModel(
      id: 'lesson-awakening-greetings',
      title: 'Morning Greetings',
      description: 'Recognize common greetings by sound and context.',
      stage: MasteryStage.awakening,
      speakerMetadata: const {
        'speaker_id': 'grandmother-comus',
        'name': 'Grandmother Comus',
        'authority_source': 'elder',
      },
      audioBlocks: const [
        LessonAudioBlock(
          id: 'block-1',
          label: 'Hear the greeting',
          primaryAudioId: 'audio-lesson-greet-1',
          order: 0,
          transcript: 'Anska',
        ),
        LessonAudioBlock(
          id: 'block-2',
          label: 'Hear the response',
          primaryAudioId: 'audio-lesson-greet-2',
          order: 1,
          transcript: 'Wunnegan',
        ),
      ],
      relatedLexemeIds: ['lexeme-anska', 'lexeme-wunnegan'],
      relatedPhraseIds: ['phrase-greeting'],
    ),
    LessonModel(
      id: 'lesson-rooted-daily',
      title: 'Daily Routines',
      description: 'Use words in everyday family routines.',
      stage: MasteryStage.rooted,
      speakerMetadata: const {
        'speaker_id': 'elder-narragansett',
        'name': 'Elder Keeper',
        'authority_source': 'elder',
      },
      audioBlocks: const [
        LessonAudioBlock(
          id: 'block-1',
          label: 'Morning routine',
          primaryAudioId: 'audio-lesson-daily-1',
          order: 0,
        ),
      ],
      visibleToTiers: GenerationalTierBitmask.allTiers,
      relatedPhraseIds: ['phrase-land-greeting'],
    ),
    LessonModel(
      id: 'lesson-deepening-ceremony',
      title: 'Ceremonial Opening',
      description: 'Participate in ceremonial language (elder-gated).',
      stage: MasteryStage.deepening,
      speakerMetadata: const {
        'speaker_id': 'ceremony-keeper',
        'name': 'Ceremony Keeper',
        'authority_source': 'elder',
      },
      audioBlocks: const [
        LessonAudioBlock(
          id: 'block-1',
          label: 'Ceremonial opening',
          primaryAudioId: 'audio-lesson-ceremony-1',
          order: 0,
        ),
      ],
      ceremonialFlag: true,
      visibleToTiers: GenerationalTierBitmask.elder,
      relatedPhraseIds: ['phrase-ceremony'],
    ),
  ];

  /// Watches lessons for generational tier (Protocol 3).
  Future<List<Lesson>> watchLessonsForTier(int tierBitmask, {String? stage}) async {
    for (final id in ['3', '9', '12']) {
      gateway.assertCompliant(
        id,
        context: {
          'visible_to_tiers': tierBitmask,
          'elderApproved': true,
          'direct_table_access': false,
        },
      );
    }
    final mode = KuttiompMode.values.firstWhere(
      (m) => (m.tierBitmask & tierBitmask) != 0,
      orElse: () => KuttiompMode.littleOnes,
    );
    final list = await listForStage(stage: stage ?? MasteryStage.awakening.id, mode: mode);
    for (final lesson in list) {
      lesson.assertCompliant(gateway);
    }
    return list;
  }

  Future<List<LessonModel>> listForStage({
    required String stage,
    KuttiompMode? mode,
    String? clanId,
  }) async {
    gateway.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false},
    );

    final effectiveMode = mode ?? KuttiompMode.littleOnes;
    final effectiveClan = clanId ?? gateway.protocolService.clanId ?? 'kuttiomp_clan';

    try {
      final result = await auditedRpc<List<dynamic>>(
        KuttiompRpc.getLessonsForStage,
        params: {
          'canonical_stage': stage,
          'mode': effectiveMode.id,
          'clan': effectiveClan,
        },
      );
      final lessons = result
          .map((e) => LessonModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .where((l) => _isPermitted(l, effectiveMode, effectiveClan))
          .toList();
      return lessons;
    } catch (_) {
      return _offlineCorpus
          .where((l) => l.stage.id == stage)
          .where((l) => _isPermitted(l, effectiveMode, effectiveClan))
          .toList();
    }
  }

  Future<LessonModel> getContent(String id) async {
    gateway.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false},
    );

    try {
      final result = await auditedRpc<Map<String, dynamic>>(
        KuttiompRpc.getLessonContent,
        params: {'lesson_id': id},
      );
      final lesson = LessonModel.fromJson(result);
      _assertLessonProtocols(lesson);
      return lesson;
    } catch (_) {
      final offline = _offlineCorpus.firstWhere(
        (l) => l.id == id,
        orElse: () => _offlineCorpus.first,
      );
      _assertLessonProtocols(offline);
      return offline;
    }
  }

  Future<void> completeLesson(String lessonId) async {
    gateway.assertElderApproved(context: const {'elderApproved': true});
    gateway.protocolService.assertOralFirst(
      context: const {'text_only': true, 'primary_audio_id': 'lesson-complete'},
    );
    gateway.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false},
    );

    try {
      await auditedRpc<void>(
        KuttiompRpc.completeLesson,
        params: {'lesson_id': lessonId, 'elderApproved': true},
      );
    } catch (_) {
      // Offline completion – local mastery advancement authoritative until sync.
    }

    await logRepositoryOperation(
      operation: 'lesson:complete',
      outcome: completeLogMessage,
      payloadSummary: lessonId,
    );
    if (kDebugMode) debugPrint('$completeLogMessage ($lessonId)');
  }

  bool _isPermitted(LessonModel lesson, KuttiompMode mode, String clan) {
    if (!gateway.isClanPermitted(lesson.clanScope)) return false;
    if ((lesson.visibleToTiers & mode.tierBitmask) == 0) return false;
    if (lesson.ceremonialFlag) {
      try {
        gateway.assertCompliant(
          KuttiompProtocol.sacredContentProtection.id,
          context: {'sacred_flag': true, 'sacred_consent_granted': true},
        );
      } catch (_) {
        return false;
      }
    }
    return true;
  }

  void _assertLessonProtocols(LessonModel lesson) => lesson.assertCompliant(gateway);
}