import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';

/// Mode-specific theme extension registered in MaterialApp (§8).
class KuttiompThemeExtension extends ThemeExtension<KuttiompThemeExtension> {
  const KuttiompThemeExtension({
    required this.mode,
    required this.bodyLarge,
    required this.elderTitle,
    required this.landAccent,
    required this.surfaceMist,
    required this.barkPrimary,
    required this.highContrast,
    required this.minimumTouchTarget,
  });

  final KuttiompMode mode;
  final TextStyle bodyLarge;
  final TextStyle elderTitle;
  final Color landAccent;
  final Color surfaceMist;
  final Color barkPrimary;
  final bool highContrast;
  final double minimumTouchTarget;

  factory KuttiompThemeExtension.forMode(KuttiompMode mode) {
    const bark = Color(0xFF2D5A3D);
    const mist = Color(0xFFF5F3EF);
    const earth = Color(0xFF6B4E3D);
    const sky = Color(0xFF4A6B7C);

    switch (mode) {
      case KuttiompMode.littleOnes:
        return KuttiompThemeExtension(
          mode: mode,
          bodyLarge: const TextStyle(fontSize: 24, height: 1.5, color: bark),
          elderTitle: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: bark),
          landAccent: const Color(0xFF8B6F47),
          surfaceMist: const Color(0xFFFFF8F0),
          barkPrimary: bark,
          highContrast: false,
          minimumTouchTarget: 56,
        );
      case KuttiompMode.youngLearner:
        return KuttiompThemeExtension(
          mode: mode,
          bodyLarge: const TextStyle(fontSize: 24, height: 1.45, color: bark),
          elderTitle: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: bark),
          landAccent: earth,
          surfaceMist: mist,
          barkPrimary: bark,
          highContrast: false,
          minimumTouchTarget: 52,
        );
      case KuttiompMode.coreAdult:
        return KuttiompThemeExtension(
          mode: mode,
          bodyLarge: const TextStyle(fontSize: 24, height: 1.4, color: bark),
          elderTitle: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: bark),
          landAccent: earth,
          surfaceMist: mist,
          barkPrimary: bark,
          highContrast: true,
          minimumTouchTarget: 48,
        );
      case KuttiompMode.elder:
        return KuttiompThemeExtension(
          mode: mode,
          bodyLarge: const TextStyle(fontSize: 32, height: 1.5, color: Color(0xFF1A1A1A)),
          elderTitle: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: Color(0xFF000000),
          ),
          landAccent: sky,
          surfaceMist: const Color(0xFFFFFFFF),
          barkPrimary: bark,
          highContrast: true,
          minimumTouchTarget: 64,
        );
    }
  }

  static KuttiompThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<KuttiompThemeExtension>() ??
        KuttiompThemeExtension.forMode(KuttiompMode.littleOnes);
  }

  @override
  KuttiompThemeExtension copyWith({
    KuttiompMode? mode,
    TextStyle? bodyLarge,
    TextStyle? elderTitle,
    Color? landAccent,
    Color? surfaceMist,
    Color? barkPrimary,
    bool? highContrast,
    double? minimumTouchTarget,
  }) {
    return KuttiompThemeExtension(
      mode: mode ?? this.mode,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      elderTitle: elderTitle ?? this.elderTitle,
      landAccent: landAccent ?? this.landAccent,
      surfaceMist: surfaceMist ?? this.surfaceMist,
      barkPrimary: barkPrimary ?? this.barkPrimary,
      highContrast: highContrast ?? this.highContrast,
      minimumTouchTarget: minimumTouchTarget ?? this.minimumTouchTarget,
    );
  }

  @override
  KuttiompThemeExtension lerp(ThemeExtension<KuttiompThemeExtension>? other, double t) {
    if (other is! KuttiompThemeExtension) return this;
    return KuttiompThemeExtension.forMode(t < 0.5 ? mode : other.mode);
  }
}