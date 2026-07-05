import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/tier_aware_page.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/profile/audio_narration_service.dart';
import 'package:kuttiomp_mobile/features/profile/domain/profile_providers.dart';
import 'package:kuttiomp_mobile/modes/content_renderer.dart';

/// Persistent mode selection bottom sheet with long-press descriptions (§13).
class ModeSelectionBottomSheet extends ConsumerStatefulWidget {
  const ModeSelectionBottomSheet({
    required this.onSelect,
    this.withAudioNarration = false,
    this.initialMode = KuttiompMode.littleOnes,
    super.key,
  });

  final Future<void> Function(KuttiompMode mode) onSelect;
  final bool withAudioNarration;
  final KuttiompMode initialMode;

  static Future<void> show(
    BuildContext context, {
    bool withAudioNarration = false,
    KuttiompMode? initialMode,
    Future<void> Function(KuttiompMode mode)? onSelect,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: ModeSelectionBottomSheet(
          withAudioNarration: withAudioNarration,
          initialMode: initialMode ?? KuttiompMode.littleOnes,
          onSelect: onSelect ??
              (mode) async {
                final container = ProviderScope.containerOf(ctx);
                await container.read(modePersistenceServiceProvider).persistAndSyncMode(mode);
              },
        ),
      ),
    );
  }

  @override
  ConsumerState<ModeSelectionBottomSheet> createState() =>
      _ModeSelectionBottomSheetState();
}

class _ModeSelectionBottomSheetState extends ConsumerState<ModeSelectionBottomSheet> {
  late KuttiompMode _selected;
  bool _narrationPlayed = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialMode;
    if (widget.withAudioNarration) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _playNarration());
    }
  }

  Future<void> _playNarration() async {
    setState(() => _narrationPlayed = true);
    await AudioNarrationService.playFirstLaunchWelcome();
  }

  @override
  Widget build(BuildContext context) {
    final ext = KuttiompThemeExtension.forMode(_selected);

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.paddingOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Select Learning Path', style: ext.elderTitle, textAlign: TextAlign.center),
          if (widget.withAudioNarration) ...[
            const SizedBox(height: 8),
            Semantics(
              label: _narrationPlayed ? 'Audio narration played' : 'Playing audio narration',
              child: Text(
                _narrationPlayed
                    ? AudioNarrationService.welcomeScript
                    : 'Preparing audio narration…',
                style: ext.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const SizedBox(height: 16),
          ...KuttiompMode.values.map((mode) {
            return Semantics(
              label: ContentRenderer.longPressDescriptionFor(mode),
              child: RadioListTile<KuttiompMode>(
                title: Text(mode.label, style: ext.bodyLarge),
                subtitle: Text(
                  ContentRenderer.longPressDescriptionFor(mode),
                  style: ext.bodyLarge.copyWith(fontSize: 20),
                ),
                value: mode,
                groupValue: _selected,
                onChanged: (value) {
                  if (value != null) setState(() => _selected = value);
                },
              ),
            );
          }),
          const SizedBox(height: 16),
          Semantics(
            button: true,
            label: 'Save learning path',
            child: ElevatedButton(
              onPressed: () async {
                await widget.onSelect(_selected);
                if (context.mounted) Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, ext.minimumTouchTarget),
              ),
              child: Text('Use ${_selected.label}', style: ext.bodyLarge),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tier-gated wrapper for first-launch onboarding shell (§13).
class ModeSelectionTierShell extends TierAwarePage {
  const ModeSelectionTierShell({required this.child, super.key})
      : super(requiredTier: GenerationalTierBitmask.allTiers);

  final Widget child;

  @override
  Widget buildTierContent(BuildContext context) => child;
}