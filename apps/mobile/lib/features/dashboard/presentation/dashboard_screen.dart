import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/dashboard/presentation/lesson_card.dart';
import 'package:kuttiomp_mobile/features/dashboard/presentation/phrase_card.dart';
import 'package:kuttiomp_mobile/features/lexeme/presentation/lexeme_mastery_petal.dart';
import 'package:kuttiomp_mobile/modes/mode_aware_shell.dart';

/// Minimal vertical dashboard — mastery petal + phrase + lesson sections (§6).
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeControllerProvider).valueOrNull;
    final ext = KuttiompThemeExtension.of(context);

    return ModeAwareShell.forDashboard(
      mode: mode,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Welcome back', style: ext.elderTitle),
          const SizedBox(height: 8),
          Text('Continue where you left off', style: ext.bodyLarge),
          const SizedBox(height: 24),
          Text('Lexemes', style: ext.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const LexemeMasteryPetalCard(),
          const SizedBox(height: 24),
          Text('Phrases', style: ext.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const PhraseCard(),
          const SizedBox(height: 24),
          Text('Lessons', style: ext.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const LessonCard(),
        ],
      ),
    );
  }
}