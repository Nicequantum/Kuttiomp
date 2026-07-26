import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Protocol 5 – Clan Visibility Boundaries.
class ClanScopeFilter extends ProtocolGuard {
  ClanScopeFilter(super.protocolService);

  @override
  KuttiompProtocol get protocol => KuttiompProtocol.clanVisibility;

  @override
  void assertCompliant({required dynamic context}) {
    if (context is! Map<String, dynamic>) return;

    final clanScope = context['clan_scope'] ?? context['clanScope'];
    if (clanScope == null) return;

    final scopeList = clanScope is List
        ? clanScope.map((e) => e.toString()).toList()
        : <String>[];

    final userClan = protocolService.clanId;
    if (userClan == null || userClan.isEmpty) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'Not visible in your current path',
      );
    }

    if (scopeList.isNotEmpty && !scopeList.contains(userClan)) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'Not visible in your current path',
      );
    }
  }
}