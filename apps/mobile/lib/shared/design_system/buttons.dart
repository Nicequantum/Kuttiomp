import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/shared/design_system/kuttiomp_content_widget.dart';

List<String> _clanScopeFromContext(Map<String, dynamic> contentContext) {
  final clanRaw = contentContext['clan_scope'] ?? contentContext['clanScope'];
  if (clanRaw is List) {
    return clanRaw.map((e) => e.toString()).toList();
  }
  return const [];
}

/// Dignified primary action button (Protocols 1, 8, 10, 11 – §8).
///
/// This serves our people by providing large, Semantics-labeled touch targets
/// that respect elders and youth equally across four modes for 25 years.
class KuttiompButton extends KuttiompContentWidget {
  KuttiompButton({
    required super.speakerMetadata,
    required Map<String, dynamic> contentContext,
    required this.label,
    required this.onPressed,
    this.semanticsLabel,
    bool? elderApproved,
    List<String>? clanScope,
    super.key,
  }) : super(
          elderApproved: elderApproved ?? contentContext['elderApproved'] == true,
          clanScope: clanScope ?? _clanScopeFromContext(contentContext),
          contentContext: contentContext,
        );

  final String label;
  final VoidCallback? onPressed;
  final String? semanticsLabel;

  @override
  Widget buildProtocolContent(BuildContext context) {
    final ext = KuttiompThemeExtension.of(context);
    final minHeight = ext.minimumTouchTarget;

    return Semantics(
      button: true,
      label: semanticsLabel ?? label,
      child: SizedBox(
        height: minHeight,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: ext.barkPrimary,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, minHeight),
            textStyle: ext.bodyLarge,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}