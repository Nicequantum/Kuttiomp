import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';

/// Unified dashboard petal for Lexemes / Phrases / Lessons (§6).
///
/// Absolute counts only — no gamification (Protocol 10).
/// This serves our people by presenting the three content pathways with equal
/// dignity and elder-readable type through 2050.
class ContentSectionPetal extends StatelessWidget {
  const ContentSectionPetal({
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.semanticsLabel,
    super.key,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final ext = KuttiompThemeExtension.of(context);

    return Semantics(
      button: true,
      label: semanticsLabel ?? '$title. $subtitle',
      child: Material(
        color: ext.surfaceMist,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ext.landAccent.withValues(alpha: 0.55)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: ext.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: ext.bodyLarge),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward, color: ext.landAccent, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}