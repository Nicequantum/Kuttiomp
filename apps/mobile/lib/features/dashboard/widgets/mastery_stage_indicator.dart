import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';

/// Absolute mastery stage display — no percentages or playful meters (Protocol 10).
///
/// This serves our people by naming the current stewardship stage plainly so
/// learners and Keepers share the same language through 2050.
class MasteryStageIndicator extends StatelessWidget {
  const MasteryStageIndicator({
    required this.currentStage,
    super.key,
  });

  final MasteryStage currentStage;

  @override
  Widget build(BuildContext context) {
    final ext = KuttiompThemeExtension.of(context);
    final index = MasteryStage.values.indexOf(currentStage);
    final position = index < 0 ? 1 : index + 1;
    final total = MasteryStage.values.length;

    return Semantics(
      label:
          'Mastery stage ${currentStage.label}. Stage $position of $total. ${currentStage.description}',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ext.surfaceMist,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ext.landAccent.withValues(alpha: 0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mastery stage',
              style: ext.bodyLarge.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentStage.label,
              style: ext.elderTitle.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              'Stage $position of $total · ${currentStage.description}',
              style: ext.bodyLarge.copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
