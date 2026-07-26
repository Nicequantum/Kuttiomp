import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/shared/design_system/protocol_base_widget.dart';

/// Protocol 6 – land-based contextualization badge (§2, §8).
///
/// This serves our people by anchoring every word to Narragansett territory,
/// keeping land relationship visible across device generations through 2050.
class GeoContextBadge extends ProtocolBaseWidget {
  const GeoContextBadge({
    required super.speakerMetadata,
    required super.contentContext,
    this.landLabel = 'Narragansett territory',
    super.key,
  });

  final String landLabel;

  @override
  Widget buildProtocolContent(BuildContext context) {
    KuttiompProtocolService.instance.assertCompliant(
      '6',
      context: {
        ...contentContext,
        'requires_land_context': contentContext['requires_land_context'] ?? true,
        'landContext': contentContext['landContext'] ?? landLabel,
      },
    );
    KuttiompProtocolService.instance.assertLandContext(
      context: {
        ...contentContext,
        'requires_land_context': contentContext['requires_land_context'] ?? true,
        'landContext': contentContext['landContext'] ?? landLabel,
      },
    );

    final ext = KuttiompThemeExtension.of(context);
    return Semantics(
      label: 'Land context: $landLabel',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.landscape, color: ext.landAccent, size: 20),
          const SizedBox(width: 6),
          Flexible(child: Text(landLabel, style: ext.bodyLarge)),
        ],
      ),
    );
  }
}