import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/search/domain/search_result_model.dart';
import 'package:kuttiomp_mobile/shared/design_system/geo_context_badge.dart';
import 'package:kuttiomp_mobile/shared/design_system/kuttiomp_content_widget.dart';
import 'package:kuttiomp_mobile/shared/design_system/player.dart';
import 'package:kuttiomp_mobile/shared/widgets/approved_content_gate.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';

/// Unified search result — oral-first, gated, attributed (Protocols 1,2,4,6,7,8).
///
/// This serves our people by showing words, phrases, and lessons under the same
/// cultural gates in search as on detail routes through 2050.
class SearchResultCard extends KuttiompContentWidget {
  SearchResultCard({
    required this.result,
    required super.speakerMetadata,
    required Map<String, dynamic> contentContext,
    this.onTap,
    super.key,
  }) : super(
          elderApproved: contentContext['elderApproved'] == true,
          clanScope: _clanScope(contentContext),
          contentContext: contentContext,
        );

  final SearchResultModel result;
  final VoidCallback? onTap;

  static List<String> _clanScope(Map<String, dynamic> ctx) {
    final raw = ctx['clan_scope'] ?? ctx['clanScope'];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    return const [];
  }

  factory SearchResultCard.fromResult({
    required SearchResultModel result,
    VoidCallback? onTap,
    Key? key,
  }) {
    return SearchResultCard(
      key: key,
      result: result,
      speakerMetadata: result.speakerMetadata,
      contentContext: result.toContentContext(),
      onTap: onTap,
    );
  }

  @override
  Widget buildProtocolContent(BuildContext context) {
    final ext = KuttiompThemeExtension.of(context);
    final ctx = mergedContext;

    // Unapproved never surfaces in search UI (Protocol 2).
    if (!result.elderApproved) {
      return const SizedBox.shrink();
    }

    return ApprovedContentGate(
      contentContext: ctx,
      builder: (_) => Semantics(
        button: onTap != null,
        label:
            '${result.contentType.label}: ${result.title}. ${result.subtitle}. '
            'Speaker ${speakerMetadata['name']}',
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
                  Row(
                    children: [
                      _TypeBadge(type: result.contentType, ext: ext),
                      if (result.requiresSacredGate) ...[
                        const SizedBox(width: 8),
                        _SacredBadge(ext: ext),
                      ],
                      const Spacer(),
                      Text(
                        'Stage: ${result.canonicalStage}',
                        style: ext.bodyLarge.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(result.title, style: ext.elderTitle.copyWith(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(result.subtitle, style: ext.bodyLarge),
                  const SizedBox(height: 12),
                  OralFirstPlayer(
                    speakerMetadata: speakerMetadata,
                    contentContext: ctx,
                    audioLabel: 'Hear ${result.title}',
                  ),
                  if (result.requiresLandContext) ...[
                    const SizedBox(height: 12),
                    GeoContextBadge(
                      speakerMetadata: speakerMetadata,
                      contentContext: ctx,
                      landLabel: result.landContext?['label'] as String? ??
                          'Narragansett territory',
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
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type, required this.ext});

  final SearchContentType type;
  final KuttiompThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ext.landAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ext.landAccent),
      ),
      child: Text(
        type.label,
        style: ext.bodyLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }
}

class _SacredBadge extends StatelessWidget {
  const _SacredBadge({required this.ext});

  final KuttiompThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ext.barkPrimary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ext.barkPrimary),
      ),
      child: Text(
        'Sacred',
        style: ext.bodyLarge.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}