import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/di/lesson_providers.dart';
import 'package:kuttiomp_mobile/features/dashboard/presentation/content_section_petal.dart';

/// Dashboard lesson petal — next title + absolute count (§6).
class LessonCard extends ConsumerWidget {
  const LessonCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessons = ref.watch(lessonListProvider).valueOrNull;
    final count = lessons?.length ?? 0;
    final nextTitle = (lessons != null && lessons.isNotEmpty)
        ? lessons.first.title
        : 'No lessons yet';

    return ContentSectionPetal(
      title: 'Lessons',
      subtitle: count == 0 ? nextTitle : '$count available · Next: $nextTitle',
      semanticsLabel: 'Lessons section. $count available. Next: $nextTitle.',
      onTap: () => context.go('/lessons'),
    );
  }
}