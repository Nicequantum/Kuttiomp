import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Protocol 1 – Speaker Attribution.
class SpeakerAttributionGuard extends ProtocolGuard {
  SpeakerAttributionGuard(super.protocolService);

  @override
  KuttiompProtocol get protocol => KuttiompProtocol.speakerAttribution;

  @override
  void assertCompliant({required dynamic context}) {
    if (context is! Map<String, dynamic>) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'Speaker attribution requires content context.',
      );
    }
    final speakerId = context['speaker_id'] ?? context['speakerId'];
    final attribution = context['attribution_json'] ?? context['speakerMetadata'];
    if (speakerId == null || speakerId.toString().isEmpty) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'Content must carry speaker attribution.',
      );
    }
    if (attribution == null) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'Speaker metadata is required for all content.',
      );
    }
  }
}