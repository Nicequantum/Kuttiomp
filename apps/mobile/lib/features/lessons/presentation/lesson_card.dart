import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/protocol/tier_aware_page.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/lessons/domain/lesson.dart';
import 'package:kuttiomp_mobile/shared/design_system/oral_first_player.dart';
import 'package:kuttiomp_mobile/shared/widgets/approved_content_gate.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';
import 'package:kuttiomp_mobile/shared/widgets/protocol_base_widget.dart';

/// Tappable lesson card with progress indicator and oral-first sequence (Protocols 1,7,8).
///
/// Tribal Maintainer Guide (Protocol 12): modify guards via list/detail in dashboard; search `LessonCard`.
class LessonCard extends ProtocolBaseWidget {
  const LessonCard({
    required this.lesson,
    required super.speakerMetadata,
    required super.contentContext,
    this.onTap,
    this.activeBlockIndex = 0,
    super.key,
  });

  final LessonModel lesson;
  final VoidCallback? onTap;
  final int activeBlockIndex;

  factory LessonCard.fromLesson({
    required LessonModel lesson,
    VoidCallback? onTap,
    int activeBlockIndex = 0,
    Key? key,
  }) {
    return LessonCard(
      key: key,
      lesson: lesson,
      speakerMetadata: lesson.speakerMetadata,
      contentContext: lesson.toContentContext(),
      onTap: onTap,
      activeBlockIndex: activeBlockIndex,
    );
  }

  @override
  Widget buildProtocolContent(BuildContext context) {
    final ext = KuttiompThemeExtension.of(context);
    final ctx = lesson.toContentContext();
    final progress = lesson.progressPercent.clamp(0, 100);
    final block = lesson.audioBlocks.isNotEmpty
        ? lesson.audioBlocks[activeBlockIndex.clamp(0, lesson.audioBlocks.length - 1)]
        : null;

    return ApprovedContentGate(
      contentContext: ctx,
      builder: (_) => _LessonCardTierShell(
        requiredTier: lesson.visibleToTiers,
        child: Semantics(
          button: onTap != null,
          label:
              'Lesson ${lesson.title}. Stage ${lesson.stage.label}. $progress percent complete.',
          child: Material(
            color: ext.surfaceMist,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ext.landAccent.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(lesson.title, style: ext.elderTitle),
                    const SizedBox(height: 4),
                    Text(lesson.description, style: ext.bodyLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Stage: ${lesson.stage.label}',
                      style: ext.bodyLarge.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress / 100,
                        minHeight: 8,
                        backgroundColor: ext.barkPrimary.withOpacity(0.2),
                        color: ext.landAccent,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('$progress% complete', style: ext.bodyLarge.copyWith(fontSize: 18)),
                    if (block != null) ...[
                      const SizedBox(height: 12),
                      OralFirstPlayer(
                        speakerMetadata: speakerMetadata,
                        contentContext: {
                          ...contentContext,
                          'primary_audio_id': block.primaryAudioId,
                        },
                        audioLabel: block.label,
                        textContent: block.transcript,
                      ),
                    ],
                    const SizedBox(height: 12),
                    AuthorityBadge(
                      speakerMetadata: speakerMetadata,
                      contentContext: contentContext,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LessonCardTierShell extends TierAwarePage {
  const _LessonCardTierShell({
    required super.requiredTier,
    required this.child,
  });

  final Widget child;

  @override
  Widget buildTierContent(BuildContext context) => child;
}