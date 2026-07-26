import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Gateway through which all repositories and widgets must pass (§2, §3).
class ProtocolGateway {
  ProtocolGateway({KuttiompProtocolService? protocolService})
      : _protocolService = protocolService ?? KuttiompProtocolService.instance;

  final KuttiompProtocolService _protocolService;

  KuttiompProtocolService get protocolService => _protocolService;

  void assertSpeakerPresent({required dynamic context}) {
    _protocolService.assertSpeakerPresent(context: context);
  }

  void assertCompliant(String protocolId, {required dynamic context}) {
    _protocolService.assertCompliant(protocolId, context: context);
  }

  /// Protocol 2 – elder approval gate (delegates to [KuttiompProtocolService]).
  void assertElderApproved({required dynamic context}) {
    _protocolService.assertElderApproved(context: context);
  }

  void assertAllForContent(Map<String, dynamic> content) {
    for (final protocol in KuttiompProtocol.all) {
      try {
        _protocolService.assertCompliant(protocol.id, context: content);
      } on ProtocolViolationException {
        rethrow;
      }
    }
  }

  /// Validates JWT clan claim against content clan scope (Protocol 5).
  bool isClanPermitted(List<String> clanScope) {
    final userClan = _protocolService.clanId;
    if (userClan == null || userClan.isEmpty) return false;
    if (clanScope.isEmpty) return true;
    return clanScope.contains(userClan);
  }

  /// Appends elder-approved filter parameter for secure queries (Protocol 2).
  Map<String, dynamic> withElderApprovedFilter(Map<String, dynamic> params) {
    return {...params, 'elderApproved': true};
  }
}