import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';

/// Protocol 1 implementing service – all content cards/players must extend this.
abstract class AttributionRenderer extends StatelessWidget {
  const AttributionRenderer({
    required this.speakerMetadata,
    super.key,
  });

  final Map<String, dynamic> speakerMetadata;

  @override
  Widget build(BuildContext context) {
    ProtocolGateway().assertSpeakerPresent(
      context: {
        'speaker_id': speakerMetadata['speaker_id'] ?? speakerMetadata['id'],
        'attribution_json': speakerMetadata,
        'speakerMetadata': speakerMetadata,
      },
    );
    return buildAttributedContent(context);
  }

  Widget buildAttributedContent(BuildContext context);
}