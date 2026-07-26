import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Protocol 2 – elder approval gate for every async/detail render path (§2).
///
/// This serves our people by blocking unreviewed content at the UI boundary,
/// preserving elder authority even when repository caches are stale for 25 years.
class ApprovedContentGate extends StatelessWidget {
  const ApprovedContentGate({
    required this.contentContext,
    required this.builder,
    this.loading,
    super.key,
  });

  final Map<String, dynamic> contentContext;
  final Widget Function(BuildContext context) builder;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    try {
      KuttiompProtocolService.instance.assertCompliant('2', context: contentContext);
      KuttiompProtocolService.instance.assertElderApproved(context: contentContext);
      return builder(context);
    } on ProtocolViolationException catch (e) {
      return _RespectfulBlockedView(message: e.respectfulMessage);
    }
  }
}

class _RespectfulBlockedView extends StatelessWidget {
  const _RespectfulBlockedView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: message,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}