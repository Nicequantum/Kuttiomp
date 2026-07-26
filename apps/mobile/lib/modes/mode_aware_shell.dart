import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/modes/content_renderer.dart';
import 'package:kuttiomp_mobile/shared/widgets/mode_tier_guard.dart';

/// Wraps dashboard, list, and petal surfaces with tier guard + mode adaptation (§5).
///
/// This serves our people by ensuring every screen respects generational access
/// and mode-specific presentation without duplicating guard logic for 25 years.
class ModeAwareShell extends ConsumerWidget {
  const ModeAwareShell({
    required this.child,
    required this.visibleToTiers,
    this.contentContext,
    super.key,
  });

  final Widget child;
  final int visibleToTiers;
  final Map<String, dynamic>? contentContext;

  /// System context for dashboard and navigation surfaces.
  factory ModeAwareShell.forDashboard({
    required Widget child,
    KuttiompMode? mode,
    Key? key,
  }) {
    final resolved = mode ?? KuttiompMode.defaultMode;
    return ModeAwareShell(
      key: key,
      visibleToTiers: resolved.tierBitmask,
      contentContext: _systemContext(
        surface: 'dashboard',
        tier: resolved.tierBitmask,
        fontSize: resolved.minimumFontSize,
      ),
      child: child,
    );
  }

  /// System context for content list screens (lexemes, phrases, lessons).
  factory ModeAwareShell.forContentList({
    required Widget child,
    KuttiompMode? mode,
    String surface = 'content_list',
    Key? key,
  }) {
    final resolved = mode ?? KuttiompMode.defaultMode;
    return ModeAwareShell(
      key: key,
      visibleToTiers: GenerationalTierBitmask.allTiers,
      contentContext: _systemContext(
        surface: surface,
        tier: GenerationalTierBitmask.allTiers,
        fontSize: resolved.minimumFontSize,
      ),
      child: child,
    );
  }

  static Map<String, dynamic> _systemContext({
    required String surface,
    required int tier,
    required double fontSize,
  }) {
    return {
      'elderApproved': true,
      'visible_to_tiers': tier,
      'speaker_id': 'system-$surface',
      'attribution_json': {'speaker_id': 'system-$surface', 'name': 'Kuttiomp'},
      'authority_source': 'kuttiomp_architect',
      'schema_version': '2.0',
      'fontSize': fontSize,
      'hasSemanticsLabel': true,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode =
        ref.watch(modeControllerProvider).valueOrNull ?? KuttiompMode.defaultMode;
    final ctx = contentContext ??
        _systemContext(
          surface: 'mode_shell',
          tier: visibleToTiers,
          fontSize: mode.minimumFontSize,
        );

    // SizedBox.expand tightens height so mode strategies + ListView get bounds.
    return ModeTierGuard(
      visibleToTiers: visibleToTiers,
      child: SizedBox.expand(
        child: ContentRenderer.adaptForMode(
          context: context,
          mode: mode,
          contentContext: ctx,
          child: child,
        ),
      ),
    );
  }
}