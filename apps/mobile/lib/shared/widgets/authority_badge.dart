import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/shared/widgets/protocol_base_widget.dart';

/// Protocol 8 – living authority source badge on every detail view.
class AuthorityBadge extends ProtocolBaseWidget {
  const AuthorityBadge({
    required super.speakerMetadata,
    required super.contentContext,
    super.key,
  });

  @override
  Widget buildProtocolContent(BuildContext context) {
    final ext = KuttiompThemeExtension.of(context);
    final source = contentContext['authority_source']?.toString() ?? 'elder';

    return Semantics(
      label: 'Living authority: $source',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: ext.landAccent.withOpacity(0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: ext.landAccent),
        ),
        child: Text(
          'Authority: $source',
          style: ext.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}