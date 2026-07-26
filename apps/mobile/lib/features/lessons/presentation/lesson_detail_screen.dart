import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/di/lesson_providers.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/lessons/domain/lesson.dart';
import 'package:kuttiomp_mobile/features/lessons/presentation/lesson_card.dart';
import 'package:kuttiomp_mobile/shared/design_system/detail_view_shell.dart';
import 'package:kuttiomp_mobile/shared/design_system/player.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';
import 'package:kuttiomp_mobile/shared/widgets/sacred_content_locker_widget.dart';

/// Protocol-guarded lesson detail with sacred locker for ceremonial content (§6, P4).
///
/// This serves our people by sequencing oral blocks under living authority and
/// never auto-rendering sacred lessons without consent through 2050.
class LessonDetailScreen extends ConsumerWidget {
  const LessonDetailScreen({required this.lessonId, super.key});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLesson = ref.watch(lessonDetailProvider(lessonId));
    final ext = KuttiompThemeExtension.of(context);

    return asyncLesson.when(
      data: (lesson) {
        // Unapproved never auto-renders (Protocol 2).
        if (!lesson.elderApproved) {
          return Scaffold(
            appBar: AppBar(title: const Text('Lesson Detail')),
            body: Center(
              child: Text(
                'Content pending elder review',
                style: ext.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final ctx = lesson.toContentContext();
        return KuttiompDetailViewShell(
          title: 'Lesson Detail',
          speakerMetadata: lesson.speakerMetadata,
          contentContext: ctx,
          visibleToTiers: lesson.visibleToTiers,
          child: _LessonDetailBody(lesson: lesson, ext: ext),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Error: $err', style: ext.bodyLarge)),
      ),
    );
  }
}

class _LessonDetailBody extends StatelessWidget {
  const _LessonDetailBody({required this.lesson, required this.ext});

  final LessonModel lesson;
  final KuttiompThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    final ctx = lesson.toContentContext();

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LessonCard.fromLesson(lesson: lesson),
        const SizedBox(height: 16),
        Text('Oral sequence', style: ext.elderTitle.copyWith(fontSize: 22)),
        const SizedBox(height: 8),
        ...lesson.audioBlocks.map(
          (block) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OralFirstPlayer(
              speakerMetadata: lesson.speakerMetadata,
              contentContext: {
                ...ctx,
                'primary_audio_id': block.primaryAudioId,
              },
              audioLabel: block.label,
              textContent: block.transcript,
            ),
          ),
        ),
        AuthorityBadge(
          speakerMetadata: lesson.speakerMetadata,
          contentContext: ctx,
        ),
      ],
    );

    if (lesson.ceremonialFlag) {
      content = SacredContentLockerWidget(
        recordId: lesson.id,
        isSacred: true,
        contentContext: ctx,
        child: content,
      );
    }

    return content;
  }
}