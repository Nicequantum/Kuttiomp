import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/modes/mode_visual_strategy.dart';

/// Core Adult – clear narrative strategy for tribal members.
class CoreAdultVisualStrategy implements ModeVisualStrategy {
  @override
  KuttiompMode get mode => KuttiompMode.coreAdult;

  @override
  String get longPressDescription =>
      'Core Adult mode — everyday language for tribal members';

  @override
  Widget wrapContent({
    required BuildContext context,
    required Widget child,
    required Map<String, dynamic> contentContext,
  }) {
    final ext = KuttiompThemeExtension.of(context);
    return Semantics(
      label: 'Core adult learning content',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: DefaultTextStyle(
          style: ext.bodyLarge,
          child: child,
        ),
      ),
    );
  }
}