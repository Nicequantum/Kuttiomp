import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/modes/mode_visual_strategy.dart';

/// Little Ones – warm, gentle visual strategy.
class LittleOnesVisualStrategy implements ModeVisualStrategy {
  @override
  KuttiompMode get mode => KuttiompMode.littleOnes;

  @override
  String get longPressDescription =>
      'Little Ones mode — gentle introduction for our youngest learners';

  @override
  Widget wrapContent({
    required BuildContext context,
    required Widget child,
    required Map<String, dynamic> contentContext,
  }) {
    final ext = KuttiompThemeExtension.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ext.surfaceMist,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        // Fill parent so dashboard ListView has a bounded viewport.
        child: SizedBox.expand(child: child),
      ),
    );
  }
}