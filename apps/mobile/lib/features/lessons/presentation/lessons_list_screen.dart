import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/di/lesson_providers.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/lessons/presentation/lesson_card.dart';
import 'package:kuttiomp_mobile/modes/mode_aware_shell.dart';
import 'package:kuttiomp_mobile/shared/design_system/cards.dart';

/// Protocol-guarded lesson list — ceremonial lessons never auto-listed without filters.
///
/// This serves our people by sequencing oral lessons under elder approval and
/// generational readiness for 25 years of household learning.
class LessonsListScreen extends ConsumerWidget {
  const LessonsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeControllerProvider).valueOrNull;
    final asyncLessons = ref.watch(lessonListProvider);
    final ext = KuttiompThemeExtension.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Lessons', style: ext.elderTitle)),
      body: ModeAwareShell.forContentList(
        mode: mode,
        surface: 'lessons_list',
        child: asyncLessons.when(
          data: (lessons) {
            // Public list excludes ceremonial for non-elder paths (Protocol 4).
            final visible = lessons.where((l) {
              if (!l.elderApproved) return false;
              if (l.ceremonialFlag && mode?.id != 'elder') return false;
              return true;
            }).toList();

            if (visible.isEmpty) {
              return Center(
                child: ContentCard(
                  speakerMetadata: const {
                    'speaker_id': 'system-lesson-list',
                    'name': 'Kuttiomp',
                    'authority_source': 'elder',
                  },
                  contentContext: const {
                    'elderApproved': true,
                    'clan_scope': ['kuttiomp_clan'],
                    'authority_source': 'elder',
                  },
                  title: 'No lessons yet',
                  subtitle: 'Elder-approved lessons will appear here.',
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: visible.length,
              itemBuilder: (context, index) {
                final lesson = visible[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: LessonCard.fromLesson(
                    lesson: lesson,
                    onTap: () => context.go('/lesson/${lesson.id}'),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) =>
              Center(child: Text('Error: $err', style: ext.bodyLarge)),
        ),
      ),
    );
  }
}

/// Backward-compatible alias used by dashboard content_list_screens.
typedef LessonsScreen = LessonsListScreen;