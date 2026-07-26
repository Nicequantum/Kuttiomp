import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Protocol 9 – Data Sovereignty & Auditability.
class DataSovereigntyGuard extends ProtocolGuard {
  DataSovereigntyGuard(super.protocolService);

  @override
  KuttiompProtocol get protocol => KuttiompProtocol.dataSovereignty;

  @override
  void assertCompliant({required dynamic context}) {
    if (context is Map<String, dynamic>) {
      final directTable = context['direct_table_access'] == true;
      if (directTable) {
        throw ProtocolViolationException(
          protocol.id,
          respectfulMessage: 'Direct table access is prohibited. Use secure views and RPCs only.',
        );
      }
    }
    if (!protocolService.isInitialized) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'Protocol service must be initialized before data operations.',
      );
    }
  }
}