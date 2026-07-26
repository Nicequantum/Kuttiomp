/// Dashboard content list screens — lexeme module owns canonical list (§6).
export 'package:kuttiomp_mobile/features/lexeme/presentation/lexeme_list_screen.dart'
    show LexemeListScreen, LexemesScreen;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/di/lesson_providers.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/di/phrase_providers.dart';
import 'package:kuttiomp_mobile/features/lessons/presentation/lesson_card.dart' as lesson_content;
import 'package:kuttiomp_mobile/features/phrases/presentation/phrase_card.dart' as phrase_content;
import 'package:kuttiomp_mobile/modes/mode_aware_shell.dart';

/// Protocol-guarded phrase list (§6).
class PhrasesScreen extends ConsumerWidget {
  const PhrasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeControllerProvider).valueOrNull;
    final asyncPhrases = ref.watch(phraseListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Phrases')),
      body: ModeAwareShell.forContentList(
        mode: mode,
        surface: 'phrases_list',
        child: asyncPhrases.when(
          data: (phrases) => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: phrases.length,
            itemBuilder: (context, index) {
              final phrase = phrases[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: phrase_content.PhraseCard.fromPhrase(
                  phrase: phrase,
                  onTap: () => context.go('/phrase/${phrase.id}'),
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}

/// Protocol-guarded lesson list (§6).
class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeControllerProvider).valueOrNull;
    final asyncLessons = ref.watch(lessonListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Lessons')),
      body: ModeAwareShell.forContentList(
        mode: mode,
        surface: 'lessons_list',
        child: asyncLessons.when(
          data: (lessons) => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: lesson_content.LessonCard.fromLesson(
                  lesson: lesson,
                  onTap: () => context.go('/lesson/${lesson.id}'),
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}