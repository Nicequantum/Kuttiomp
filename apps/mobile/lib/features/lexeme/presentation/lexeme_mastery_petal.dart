import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/di/lexeme_providers.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';
import 'package:kuttiomp_mobile/shared/design_system/cards.dart';

/// Dashboard mastery petal — unified six-stage progression (§6).
///
/// This serves our people by showing Awakening → Ancestral Mastery progress on
/// the dashboard while linking to elder-seeded lexeme corpus for 25 years.
class LexemeMasteryPetal extends ConsumerWidget {
  const LexemeMasteryPetal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeControllerProvider).valueOrNull;
    final mastery = ref.watch(userMasteryProvider);
    final count = ref.watch(lexemeListProvider).valueOrNull?.length ?? 0;
    final stage = MasteryStage.fromId(mastery.canonicalStage);
    final nextStage = _nextStage(stage);
    final ext = KuttiompThemeExtension.of(context);

    return ContentCard(
      speakerMetadata: const {
        'speaker_id': 'system-lexeme-petal',
        'name': 'Kuttiomp Mastery',
        'authority_source': 'elder',
      },
      contentContext: {
        'elderApproved': true,
        'clan_scope': ['kuttiomp_clan'],
        'authority_source': 'elder',
        'fontSize': ext.bodyLarge.fontSize ?? mode?.minimumFontSize ?? 24,
      },
      title: 'Lexemes — ${stage.label}',
      subtitle: '$count words · ${mastery.wordCount} mastered · Next: ${nextStage.label}',
    );
  }
}

MasteryStage _nextStage(MasteryStage current) {
  final stages = MasteryStage.values;
  final index = stages.indexOf(current);
  if (index < 0 || index >= stages.length - 1) return current;
  return stages[index + 1];
}

/// Tappable dashboard petal wrapping mastery display.
class LexemeMasteryPetalCard extends ConsumerWidget {
  const LexemeMasteryPetalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        onTap: () => context.go('/lexemes'),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: LexemeMasteryPetal(),
        ),
      ),
    );
  }
}