import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/dashboard/presentation/lesson_card.dart';
import 'package:kuttiomp_mobile/features/dashboard/presentation/phrase_card.dart';
import 'package:kuttiomp_mobile/features/lexeme/presentation/lexeme_mastery_petal.dart';
import 'package:kuttiomp_mobile/features/stewardship/presentation/stewardship_summary_card.dart';
import 'package:kuttiomp_mobile/modes/mode_aware_shell.dart';

/// Vertical dashboard — three content pathways + optional stewardship (§6).
///
/// This serves our people by offering a single respectful home for words,
/// phrases, and lessons under mode-adapted presentation through 2050.
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
          Text(
            'Continue where you left off. Content is elder-approved and oral-first.',
            style: ext.bodyLarge,
          ),
          const SizedBox(height: 16),
          // Core Adult / Elder only — absolute stewardship counts (Protocol 10).
          const StewardshipModeGatedCard(speakerId: 'grandmother-comus'),
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