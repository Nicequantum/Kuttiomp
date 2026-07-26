import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';
import 'package:kuttiomp_mobile/modes/mode_persistence.dart';

/// GoRouter redirect enforcing Protocol 3 tiers and first-launch flow (§5, §13).
///
/// This serves our people by silently protecting under-tier navigation while
/// preserving first-launch guided selection for our youngest learners.
class ModeRedirectMiddleware {
  ModeRedirectMiddleware({
    required this.persistence,
    this.protocolService,
  });

  final ModePersistence persistence;
  final KuttiompProtocolService? protocolService;

  KuttiompProtocolService get _service =>
      protocolService ?? KuttiompProtocolService.instance;

  String? redirect(BuildContext context, GoRouterState state) {
    final path = state.uri.path;

    if (!persistence.isFirstLaunchComplete && path != '/first-launch') {
      return '/first-launch';
    }

    if (persistence.isFirstLaunchComplete && path == '/first-launch') {
      return '/dashboard';
    }

    try {
      _service.assertTierAccess(
        context: {'visible_to_tiers': _service.currentMode.tierBitmask},
      );
      _service.assertElderApproved(
        context: const {'elderApproved': true},
      );
    } on ProtocolViolationException {
      return '/dashboard';
    }

    return null;
  }
}