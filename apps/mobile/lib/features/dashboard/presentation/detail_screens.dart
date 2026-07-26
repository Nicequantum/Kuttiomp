/// Dashboard detail screens — lexeme module owns canonical detail (§6).
export 'package:kuttiomp_mobile/features/lexeme/presentation/lexeme_detail_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/di/lesson_providers.dart';
import 'package:kuttiomp_mobile/core/di/phrase_providers.dart';
import 'package:kuttiomp_mobile/features/lessons/presentation/lesson_card.dart' as lesson_content;
import 'package:kuttiomp_mobile/features/phrases/presentation/phrase_card.dart' as phrase_content;
import 'package:kuttiomp_mobile/shared/design_system/detail_view_shell.dart';

/// Protocol-guarded phrase detail (§6).
class PhraseDetailScreen extends ConsumerWidget {
  const PhraseDetailScreen({required this.phraseId, super.key});

  final String phraseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPhrase = ref.watch(phraseDetailProvider(phraseId));
    return asyncPhrase.when(
      data: (phrase) => KuttiompDetailViewShell(
        title: 'Phrase Detail',
        speakerMetadata: phrase.speakerMetadata,
        contentContext: phrase.toContentContext(),
        visibleToTiers: phrase.visibleToTiers,
        child: phrase_content.PhraseCard.fromPhrase(phrase: phrase),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}

/// Protocol-guarded lesson detail (§6).
class LessonDetailScreen extends ConsumerWidget {
  const LessonDetailScreen({required this.lessonId, super.key});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLesson = ref.watch(lessonDetailProvider(lessonId));
    return asyncLesson.when(
      data: (lesson) => KuttiompDetailViewShell(
        title: 'Lesson Detail',
        speakerMetadata: lesson.speakerMetadata,
        contentContext: lesson.toContentContext(),
        visibleToTiers: lesson.visibleToTiers,
        child: lesson_content.LessonCard.fromLesson(lesson: lesson),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}