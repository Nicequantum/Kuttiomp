import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/di/lexeme_providers.dart';

/// Dashboard lexeme section petal — navigates to lexeme list (§6).
class LexemeCard extends ConsumerWidget {
  const LexemeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(lexemeListProvider).valueOrNull?.length ?? 0;

    return Card(
      child: ListTile(
        title: const Text('Lexemes'),
        subtitle: Text('$count available'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () => context.go('/lexemes'),
      ),
    );
  }
}