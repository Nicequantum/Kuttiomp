import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/di/lesson_providers.dart';

/// Dashboard lesson section petal — navigates to lesson list (§6).
class LessonCard extends ConsumerWidget {
  const LessonCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessons = ref.watch(lessonListProvider).valueOrNull;
    final nextLesson = lessons != null && lessons.isNotEmpty ? lessons.first : null;

    return Card(
      child: ListTile(
        title: const Text('Next Lesson'),
        subtitle: Text(nextLesson?.title ?? 'No lessons yet'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () => context.go('/lessons'),
      ),
    );
  }
}