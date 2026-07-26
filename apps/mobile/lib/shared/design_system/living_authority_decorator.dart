import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';

/// Protocol 8 – wraps detail content until living authority is acknowledged (§2).
///
/// This serves our people by requiring explicit acknowledgment of elder authority
/// before interaction — a dignity-preserving gate maintainable through 2050.
class LivingAuthorityDecorator extends StatefulWidget {
  const LivingAuthorityDecorator({
    required this.speakerMetadata,
    required this.contentContext,
    required this.child,
    super.key,
  });

  final Map<String, dynamic> speakerMetadata;
  final Map<String, dynamic> contentContext;
  final Widget child;

  @override
  State<LivingAuthorityDecorator> createState() => _LivingAuthorityDecoratorState();
}

class _LivingAuthorityDecoratorState extends State<LivingAuthorityDecorator> {
  bool _acknowledged = false;

  @override
  Widget build(BuildContext context) {
    KuttiompProtocolService.instance.assertCompliant('8', context: widget.contentContext);
    KuttiompProtocolService.instance.assertLivingAuthority(context: widget.contentContext);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthorityBadge(
          speakerMetadata: widget.speakerMetadata,
          contentContext: widget.contentContext,
        ),
        const SizedBox(height: 12),
        if (!_acknowledged)
          Semantics(
            button: true,
            label: 'Acknowledge living authority before continuing',
            child: ElevatedButton(
              onPressed: () => setState(() => _acknowledged = true),
              child: const Text('Acknowledge Authority'),
            ),
          )
        else
          widget.child,
      ],
    );
  }
}