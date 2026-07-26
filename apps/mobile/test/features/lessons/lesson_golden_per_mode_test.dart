import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/lessons/data/lessons_repository.dart';
import 'package:kuttiomp_mobile/features/lessons/domain/lesson.dart';
import 'package:kuttiomp_mobile/features/lessons/presentation/lesson_card.dart';

/// Golden-lock structural tests – lesson card renders per mode (§11).
void main() {
  late LessonModel lesson;

  setUp(() {
    KuttiompProtocolService.instance.init(
      claims: {
        'mode': KuttiompMode.littleOnes.id,
        'clan': 'kuttiomp_clan',
        'role': 'learner',
        'tier': GenerationalTierBitmask.littleOnes,
      },
    );
    lesson = const LessonModel(
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
      progressPercent: 50,
    );
  });

  Widget wrapMode(KuttiompMode mode, Widget child) {
    return ProviderScope(
      child: MaterialApp(
        theme: KuttiompTheme.forMode(mode).copyWith(
          extensions: [KuttiompThemeExtension.forMode(mode)],
        ),
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );
  }

  for (final mode in KuttiompMode.values) {
    group('Lesson golden lock – ${mode.label}', () {
      testWidgets('LessonCard renders progress and oral-first sequence', (tester) async {
        await tester.pumpWidget(
          wrapMode(
            mode,
            LessonCard.fromLesson(lesson: lesson, onTap: () {}),
          ),
        );

        expect(find.text('Morning Greetings'), findsOneWidget);
        expect(find.textContaining('Stage: Awakening'), findsOneWidget);
        expect(find.text('50% complete'), findsOneWidget);
        expect(find.text('Hear the greeting'), findsOneWidget);
        expect(find.textContaining('Authority:'), findsOneWidget);
      });

      testWidgets('meets minimum font size for mode', (tester) async {
        await tester.pumpWidget(
          wrapMode(
            mode,
            Builder(
              builder: (context) {
                final ext = KuttiompThemeExtension.of(context);
                expect(ext.bodyLarge.fontSize, greaterThanOrEqualTo(mode.minimumFontSize));
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });
  }

  test('complete log message matches verification contract', () {
    expect(
      LessonsRepository.completeLogMessage,
      'Lesson completed | Protocols 2,7,8,9 enforced',
    );
  });
}