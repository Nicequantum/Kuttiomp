import 'package:kuttiomp_mobile/core/constants/protocols.dart';

/// Thrown when a Cultural Governance Protocol assertion fails.
class ProtocolViolationException implements Exception {
  ProtocolViolationException(
    this.protocolId, {
    required this.respectfulMessage,
    this.details,
  });

  final String protocolId;
  final String respectfulMessage;
  final String? details;

  KuttiompProtocol? get protocol => KuttiompProtocol.fromId(protocolId);

  @override
  String toString() =>
      'ProtocolViolationException(protocol=$protocolId): $respectfulMessage';
}