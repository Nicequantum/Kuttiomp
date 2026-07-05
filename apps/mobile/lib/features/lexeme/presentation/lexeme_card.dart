import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/tier_aware_page.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';
import 'package:kuttiomp_mobile/shared/design_system/oral_first_player.dart';
import 'package:kuttiomp_mobile/shared/widgets/approved_content_gate.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';
import 'package:kuttiomp_mobile/shared/widgets/geo_context_badge.dart';
import 'package:kuttiomp_mobile/shared/widgets/land_context_renderer.dart';
import 'package:kuttiomp_mobile/shared/widgets/living_authority_decorator.dart';
import 'package:kuttiomp_mobile/shared/widgets/protocol_base_widget.dart';

/// Tappable lexeme card – oral-first, attributed, protocol-gated (Protocols 1,2,3,6,7,8).
///
/// Tribal Maintainer Guide (Protocol 12): modify guards here; search `ApprovedContentGate`.
class LexemeCard extends ProtocolBaseWidget {
  const LexemeCard({
    required this.lexeme,
    required super.speakerMetadata,
    required super.contentContext,
    this.onTap,
    this.onPlayAudio,
    super.key,
  });

  final LexemeModel lexeme;
  final VoidCallback? onTap;
  final VoidCallback? onPlayAudio;

  factory LexemeCard.fromLexeme({
    required LexemeModel lexeme,
    VoidCallback? onTap,
    VoidCallback? onPlayAudio,
    Key? key,
  }) {
    return LexemeCard(
      key: key,
      lexeme: lexeme,
      speakerMetadata: lexeme.speakerMetadata,
      contentContext: lexeme.toContentContext(),
      onTap: onTap,
      onPlayAudio: onPlayAudio,
    );
  }

  @override
  Widget buildProtocolContent(BuildContext context) {
    final ext = KuttiompThemeExtension.of(context);
    final ctx = lexeme.toContentContext();

    return ApprovedContentGate(
      contentContext: ctx,
      builder: (_) => _LexemeTierShell(
        requiredTier: lexeme.visibleToTiers,
        child: LivingAuthorityDecorator(
          speakerMetadata: lexeme.speakerMetadata,
          contentContext: ctx,
          child: LandContextRenderer(
            lexeme: lexeme,
            child: Semantics(
              button: onTap != null,
              label: 'Lexeme ${lexeme.word}. ${lexeme.translation}. Speaker ${lexeme.speakerName}',
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
                        Text(lexeme.word, style: ext.elderTitle),
                        const SizedBox(height: 4),
                        Text(lexeme.translation, style: ext.bodyLarge),
                        const SizedBox(height: 12),
                        OralFirstPlayer(
                          speakerMetadata: speakerMetadata,
                          contentContext: contentContext,
                          audioLabel: 'Hear ${lexeme.word}',
                          textContent: lexeme.translation,
                          onPlayAudio: onPlayAudio,
                        ),
                        if (lexeme.hasGeoContext) ...[
                          const SizedBox(height: 12),
                          GeoContextBadge(
                            speakerMetadata: lexeme.speakerMetadata,
                            contentContext: ctx,
                            landLabel: lexeme.landContextGeo ?? 'Narragansett territory',
                          ),
                        ],
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
            ),
          ),
        ),
      ),
    );
  }
}

class _LexemeTierShell extends TierAwarePage {
  const _LexemeTierShell({required this.child, required super.requiredTier});

  final Widget child;

  @override
  Widget buildTierContent(BuildContext context) => child;
}