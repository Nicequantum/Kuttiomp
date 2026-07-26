import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Protocol 7 – Oral Tradition Primacy.
class OralTraditionGuard extends ProtocolGuard {
  OralTraditionGuard(super.protocolService);

  @override
  KuttiompProtocol get protocol => KuttiompProtocol.oralTraditionPrimacy;

  @override
  void assertCompliant({required dynamic context}) {
    if (context is! Map<String, dynamic>) return;

    final isTextOnly = context['text_only'] == true;
    if (!isTextOnly) return;

    final audioId = context['primary_audio_id'] ?? context['primaryAudioId'];
    if (audioId == null || audioId.toString().isEmpty) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'Oral tradition requires primary audio for this entry.',
      );
    }
  }
}