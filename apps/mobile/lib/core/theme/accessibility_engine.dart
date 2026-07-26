import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';

/// Protocol 11 – forces elder-centric MediaQuery overrides and Semantics.
class AccessibilityEngine extends StatelessWidget {
  const AccessibilityEngine({
    required this.mode,
    required this.child,
    this.onElderActivated,
    super.key,
  });

  final KuttiompMode mode;
  final Widget child;
  final VoidCallback? onElderActivated;

  static bool elderOverlayActive = false;

  @override
  Widget build(BuildContext context) {
    final extension = KuttiompThemeExtension.forMode(mode);
    final isElder = mode == KuttiompMode.elder;

    if (isElder && !elderOverlayActive) {
      elderOverlayActive = true;
      onElderActivated?.call();
    }

    KuttiompProtocolService.instance.assertAccessibility(
      context: {
        'fontSize': extension.bodyLarge.fontSize ?? 24,
        'requiresSemantics': isElder,
        'hasSemanticsLabel': true,
      },
    );

    final media = MediaQuery.of(context);
    final scaled = media.copyWith(
      textScaler: isElder
          ? TextScaler.linear(1.25)
          : TextScaler.noScaling,
      boldText: isElder || media.boldText,
      accessibleNavigation: true,
    );

    return MediaQuery(
      data: scaled,
      child: Semantics(
        label: isElder
            ? 'Elder accessibility mode active with enhanced contrast and typography'
            : 'Kuttiomp accessibility baseline active',
        child: child,
      ),
    );
  }
}