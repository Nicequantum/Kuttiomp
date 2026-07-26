import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/modes/content_renderer.dart';
import 'package:kuttiomp_mobile/shared/design_system/approved_content_gate.dart';
import 'package:kuttiomp_mobile/shared/design_system/living_authority_decorator.dart';
import 'package:kuttiomp_mobile/shared/widgets/mode_tier_guard.dart';

/// Protocol-guarded detail shell for list → detail navigation (§2, §6).
///
/// Riverpod integration example:
/// ```dart
/// ref.watch(lexemeDetailProvider(id)).when(
///   data: (lexeme) => KuttiompDetailViewShell(
///     title: 'Lexeme Detail',
///     speakerMetadata: lexeme.speakerMetadata,
///     contentContext: lexeme.toContentContext(),
///     visibleToTiers: lexeme.visibleToTiers,
///     child: LexemeCard.fromLexeme(lexeme: lexeme),
///   ),
/// );
/// ```
///
/// This serves our people by centralizing detail-route enforcement so every
/// feature module inherits identical guards without copy-paste for 25 years.
class KuttiompDetailViewShell extends ConsumerWidget {
  const KuttiompDetailViewShell({
    required this.title,
    required this.speakerMetadata,
    required this.contentContext,
    required this.visibleToTiers,
    required this.child,
    super.key,
  });

  final String title;
  final Map<String, dynamic> speakerMetadata;
  final Map<String, dynamic> contentContext;
  final int visibleToTiers;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode =
        ref.watch(modeControllerProvider).valueOrNull ?? KuttiompMode.defaultMode;

    // Explicit render-boundary assertions (§2 enforcement mechanism).
    final gateway = ProtocolGateway();
    gateway.assertSpeakerPresent(context: contentContext);
    KuttiompProtocolService.instance.assertCompliant('1', context: contentContext);
    KuttiompProtocolService.instance.assertCompliant('2', context: contentContext);
    KuttiompProtocolService.instance.assertCompliant('8', context: contentContext);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ApprovedContentGate(
        contentContext: contentContext,
        builder: (_) => ModeTierGuard(
          visibleToTiers: visibleToTiers,
          child: ContentRenderer.adaptForMode(
            context: context,
            mode: mode,
            contentContext: contentContext,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: LivingAuthorityDecorator(
                speakerMetadata: speakerMetadata,
                contentContext: contentContext,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}