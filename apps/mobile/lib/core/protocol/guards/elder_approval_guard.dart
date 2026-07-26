import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Protocol 2 – Elder Approval Workflows.
class ElderApprovalGuard extends ProtocolGuard {
  ElderApprovalGuard(super.protocolService);

  @override
  KuttiompProtocol get protocol => KuttiompProtocol.elderApproval;

  @override
  void assertCompliant({required dynamic context}) {
    if (context is! Map<String, dynamic>) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'Content pending elder review',
      );
    }
    final approved = context['elderApproved'] ?? context['elder_approved'];
    if (approved != true) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'Content pending elder review',
      );
    }
  }
}