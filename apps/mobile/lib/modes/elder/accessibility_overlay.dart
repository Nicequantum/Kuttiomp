import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/theme/accessibility_engine.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';

/// Protocol 11 – Elder mode visual and accessibility overlay (§5, §8).
///
/// This serves our people by guaranteeing 32pt typography and high-contrast
/// presentation for elders across every device generation through 2050.
class ElderModeOverlay extends StatelessWidget {
  const ElderModeOverlay({
    required this.mode,
    required this.child,
    super.key,
  });

  final KuttiompMode mode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AccessibilityEngine(
      mode: mode,
      child: Builder(
        builder: (context) {
          if (mode != KuttiompMode.elder) return child;

          final ext = KuttiompThemeExtension.of(context);
          return DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: ext.landAccent, width: 2),
            ),
            child: Column(
              children: [
                Semantics(
                  label: 'Elder mode overlay active',
                  child: Container(
                    width: double.infinity,
                    color: ext.landAccent.withValues(alpha: 0.12),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Elder Mode — Enhanced accessibility active',
                      style: ext.elderTitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          );
        },
      ),
    );
  }
}