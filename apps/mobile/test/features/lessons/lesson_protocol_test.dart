import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/features/lessons/data/lessons_repository.dart';
import 'package:kuttiomp_mobile/features/lessons/domain/lesson.dart';

void main() {
  late KuttiompProtocolService service;
  late LessonsRepository repository;

  setUp(() {
    AuditLogStore.instance.clear();
    service = KuttiompProtocolService.instance;
    service.init(claims: {
      'mode': KuttiompMode.littleOnes.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': GenerationalTierBitmask.littleOnes,
    });
    repository = LessonsRepository(
      gateway: ProtocolGateway(protocolService: service),
    );
  });

  group('LessonsRepository – Protocol enforcement', () {
    test('getContent returns lesson with required audio blocks (Protocol 7)', () async {
      final lesson = await repository.getContent('lesson-awakening-greetings');
      expect(lesson.audioBlocks, isNotEmpty);
      for (final block in lesson.audioBlocks) {
        expect(block.primaryAudioId, isNotEmpty);
      }
      expect(lesson.speakerId, isNotEmpty);
    });

    test('completeLesson logs Protocols 2,7,8,9 message', () async {
      await repository.completeLesson('lesson-awakening-greetings');
      expect(
        AuditLogStore.instance.entries.any(
          (e) => e.outcome.contains('Protocols 2,7,8,9'),
        ),
        isTrue,
      );
      expect(
        LessonsRepository.completeLogMessage,
        'Lesson completed | Protocols 2,7,8,9 enforced',
      );
    });

    test('audio block model requires primary_audio_id', () {
      expect(
        () => LessonAudioBlock.fromJson({
          'id': 'bad',
          'label': 'Test',
        }),
        throwsArgumentError,
      );
    });

    test('watchLessonsForTier filters ceremonial lessons for little ones (Protocol 4)', () async {
      final lessons = await repository.watchLessonsForTier(
        KuttiompMode.littleOnes.tierBitmask,
        stage: 'deepening',
      );
      expect(lessons.any((l) => l.ceremonialFlag), isFalse);
    });

    test('watchLessonsForTier filters by clan scope (Protocol 5)', () async {
      final lessons = await repository.watchLessonsForTier(
        KuttiompMode.littleOnes.tierBitmask,
        stage: 'awakening',
      );
      expect(lessons, isNotEmpty);
      for (final lesson in lessons) {
        expect(lesson.clanScope, contains('kuttiomp_clan'));
      }
    });

    test('lesson content asserts living authority (Protocol 8)', () async {
      final lesson = await repository.getContent('lesson-awakening-greetings');
      final ctx = lesson.toContentContext();
      expect(() => service.assertLivingAuthority(context: ctx), returnsNormally);
    });

    test('uses audited RPC names only', () {
      expect(KuttiompRpc.getLessonsForStage, 'get_lessons_for_stage');
      expect(KuttiompRpc.getLessonContent, 'get_lesson_content');
      expect(KuttiompRpc.completeLesson, 'complete_lesson_secure');
      expect(KuttiompRpc.all, contains('get_lessons_for_stage'));
      expect(KuttiompRpc.all, contains('complete_lesson_secure'));
    });
  });
}