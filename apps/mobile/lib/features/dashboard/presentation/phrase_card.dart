import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/di/phrase_providers.dart';

/// Dashboard phrase section petal — navigates to phrase list (§6).
class PhraseCard extends ConsumerWidget {
  const PhraseCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(phraseListProvider).valueOrNull?.length ?? 0;

    return Card(
      child: ListTile(
        title: const Text('Phrases'),
        subtitle: Text('$count available'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () => context.go('/phrases'),
      ),
    );
  }
}