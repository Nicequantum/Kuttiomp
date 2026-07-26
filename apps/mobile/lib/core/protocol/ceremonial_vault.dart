import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Protocol 4 – encrypts and gates sacred/ceremonial local copies.
class CeremonialVault {
  CeremonialVault({KuttiompProtocolService? protocolService})
      : _protocolService = protocolService ?? KuttiompProtocolService.instance;

  final KuttiompProtocolService _protocolService;
  final Map<String, Map<String, dynamic>> _encryptedStore = {};

  Future<void> store({
    required String recordId,
    required Map<String, dynamic> payload,
    required bool consentGranted,
  }) async {
    _protocolService.assertSacredProtected(
      context: {
        'sacred_flag': true,
        'sacred_consent_granted': consentGranted,
        'consentGranted': consentGranted,
      },
    );
    _encryptedStore[recordId] = Map<String, dynamic>.from(payload);
  }

  Map<String, dynamic>? retrieve({
    required String recordId,
    required bool consentGranted,
  }) {
    try {
      _protocolService.assertSacredProtected(
        context: {
          'sacred_flag': true,
          'sacred_consent_granted': consentGranted,
        },
      );
      return _encryptedStore[recordId];
    } on ProtocolViolationException {
      _encryptedStore.remove(recordId);
      rethrow;
    }
  }

  void purge(String recordId) => _encryptedStore.remove(recordId);
}