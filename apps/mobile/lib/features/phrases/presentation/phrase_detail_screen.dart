import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/di/phrase_providers.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/phrases/domain/phrase.dart';
import 'package:kuttiomp_mobile/features/phrases/presentation/phrase_card.dart';
import 'package:kuttiomp_mobile/shared/design_system/detail_view_shell.dart';
import 'package:kuttiomp_mobile/shared/design_system/geo_context_badge.dart';
import 'package:kuttiomp_mobile/shared/design_system/player.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';
import 'package:kuttiomp_mobile/shared/widgets/sacred_content_locker_widget.dart';

/// Protocol-guarded phrase detail with full guard stack (§6).
///
/// This serves our people by surfacing oral primacy, living authority, and land
/// context on every phrase detail view through 2050.
class PhraseDetailScreen extends ConsumerWidget {
  const PhraseDetailScreen({required this.phraseId, super.key});

  final String phraseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPhrase = ref.watch(phraseDetailProvider(phraseId));
    final ext = KuttiompThemeExtension.of(context);

    return asyncPhrase.when(
      data: (phrase) {
        final ctx = phrase.toContentContext();
        return KuttiompDetailViewShell(
          title: 'Phrase Detail',
          speakerMetadata: phrase.speakerMetadata,
          contentContext: ctx,
          visibleToTiers: phrase.visibleToTiers,
          child: _PhraseDetailBody(phrase: phrase, ext: ext),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        body: Center(child: Text('Error: $err', style: ext.bodyLarge)),
      ),
    );
  }
}

class _PhraseDetailBody extends StatelessWidget {
  const _PhraseDetailBody({required this.phrase, required this.ext});

  final PhraseModel phrase;
  final KuttiompThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    final ctx = phrase.toContentContext();
    final landLabel = phrase.landContext?['label'] as String? ?? 'Narragansett territory';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (phrase.sacredFlag)
          SacredContentLockerWidget(
            recordId: phrase.id,
            isSacred: phrase.sacredFlag,
            contentContext: ctx,
            child: PhraseCard.fromPhrase(phrase: phrase),
          )
        else
          PhraseCard.fromPhrase(phrase: phrase),
        const SizedBox(height: 16),
        OralFirstPlayer(
          speakerMetadata: phrase.speakerMetadata,
          contentContext: ctx,
          audioLabel: 'Hear ${phrase.phrase}',
          textContent: phrase.translation,
        ),
        if (phrase.requiresLandContext) ...[
          const SizedBox(height: 12),
          GeoContextBadge(
            speakerMetadata: phrase.speakerMetadata,
            contentContext: ctx,
            landLabel: landLabel,
          ),
        ],
        const SizedBox(height: 12),
        AuthorityBadge(
          speakerMetadata: phrase.speakerMetadata,
          contentContext: ctx,
        ),
        if (phrase.conversationPrompt != null) ...[
          const SizedBox(height: 12),
          Text(
            'Conversation: ${phrase.conversationPrompt}',
            style: ext.bodyLarge,
          ),
        ],
      ],
    );
  }
}