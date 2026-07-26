/// Dashboard detail screens — feature modules own canonical details (§6).
export 'package:kuttiomp_mobile/features/lexeme/presentation/lexeme_detail_screen.dart';
export 'package:kuttiomp_mobile/features/phrases/presentation/phrase_detail_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/di/lesson_providers.dart';
import 'package:kuttiomp_mobile/features/lessons/presentation/lesson_card.dart' as lesson_content;
import 'package:kuttiomp_mobile/shared/design_system/detail_view_shell.dart';

/// Protocol-guarded lesson detail (§6) — full lessons parity is Stream C.
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