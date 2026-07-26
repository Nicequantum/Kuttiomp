import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/di/phrase_providers.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/phrases/presentation/phrase_card.dart';
import 'package:kuttiomp_mobile/modes/mode_aware_shell.dart';
import 'package:kuttiomp_mobile/shared/design_system/cards.dart';

/// Protocol-guarded phrase list with mode adaptation (§6).
///
/// This serves our people by presenting elder-attributed phrases in the
/// learner's generational context for daily language use through 2050.
class PhrasesListScreen extends ConsumerWidget {
  const PhrasesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeControllerProvider).valueOrNull;
    final asyncPhrases = ref.watch(phraseListProvider);
    final ext = KuttiompThemeExtension.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Phrases', style: ext.elderTitle)),
      body: ModeAwareShell.forContentList(
        mode: mode,
        surface: 'phrases_list',
        child: asyncPhrases.when(
          data: (phrases) {
            if (phrases.isEmpty) {
              return Center(
                child: ContentCard(
                  speakerMetadata: const {
                    'speaker_id': 'system-phrase-list',
                    'name': 'Kuttiomp',
                    'authority_source': 'elder',
                  },
                  contentContext: const {
                    'elderApproved': true,
                    'clan_scope': ['kuttiomp_clan'],
                    'authority_source': 'elder',
                  },
                  title: 'No phrases yet',
                  subtitle: 'Elder-approved phrases will appear here.',
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: phrases.length,
              itemBuilder: (context, index) {
                final phrase = phrases[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PhraseCard.fromPhrase(
                    phrase: phrase,
                    onTap: () => context.go('/phrase/${phrase.id}'),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) =>
              Center(child: Text('Error: $err', style: ext.bodyLarge)),
        ),
      ),
    );
  }
}

/// Backward-compatible alias used by dashboard content_list_screens.
typedef PhrasesScreen = PhrasesListScreen;