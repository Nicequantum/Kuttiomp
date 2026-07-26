import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Protocol 12 – Long-Term Cultural Integrity.
class CulturalIntegrityGuard extends ProtocolGuard {
  CulturalIntegrityGuard(super.protocolService);

  @override
  KuttiompProtocol get protocol => KuttiompProtocol.longTermCulturalIntegrity;

  @override
  void assertCompliant({required dynamic context}) {
    if (context is Map<String, dynamic>) {
      final schemaVersion = context['schema_version'] ?? context['schemaVersion'];
      if (schemaVersion != null && schemaVersion.toString().isEmpty) {
        throw ProtocolViolationException(
          protocol.id,
          respectfulMessage: 'Versioned schema metadata is required.',
        );
      }
    }
  }
}