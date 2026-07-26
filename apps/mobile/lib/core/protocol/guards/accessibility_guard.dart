import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Protocol 11 – Accessibility & Elder-Centric Design.
class AccessibilityGuard extends ProtocolGuard {
  AccessibilityGuard(super.protocolService);

  @override
  KuttiompProtocol get protocol => KuttiompProtocol.accessibilityElderCentric;

  @override
  void assertCompliant({required dynamic context}) {
    if (context is! Map<String, dynamic>) return;

    final fontSize = context['fontSize'];
    if (fontSize is num) {
      final minimum = protocolService.currentMode == KuttiompMode.elder ? 32.0 : 24.0;
      if (fontSize < minimum) {
        throw ProtocolViolationException(
          protocol.id,
          respectfulMessage: 'Typography must meet elder-centric minimum size requirements.',
        );
      }
    }

    final hasSemantics = context['hasSemanticsLabel'] == true;
    final requiresSemantics = context['requiresSemantics'] == true;
    if (requiresSemantics && !hasSemantics) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'Voice-first semantics labels are required.',
      );
    }
  }
}