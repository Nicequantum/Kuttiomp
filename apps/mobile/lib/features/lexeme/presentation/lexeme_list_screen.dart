import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/di/lexeme_providers.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/lexeme/presentation/lexeme_card.dart';
import 'package:kuttiomp_mobile/modes/mode_aware_shell.dart';
import 'package:kuttiomp_mobile/shared/design_system/cards.dart';

/// Protocol-guarded lexeme list with mode adaptation (§6).
///
/// This serves our people by presenting elder-attributed words in the learner's
/// current generational context without duplicating guard logic for 25 years.
class LexemeListScreen extends ConsumerWidget {
  const LexemeListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeControllerProvider).valueOrNull;
    final asyncLexemes = ref.watch(lexemeListProvider);
    final ext = KuttiompThemeExtension.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Lexemes', style: ext.elderTitle)),
      body: ModeAwareShell.forContentList(
        mode: mode,
        surface: 'lexemes_list',
        child: asyncLexemes.when(
          data: (lexemes) {
            if (lexemes.isEmpty) {
              return Center(
                child: ContentCard(
                  speakerMetadata: const {
                    'speaker_id': 'system-lexeme-list',
                    'name': 'Kuttiomp',
                    'authority_source': 'elder',
                  },
                  contentContext: const {
                    'elderApproved': true,
                    'clan_scope': ['kuttiomp_clan'],
                    'authority_source': 'elder',
                  },
                  title: 'No lexemes yet',
                  subtitle: 'Elder-approved words will appear here.',
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: lexemes.length,
              itemBuilder: (context, index) {
                final lexeme = lexemes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: LexemeCard.fromLexeme(
                    lexeme: lexeme,
                    onTap: () => context.go('/lexeme/${lexeme.id}'),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err', style: ext.bodyLarge)),
        ),
      ),
    );
  }
}

/// Backward-compatible alias used by dashboard content_list_screens.
typedef LexemesScreen = LexemeListScreen;