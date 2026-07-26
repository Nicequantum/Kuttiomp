import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/phrases/domain/phrase.dart';
import 'package:kuttiomp_mobile/shared/design_system/geo_context_badge.dart';
import 'package:kuttiomp_mobile/shared/design_system/kuttiomp_content_widget.dart';
import 'package:kuttiomp_mobile/shared/design_system/living_authority_decorator.dart';
import 'package:kuttiomp_mobile/shared/design_system/player.dart';
import 'package:kuttiomp_mobile/shared/design_system/tier_aware_page.dart';
import 'package:kuttiomp_mobile/shared/widgets/approved_content_gate.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';

/// Phrase card – KuttiompContentWidget with full protocol stack (§6, Protocols 1–8).
///
/// This serves our people by making oral primacy and speaker attribution
/// impossible to bypass on any phrase surface through 2050.
class PhraseCard extends KuttiompContentWidget {
  PhraseCard({
    required this.phrase,
    required super.speakerMetadata,
    required Map<String, dynamic> contentContext,
    this.onTap,
    this.onPlayAudio,
    this.showLandBadge = true,
    super.key,
  }) : super(
          elderApproved: contentContext['elderApproved'] == true,
          clanScope: _clanScope(contentContext),
          contentContext: contentContext,
        );

  final PhraseModel phrase;
  final VoidCallback? onTap;
  final VoidCallback? onPlayAudio;
  final bool showLandBadge;

  static List<String> _clanScope(Map<String, dynamic> ctx) {
    final raw = ctx['clan_scope'] ?? ctx['clanScope'];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    return const [];
  }

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
    final ctx = mergedContext;
    final landLabel = phrase.landContext?['label'] as String? ?? 'Narragansett territory';

    return ApprovedContentGate(
      contentContext: ctx,
      builder: (_) => _PhraseTierShell(
        requiredTier: phrase.visibleToTiers,
        child: LivingAuthorityDecorator(
          speakerMetadata: phrase.speakerMetadata,
          contentContext: ctx,
          child: Semantics(
            button: onTap != null,
            label:
                'Phrase ${phrase.phrase}. ${phrase.translation}. Speaker ${phrase.speakerName}',
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
                    border: Border.all(color: ext.landAccent.withValues(alpha: 0.5)),
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
                      const SizedBox(height: 12),
                      OralFirstPlayer(
                        speakerMetadata: speakerMetadata,
                        contentContext: ctx,
                        audioLabel: 'Hear phrase',
                        textContent: phrase.translation,
                        onPlayAudio: onPlayAudio,
                      ),
                      if (showLandBadge && phrase.requiresLandContext) ...[
                        const SizedBox(height: 12),
                        GeoContextBadge(
                          speakerMetadata: speakerMetadata,
                          contentContext: ctx,
                          landLabel: landLabel,
                        ),
                      ],
                      const SizedBox(height: 12),
                      AuthorityBadge(
                        speakerMetadata: speakerMetadata,
                        contentContext: ctx,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhraseTierShell extends TierAwarePage {
  const _PhraseTierShell({required this.child, required super.requiredTier});

  final Widget child;

  @override
  Widget buildTierContent(BuildContext context) => child;
}