import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';

/// Base class for all 12 Cultural Governance Protocol guards (§2).
abstract class ProtocolGuard {
  ProtocolGuard(this.protocolService);

  final KuttiompProtocolService protocolService;

  KuttiompProtocol get protocol;

  void assertCompliant({required dynamic context});
}