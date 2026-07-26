import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/lessons/domain/lesson.dart';
import 'package:kuttiomp_mobile/shared/design_system/kuttiomp_content_widget.dart';
import 'package:kuttiomp_mobile/shared/design_system/living_authority_decorator.dart';
import 'package:kuttiomp_mobile/shared/design_system/player.dart';
import 'package:kuttiomp_mobile/shared/design_system/tier_aware_page.dart';
import 'package:kuttiomp_mobile/shared/widgets/approved_content_gate.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';
import 'package:kuttiomp_mobile/shared/widgets/sacred_content_locker_widget.dart';

/// Lesson card – KuttiompContentWidget with full guard stack (§6, Protocol 4).
///
/// This serves our people by keeping ceremonial lessons behind consent while
/// oral primacy guides every stage through 2050.
class LessonCard extends KuttiompContentWidget {
  LessonCard({
    required this.lesson,
    required super.speakerMetadata,
    required Map<String, dynamic> contentContext,
    this.onTap,
    this.activeBlockIndex = 0,
    super.key,
  }) : super(
          elderApproved: contentContext['elderApproved'] == true,
          clanScope: _clanScope(contentContext),
          contentContext: contentContext,
        );

  final LessonModel lesson;
  final VoidCallback? onTap;
  final int activeBlockIndex;

  static List<String> _clanScope(Map<String, dynamic> ctx) {
    final raw = ctx['clan_scope'] ?? ctx['clanScope'];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    return const [];
  }

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
    final ctx = mergedContext;
    final progress = lesson.progressPercent.clamp(0, 100);
    final block = lesson.audioBlocks.isNotEmpty
        ? lesson.audioBlocks[
            activeBlockIndex.clamp(0, lesson.audioBlocks.length - 1)]
        : null;

    Widget body = LivingAuthorityDecorator(
      speakerMetadata: lesson.speakerMetadata,
      contentContext: ctx,
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
                border: Border.all(color: ext.landAccent.withValues(alpha: 0.5)),
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
                  if (lesson.ceremonialFlag) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Ceremonial content — consent required',
                      style: ext.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ext.landAccent,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  // Linear progress only — no gamification (Protocol 10).
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      minHeight: 8,
                      backgroundColor: ext.barkPrimary.withValues(alpha: 0.2),
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
                        ...ctx,
                        'primary_audio_id': block.primaryAudioId,
                      },
                      audioLabel: block.label,
                      textContent: block.transcript,
                    ),
                  ],
                  const SizedBox(height: 12),
                  AuthorityBadge(
                    speakerMetadata: speakerMetadata,
                    contentContext: ctx,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (lesson.ceremonialFlag) {
      body = SacredContentLockerWidget(
        recordId: lesson.id,
        isSacred: true,
        contentContext: ctx,
        child: body,
      );
    }

    return ApprovedContentGate(
      contentContext: ctx,
      builder: (_) => _LessonCardTierShell(
        requiredTier: lesson.visibleToTiers,
        child: body,
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