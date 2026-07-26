import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/di/lesson_providers.dart';
import 'package:kuttiomp_mobile/features/lessons/data/lessons_repository.dart';
import 'package:kuttiomp_mobile/features/lessons/domain/lesson.dart';
import '../../helpers/kuttiomp_test_harness.dart';

void main() {
  setUp(() async {
    await KuttiompTestHarness.initProtocol(mode: KuttiompMode.coreAdult);
  });

  group('lessons §4 structure', () {
    test('LessonModel assertCompliant passes governed content', () {
      const lesson = LessonModel(
        id: 'lesson-awakening-greetings',
        title: 'Morning Greetings',
        description: 'Recognize common greetings by sound and context.',
        stage: MasteryStage.awakening,
        speakerMetadata: {
          'speaker_id': 'grandmother-comus',
          'name': 'Grandmother Comus',
          'authority_source': 'elder',
        },
        audioBlocks: [
          LessonAudioBlock(
            id: 'block-1',
            label: 'Hear the greeting',
            primaryAudioId: 'audio-lesson-greet-1',
            order: 0,
            transcript: 'Anska',
          ),
        ],
      );
      final gateway = ProtocolGateway();
      lesson.assertCompliant(gateway);
      expect(gateway.allAssertionsPassed(content: lesson.toContentContext()), isTrue);
    });

    test('watchLessonsForTier enforces protocols via secure RPC path', () async {
      final repository = LessonsRepository(gateway: ProtocolGateway());
      final lessons = await repository.watchLessonsForTier(
        KuttiompMode.littleOnes.tierBitmask,
        stage: MasteryStage.awakening.id,
      );
      expect(lessons, isNotEmpty);
      expect(lessons.every((l) => l.elderApproved), isTrue);
    });

    test('lesson providers live in core/di only', () {
      expect(lessonsRepositoryProvider, isNotNull);
      expect(lessonFilterProvider, isNotNull);
      expect(lessonListProvider, isNotNull);
      expect(lessonDetailProvider, isNotNull);
    });
  });
}