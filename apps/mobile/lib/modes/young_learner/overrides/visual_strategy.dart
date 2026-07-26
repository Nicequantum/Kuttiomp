import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/modes/mode_visual_strategy.dart';

/// Young Learner – balanced instructional strategy.
class YoungLearnerVisualStrategy implements ModeVisualStrategy {
  @override
  KuttiompMode get mode => KuttiompMode.youngLearner;

  @override
  String get longPressDescription =>
      'Young Learner mode — structured study for students';

  @override
  Widget wrapContent({
    required BuildContext context,
    required Widget child,
    required Map<String, dynamic> contentContext,
  }) {
    final ext = KuttiompThemeExtension.of(context);
    final body = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: child,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final bounded = constraints.maxHeight.isFinite;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: bounded ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Divider(color: ext.landAccent, height: 1),
            if (bounded) Expanded(child: body) else body,
          ],
        );
      },
    );
  }
}