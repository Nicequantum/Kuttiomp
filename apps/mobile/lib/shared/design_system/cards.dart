import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/shared/design_system/kuttiomp_content_widget.dart';
import 'package:kuttiomp_mobile/shared/design_system/kuttiomp_design_system.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';

List<String> _clanScopeFromContext(Map<String, dynamic> contentContext) {
  final clanRaw = contentContext['clan_scope'] ?? contentContext['clanScope'];
  if (clanRaw is List) {
    return clanRaw.map((e) => e.toString()).toList();
  }
  return const [];
}

/// Content card with mandatory speaker attribution (Protocols 1 & 8 – §8).
///
/// This serves our people by surfacing living authority on every card surface,
/// making elder attribution impossible to omit during future feature work.
class ContentCard extends KuttiompContentWidget {
  ContentCard({
    required super.speakerMetadata,
    required Map<String, dynamic> contentContext,
    required this.title,
    this.subtitle,
    bool? elderApproved,
    List<String>? clanScope,
    super.key,
  }) : super(
          elderApproved: elderApproved ?? contentContext['elderApproved'] == true,
          clanScope: clanScope ?? _clanScopeFromContext(contentContext),
          contentContext: contentContext,
        );

  final String title;
  final String? subtitle;

  @override
  Widget buildProtocolContent(BuildContext context) {
    final ext = KuttiompThemeExtension.of(context);
    KuttiompDesignSystem.assertDignity();

    return Semantics(
      label: '$title. Speaker: ${speakerMetadata['name'] ?? 'attributed'}',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: KuttiompDesignSystem.landAccentBorder(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: ext.elderTitle),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!, style: ext.bodyLarge),
            ],
            const SizedBox(height: 12),
            AuthorityBadge(
              speakerMetadata: speakerMetadata,
              contentContext: mergedContext,
            ),
          ],
        ),
      ),
    );
  }
}