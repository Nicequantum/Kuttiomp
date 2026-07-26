import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Protocol 3 – abstract page enforcing generational access tiers (§2).
///
/// This serves our people by silently redirecting under-tier learners away from
/// advanced content — protecting ceremonial readiness across generations for 25 years.
abstract class TierAwarePage extends StatelessWidget {
  const TierAwarePage({
    required this.requiredTier,
    super.key,
  });

  final int requiredTier;

  @override
  Widget build(BuildContext context) {
    try {
      KuttiompProtocolService.instance.assertCompliant(
        '3',
        context: {'visible_to_tiers': requiredTier},
      );
      KuttiompProtocolService.instance.assertTierAccess(
        context: {'visible_to_tiers': requiredTier},
      );
      return buildTierContent(context);
    } on ProtocolViolationException {
      return const Scaffold(
        body: Center(
          child: Text('This content is not available in your current learning path.'),
        ),
      );
    }
  }

  Widget buildTierContent(BuildContext context);
}