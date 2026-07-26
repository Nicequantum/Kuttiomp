import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Protocol 3 – Generational Access Tiers.
class ModeTierGuard extends ProtocolGuard {
  ModeTierGuard(super.protocolService);

  @override
  KuttiompProtocol get protocol => KuttiompProtocol.generationalAccessTiers;

  @override
  void assertCompliant({required dynamic context}) {
    if (context is! Map<String, dynamic>) return;

    final requiredTier = context['visible_to_tiers'] ?? context['requiredTier'];
    if (requiredTier == null) return;

    final required = requiredTier is int ? requiredTier : int.tryParse('$requiredTier');
    if (required == null) return;

    final current = protocolService.currentTier;
    if ((required & current) == 0) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'This content is not available in your current learning path.',
      );
    }
  }
}