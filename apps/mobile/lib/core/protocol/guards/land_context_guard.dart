import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Protocol 6 – Land-Based Contextualization.
class LandContextGuard extends ProtocolGuard {
  LandContextGuard(super.protocolService);

  @override
  KuttiompProtocol get protocol => KuttiompProtocol.landContextualization;

  @override
  void assertCompliant({required dynamic context}) {
    if (context is! Map<String, dynamic>) return;

    final requiresLand = context['requires_land_context'] ?? context['include_land'];
    if (requiresLand != true) return;

    final hasLand = context['land_geometry'] != null ||
        context['seasonal_window'] != null ||
        context['landContext'] != null;

    if (!hasLand) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'Land-based context is required for this content.',
      );
    }
  }
}