import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/modes/core_adult/overrides/visual_strategy.dart';
import 'package:kuttiomp_mobile/modes/elder/accessibility_overlay.dart';
import 'package:kuttiomp_mobile/modes/elder/voice_narrative_strategy.dart';
import 'package:kuttiomp_mobile/modes/little_ones/overrides/visual_strategy.dart';
import 'package:kuttiomp_mobile/modes/mode_visual_strategy.dart';
import 'package:kuttiomp_mobile/modes/young_learner/overrides/visual_strategy.dart';

/// Strategy-pattern content adaptation across four modes (§5).
///
/// This serves our people by isolating per-generation presentation rules so
/// tribal maintainers can adjust one mode without risking others through 2050.
class ContentRenderer {
  ContentRenderer._();

  static const Duration transitionDuration = Duration(milliseconds: 280);

  static ModeVisualStrategy strategyFor(KuttiompMode mode) {
    switch (mode) {
      case KuttiompMode.littleOnes:
        return LittleOnesVisualStrategy();
      case KuttiompMode.youngLearner:
        return YoungLearnerVisualStrategy();
      case KuttiompMode.coreAdult:
        return CoreAdultVisualStrategy();
      case KuttiompMode.elder:
        return ElderVoiceNarrativeStrategy();
    }
  }

  static Widget adaptForMode({
    required BuildContext context,
    required KuttiompMode mode,
    required Widget child,
    required Map<String, dynamic> contentContext,
  }) {
    final strategy = strategyFor(mode);
    final wrapped = strategy.wrapContent(
      context: context,
      child: child,
      contentContext: contentContext,
    );

    final themed = Theme(
      data: Theme.of(context).copyWith(
        extensions: [KuttiompThemeExtension.forMode(mode)],
      ),
      child: wrapped,
    );

    if (mode == KuttiompMode.elder) {
      return ElderModeOverlay(mode: mode, child: themed);
    }
    return themed;
  }

  static String longPressDescriptionFor(KuttiompMode mode) =>
      strategyFor(mode).longPressDescription;
}