import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Protocol 8 – Living Authority Supremacy.
class LivingAuthorityGuard extends ProtocolGuard {
  LivingAuthorityGuard(super.protocolService);

  @override
  KuttiompProtocol get protocol => KuttiompProtocol.livingAuthoritySupremacy;

  @override
  void assertCompliant({required dynamic context}) {
    if (context is! Map<String, dynamic>) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'Living authority source must be acknowledged.',
      );
    }

    final authority = context['authority_source'] ?? context['authoritySource'];
    if (authority == null || authority.toString().isEmpty) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'Living authority source must be acknowledged.',
      );
    }
  }
}