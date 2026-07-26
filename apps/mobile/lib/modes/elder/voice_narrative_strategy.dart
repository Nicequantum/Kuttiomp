import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/modes/mode_visual_strategy.dart';

/// Elder – voice-first narrative strategy (Protocol 7 & 8).
class ElderVoiceNarrativeStrategy implements ModeVisualStrategy {
  @override
  KuttiompMode get mode => KuttiompMode.elder;

  @override
  String get longPressDescription =>
      'Elder mode — voice-first sharing with maximum accessibility';

  @override
  Widget wrapContent({
    required BuildContext context,
    required Widget child,
    required Map<String, dynamic> contentContext,
  }) {
    final ext = KuttiompThemeExtension.of(context);
    return Semantics(
      label: 'Elder voice narrative content',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.record_voice_over, color: ext.landAccent, size: 28),
              const SizedBox(width: 8),
              Text('Voice leads', style: ext.elderTitle),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}