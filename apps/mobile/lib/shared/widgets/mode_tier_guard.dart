import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Protocol 3 – generational tier guard wrapper.
class ModeTierGuard extends StatelessWidget {
  const ModeTierGuard({
    required this.visibleToTiers,
    required this.child,
    super.key,
  });

  final int visibleToTiers;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    try {
      KuttiompProtocolService.instance.assertTierAccess(
        context: {'visible_to_tiers': visibleToTiers},
      );
      return child;
    } on ProtocolViolationException {
      return const Scaffold(
        body: Center(
          child: Text('This content is not available in your current learning path.'),
        ),
      );
    }
  }
}