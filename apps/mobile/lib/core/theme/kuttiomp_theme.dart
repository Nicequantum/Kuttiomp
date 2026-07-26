import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';

/// Culturally grounded Kuttiomp design tokens (§8, Protocol 10).
class KuttiompTheme {
  KuttiompTheme._();

  static const Color bark = Color(0xFF2D5A3D);
  static const Color mist = Color(0xFFF5F3EF);
  static const Color earth = Color(0xFF6B4E3D);

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: bark,
          surface: mist,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        visualDensity: VisualDensity.standard,
      );

  static ThemeData forMode(KuttiompMode mode) {
    final extension = KuttiompThemeExtension.forMode(mode);

    return light.copyWith(
      colorScheme: light.colorScheme.copyWith(
        primary: extension.barkPrimary,
        surface: extension.surfaceMist,
        onSurface: extension.highContrast ? Colors.black : bark,
      ),
      scaffoldBackgroundColor: extension.surfaceMist,
      textTheme: TextTheme(
        bodyLarge: extension.bodyLarge,
        titleMedium: extension.elderTitle,
        titleLarge: extension.elderTitle,
      ),
      extensions: [extension],
    );
  }
}