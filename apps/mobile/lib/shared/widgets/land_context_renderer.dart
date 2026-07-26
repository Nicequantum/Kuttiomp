import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';
import 'package:kuttiomp_mobile/shared/widgets/geo_context_badge.dart';

/// Protocol 6 – mandatory land overlay when geo context is present.
class LandContextRenderer extends StatelessWidget {
  const LandContextRenderer({
    required this.lexeme,
    required this.child,
    super.key,
  });

  final LexemeModel lexeme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ctx = lexeme.toContentContext();
    final label = lexeme.geoContext?.label ?? 'Narragansett territory';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (lexeme.hasGeoContext) ...[
          GeoContextBadge(
            speakerMetadata: lexeme.speakerMetadata,
            contentContext: {
              ...ctx,
              'requires_land_context': true,
              'land_geometry': lexeme.geoContext?.toJson(),
              'landContext': label,
            },
            landLabel: label,
          ),
          const SizedBox(height: 12),
        ],
        child,
      ],
    );
  }
}