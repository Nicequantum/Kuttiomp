import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Protocol 4 – Sacred/Ceremonial Content Protection.
class SacredContentLocker extends ProtocolGuard {
  SacredContentLocker(super.protocolService);

  @override
  KuttiompProtocol get protocol => KuttiompProtocol.sacredContentProtection;

  @override
  void assertCompliant({required dynamic context}) {
    if (context is! Map<String, dynamic>) return;

    final isSacred = context['sacred_flag'] ?? context['isSacred'];
    if (isSacred != true) return;

    final consentGranted = context['sacred_consent_granted'] ?? context['consentGranted'];
    if (consentGranted != true) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'Sacred content requires ceremonial consent before viewing.',
      );
    }
  }
}