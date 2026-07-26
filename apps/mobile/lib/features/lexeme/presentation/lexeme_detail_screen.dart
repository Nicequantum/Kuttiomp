import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/di/lexeme_providers.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';
import 'package:kuttiomp_mobile/features/lexeme/presentation/lexeme_card.dart';
import 'package:kuttiomp_mobile/shared/design_system/detail_view_shell.dart';
import 'package:kuttiomp_mobile/shared/design_system/geo_context_badge.dart';
import 'package:kuttiomp_mobile/shared/design_system/player.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';
import 'package:kuttiomp_mobile/shared/widgets/sacred_content_locker_widget.dart';

/// Protocol-guarded lexeme detail with full guard stack (§6).
///
/// This serves our people by surfacing oral primacy, living authority, and land
/// context on every word detail view through 2050.
class LexemeDetailScreen extends ConsumerWidget {
  const LexemeDetailScreen({required this.lexemeId, super.key});

  final String lexemeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLexeme = ref.watch(lexemeDetailProvider(lexemeId));
    final ext = KuttiompThemeExtension.of(context);

    return asyncLexeme.when(
      data: (lexeme) {
        final ctx = lexeme.toContentContext();
        return KuttiompDetailViewShell(
          title: 'Lexeme Detail',
          speakerMetadata: lexeme.speakerMetadata,
          contentContext: ctx,
          visibleToTiers: lexeme.visibleToTiers,
          child: _LexemeDetailBody(lexeme: lexeme, ext: ext),
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

/// Detail body composing governed card + explicit protocol widgets.
class _LexemeDetailBody extends StatelessWidget {
  const _LexemeDetailBody({required this.lexeme, required this.ext});

  final LexemeModel lexeme;
  final KuttiompThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    final ctx = lexeme.toContentContext();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (lexeme.sacredFlag)
          SacredContentLockerWidget(
            recordId: lexeme.id,
            isSacred: lexeme.sacredFlag,
            contentContext: ctx,
            child: LexemeCard.fromLexeme(lexeme: lexeme),
          )
        else
          LexemeCard.fromLexeme(lexeme: lexeme),
        const SizedBox(height: 16),
        OralFirstPlayer(
          speakerMetadata: lexeme.speakerMetadata,
          contentContext: ctx,
          audioLabel: 'Hear ${lexeme.word}',
          textContent: lexeme.translation,
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
          speakerMetadata: lexeme.speakerMetadata,
          contentContext: ctx,
        ),
        const SizedBox(height: 8),
        Text(
          'Stage: ${lexeme.masteryStage.label}',
          style: ext.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}