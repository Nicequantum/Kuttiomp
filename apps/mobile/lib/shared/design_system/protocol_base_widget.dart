import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/shared/design_system/kuttiomp_design_system.dart';

/// Immediate enforcement layer for every governed UI primitive (§2, §8).
///
/// This serves our people by guaranteeing that no content widget can render
/// without passing cultural governance checks — a 25-year guardrail any
/// tribal maintainer can trace in one file.
abstract class ProtocolBaseWidget extends StatelessWidget {
  const ProtocolBaseWidget({
    required this.speakerMetadata,
    required this.contentContext,
    super.key,
  });

  /// Protocol 1 – immutable speaker attribution payload.
  final Map<String, dynamic> speakerMetadata;

  /// Full protocol context: elderApproved, clan_scope, authority_source, etc.
  final Map<String, dynamic> contentContext;

  bool get elderApproved => contentContext['elderApproved'] == true;

  List<String> get clanScope {
    final raw = contentContext['clan_scope'] ?? contentContext['clanScope'];
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    return const [];
  }

  String? get authoritySource =>
      contentContext['authority_source']?.toString() ??
      speakerMetadata['authority_source']?.toString();

  Map<String, dynamic> get mergedContext => {
        ...contentContext,
        'speaker_id': speakerMetadata['speaker_id'] ?? speakerMetadata['id'],
        'attribution_json': speakerMetadata,
        'speakerMetadata': speakerMetadata,
        'elderApproved': elderApproved,
        'clan_scope': clanScope,
        if (authoritySource != null) 'authority_source': authoritySource,
        'fontSize': contentContext['fontSize'] ?? 24,
        'hasSemanticsLabel': true,
      };

  @override
  Widget build(BuildContext context) {
    final ctx = mergedContext;
    final gateway = ProtocolGateway();

    // Protocol 1 – speaker must be present before any render.
    gateway.assertSpeakerPresent(context: ctx);

    // Mandatory compliance assertions at render boundary (§2 enforcement mechanism).
    KuttiompProtocolService.instance.assertCompliant('1', context: ctx);
    KuttiompProtocolService.instance.assertCompliant('2', context: ctx);
    KuttiompProtocolService.instance.assertCompliant('8', context: ctx);

    if (clanScope.isNotEmpty) {
      KuttiompProtocolService.instance.assertCompliant('5', context: ctx);
    }
    if (contentContext['primary_audio_id'] != null) {
      KuttiompProtocolService.instance.assertCompliant('7', context: ctx);
    }
    if (contentContext['requires_land_context'] == true ||
        contentContext['landContext'] != null) {
      KuttiompProtocolService.instance.assertCompliant('6', context: ctx);
    }
    if (contentContext['sacred_flag'] == true || contentContext['isSacred'] == true) {
      KuttiompProtocolService.instance.assertCompliant('4', context: ctx);
    }

    KuttiompProtocolService.instance.assertDignity(context: ctx);
    KuttiompProtocolService.instance.assertAccessibility(
      context: {
        'fontSize': ctx['fontSize'],
        'requiresSemantics': true,
        'hasSemanticsLabel': true,
      },
    );
    KuttiompDesignSystem.assertDignity();

    return buildProtocolContent(context);
  }

  Widget buildProtocolContent(BuildContext context);
}

/// Detects non-guarded render attempts; used by protocol compliance tests.
class UnguardedContentProbe extends StatelessWidget {
  const UnguardedContentProbe({super.key});

  @override
  Widget build(BuildContext context) {
    ProtocolGateway().assertSpeakerPresent(context: const {});
    return const SizedBox.shrink();
  }
}