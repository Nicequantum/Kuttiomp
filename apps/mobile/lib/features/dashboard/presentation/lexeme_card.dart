import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/di/lexeme_providers.dart';
import 'package:kuttiomp_mobile/features/dashboard/presentation/content_section_petal.dart';

/// Dashboard lexeme petal — absolute count (§6). Prefer LexemeMasteryPetalCard on main dash.
class LexemeCard extends ConsumerWidget {
  const LexemeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(lexemeListProvider).valueOrNull?.length ?? 0;

    return ContentSectionPetal(
      title: 'Lexemes',
      subtitle: '$count available (elder-approved)',
      semanticsLabel: 'Lexemes section. $count available. Open list.',
      onTap: () => context.go('/lexemes'),
    );
  }
}