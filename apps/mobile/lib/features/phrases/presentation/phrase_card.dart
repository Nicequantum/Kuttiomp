import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/phrases/domain/phrase.dart';
import 'package:kuttiomp_mobile/shared/design_system/oral_first_player.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';
import 'package:kuttiomp_mobile/shared/widgets/geo_context_badge.dart';
import 'package:kuttiomp_mobile/shared/widgets/protocol_base_widget.dart';

/// Tappable phrase card – oral-first, land-contextualized, attributed (Protocols 1,6,7,8).
///
/// Tribal Maintainer Guide (Protocol 12): modify guards via list/detail in dashboard; search `PhraseCard`.
class PhraseCard extends ProtocolBaseWidget {
  const PhraseCard({
    required this.phrase,
    required super.speakerMetadata,
    required super.contentContext,
    this.onTap,
    this.onPlayAudio,
    this.showLandBadge = true,
    super.key,
  });

  final PhraseModel phrase;
  final VoidCallback? onTap;
  final VoidCallback? onPlayAudio;
  final bool showLandBadge;

  factory PhraseCard.fromPhrase({
    required PhraseModel phrase,
    VoidCallback? onTap,
    VoidCallback? onPlayAudio,
    bool showLandBadge = true,
    Key? key,
  }) {
    return PhraseCard(
      key: key,
      phrase: phrase,
      speakerMetadata: phrase.speakerMetadata,
      contentContext: phrase.toContentContext(),
      onTap: onTap,
      onPlayAudio: onPlayAudio,
      showLandBadge: showLandBadge,
    );
  }

  @override
  Widget buildProtocolContent(BuildContext context) {
    final ext = KuttiompThemeExtension.of(context);
    final landLabel = phrase.landContext?['label'] as String? ?? 'Narragansett territory';

    return Semantics(
      button: onTap != null,
      label: 'Phrase ${phrase.phrase}. ${phrase.translation}. Speaker ${phrase.speakerName}',
      child: Material(
        color: ext.surfaceMist,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ext.landAccent.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (phrase.conversationPrompt != null) ...[
                  Text(
                    phrase.conversationPrompt!,
                    style: ext.bodyLarge.copyWith(
                      fontStyle: FontStyle.italic,
                      color: ext.landAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(phrase.phrase, style: ext.elderTitle),
                const SizedBox(height: 4),
                Text(phrase.translation, style: ext.bodyLarge),
                if (showLandBadge && phrase.requiresLandContext) ...[
                  const SizedBox(height: 12),
                  GeoContextBadge(
                    speakerMetadata: speakerMetadata,
                    contentContext: contentContext,
                    landLabel: landLabel,
                  ),
                ],
                const SizedBox(height: 12),
                OralFirstPlayer(
                  speakerMetadata: speakerMetadata,
                  contentContext: contentContext,
                  audioLabel: 'Hear phrase',
                  textContent: phrase.translation,
                  onPlayAudio: onPlayAudio,
                ),
                const SizedBox(height: 12),
                AuthorityBadge(
                  speakerMetadata: speakerMetadata,
                  contentContext: contentContext,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}