import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/profile/audio_narration_service.dart';
import 'package:kuttiomp_mobile/features/profile/domain/profile_providers.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/mode_selection_bottom_sheet.dart';
import 'package:kuttiomp_mobile/modes/content_renderer.dart';

/// Bottom navigation shell with long-press mode narration (§13).
///
/// This serves our people by making mode selection audible and dignified for
/// elders while preserving StatefulShellRoute scroll state for 25 years.
class ModeShellScaffold extends ConsumerWidget {
  const ModeShellScaffold({
    required this.navigationShell,
    required this.bootstrapStatus,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final String bootstrapStatus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeControllerProvider).valueOrNull ?? KuttiompMode.littleOnes;
    final ext = KuttiompThemeExtension.of(context);
    final router = GoRouter.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Kuttiomp', style: ext.elderTitle.copyWith(fontSize: 22)),
        actions: [
          Semantics(
            label: 'Open global search',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search the living corpus',
              onPressed: () => context.push('/search'),
            ),
          ),
          Semantics(
            label: 'Open profile settings',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.person_outline),
              tooltip: 'Your profile',
              onPressed: () => context.push('/profile'),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Semantics(
              label: 'Search words, phrases, and lessons',
              button: true,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.push('/search'),
                child: IgnorePointer(
                  child: TextField(
                    style: ext.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Search the living corpus…',
                      hintStyle: ext.bodyLarge.copyWith(
                        color: ext.bodyLarge.color?.withValues(alpha: 0.6),
                      ),
                      prefixIcon: Icon(Icons.search, color: ext.landAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: ext.landAccent.withValues(alpha: 0.5)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: [
          NavigationDestination(
            icon: _ModeNavIcon(mode: mode, selected: false),
            selectedIcon: _ModeNavIcon(mode: mode, selected: true),
            label: mode.label,
          ),
        ],
      ),
      floatingActionButton: Semantics(
        button: true,
        label:
            'Switch learning mode. Long press for audio narration of all modes.',
        child: FloatingActionButton.extended(
          onPressed: () async {
            final modes = KuttiompMode.values;
            final current = ref.read(modeControllerProvider).valueOrNull ?? KuttiompMode.littleOnes;
            final next = modes[(modes.indexOf(current) + 1) % modes.length];
            await ref.read(modePersistenceServiceProvider).persistAndSyncMode(next, router: router);
          },
          onLongPress: () {
            AudioNarrationService.playFirstLaunchWelcome();
            ModeSelectionBottomSheet.show(
              context,
              withAudioNarration: true,
              initialMode: mode,
              onSelect: (selected) => ref
                  .read(modePersistenceServiceProvider)
                  .persistAndSyncMode(selected, router: router),
            );
          },
          label: Text('Switch Mode', style: ext.bodyLarge.copyWith(color: Colors.white)),
          icon: const Icon(Icons.swap_horiz),
        ),
      ),
    );
  }
}

/// Long-press tooltip target for mode narration (§13).
class _ModeNavIcon extends StatelessWidget {
  const _ModeNavIcon({required this.mode, required this.selected});

  final KuttiompMode mode;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: ContentRenderer.longPressDescriptionFor(mode),
      child: Icon(selected ? Icons.home : Icons.home_outlined),
    );
  }
}