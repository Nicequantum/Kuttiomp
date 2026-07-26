import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';

/// Protocol 5 – clan visibility gate for governed content surfaces.
class ClanBoundView extends StatelessWidget {
  const ClanBoundView({
    required this.clanScope,
    required this.child,
    super.key,
  });

  final List<String> clanScope;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final permitted = ProtocolGateway().isClanPermitted(clanScope);
    if (permitted) return child;

    final ext = KuttiompThemeExtension.of(context);
    return Semantics(
      label: 'Content not visible for your clan',
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'This content is not available for your clan.',
          style: ext.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}