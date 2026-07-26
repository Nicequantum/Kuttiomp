import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';

/// Strategy pattern base for per-mode content rendering (§5).
abstract class ModeVisualStrategy {
  KuttiompMode get mode;

  Widget wrapContent({
    required BuildContext context,
    required Widget child,
    required Map<String, dynamic> contentContext,
  });

  String get longPressDescription;
}