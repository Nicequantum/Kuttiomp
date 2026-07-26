import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/protocol/guards/dignity_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';

/// Central design system registry enforcing Protocol 10 dignity rules.
class KuttiompDesignSystem {
  KuttiompDesignSystem._();

  static const Set<String> allowedAssetPrefixes = {
    'assets/images/land_',
    'assets/images/turtle_',
    'assets/images/river_',
    'assets/fonts/traditional_',
  };

  static const Set<String> prohibitedAssetPatterns = {
    'playful_mascot',
    'achievement_badge',
    'confetti',
    'emoji',
    'cartoon',
    'gamification',
  };

  /// Validates widget/asset at build time; throws via Protocol 10 guard.
  static void assertDignity({
    String? widgetType,
    String? assetPath,
    bool usesPlayfulAssets = false,
  }) {
    KuttiompProtocolService.instance.assertDignity(
      context: {
        if (widgetType != null) 'widgetType': widgetType,
        'usesPlayfulAssets': usesPlayfulAssets,
      },
    );

    if (assetPath != null) {
      final lower = assetPath.toLowerCase();
      for (final pattern in prohibitedAssetPatterns) {
        if (lower.contains(pattern)) {
          KuttiompProtocolService.instance.assertDignity(
            context: {'usesPlayfulAssets': true},
          );
        }
      }
      final allowed = allowedAssetPrefixes.any(lower.startsWith);
      if (assetPath.startsWith('assets/') && !allowed) {
        KuttiompProtocolService.instance.assertDignity(
          context: {'usesPlayfulAssets': true},
        );
      }
    }

    if (widgetType != null && DignityGuard.prohibitedWidgetTypes.contains(widgetType)) {
      KuttiompProtocolService.instance.assertDignity(
        context: {'widgetType': widgetType},
      );
    }
  }

  static BoxDecoration landAccentBorder(BuildContext context) {
    final ext = KuttiompThemeExtension.of(context);
    return BoxDecoration(
      border: Border.all(color: ext.landAccent, width: 1.5),
      borderRadius: BorderRadius.circular(8),
    );
  }
}