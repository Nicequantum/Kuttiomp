import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/di/phrase_providers.dart';
import 'package:kuttiomp_mobile/features/dashboard/presentation/content_section_petal.dart';

/// Dashboard phrase petal — absolute count, navigates to phrase list (§6).
class PhraseCard extends ConsumerWidget {
  const PhraseCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(phraseListProvider).valueOrNull?.length ?? 0;

    return ContentSectionPetal(
      title: 'Phrases',
      subtitle: '$count available (elder-approved)',
      semanticsLabel: 'Phrases section. $count available. Open list.',
      onTap: () => context.go('/phrases'),
    );
  }
}