import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/dashboard/presentation/dashboard_screen.dart';
import 'package:kuttiomp_mobile/modes/content_renderer.dart';
import 'package:kuttiomp_mobile/modes/elder/accessibility_overlay.dart';
import 'package:kuttiomp_mobile/shared/design_system/buttons.dart';
import 'package:kuttiomp_mobile/shared/design_system/cards.dart';
import 'package:kuttiomp_mobile/shared/design_system/player.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';

import '../helpers/kuttiomp_test_harness.dart';

void main() {
  final speaker = {
    'speaker_id': 'grandmother-comus',
    'name': 'Grandmother Comus',
    'authority_source': 'elder',
  };

  final contentContext = {
    'elderApproved': true,
    'authority_source': 'elder',
    'speaker_id': 'grandmother-comus',
    'clan_scope': ['kuttiomp_clan'],
    'primary_audio_id': 'audio-001',
    'fontSize': 24,
    'visible_to_tiers': GenerationalTierBitmask.allTiers,
  };

  setUp(() async {
    await KuttiompTestHarness.initProtocol(mode: KuttiompMode.coreAdult);
  });

  Widget wrapMode(KuttiompMode mode, Widget child) {
    return MaterialApp(
      theme: KuttiompTheme.forMode(mode),
      home: Scaffold(
        body: ElderModeOverlay(mode: mode, child: child),
      ),
    );
  }

  for (final mode in KuttiompMode.values) {
    group('Mode consistency – ${mode.label}', () {
      testWidgets('KuttiompThemeExtension meets minimum font size', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: KuttiompTheme.forMode(mode),
            home: Builder(
              builder: (context) {
                final ext = KuttiompThemeExtension.of(context);
                expect(ext.bodyLarge.fontSize, greaterThanOrEqualTo(mode.minimumFontSize));
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('ContentRenderer strategy resolves for mode', (tester) async {
        expect(ContentRenderer.strategyFor(mode).mode, mode);
        expect(ContentRenderer.longPressDescriptionFor(mode), isNotEmpty);
      });

      testWidgets('AuthorityBadge renders with dignity', (tester) async {
        await tester.pumpWidget(
          wrapMode(
            mode,
            AuthorityBadge(
              speakerMetadata: speaker,
              contentContext: {...contentContext, 'fontSize': mode.minimumFontSize},
            ),
          ),
        );
        expect(find.textContaining('Authority:'), findsOneWidget);
      });

      testWidgets('ContentCard renders attributed content', (tester) async {
        await tester.pumpWidget(
          wrapMode(
            mode,
            ContentCard(
              speakerMetadata: speaker,
              contentContext: contentContext,
              title: 'Wunnegan',
              subtitle: 'Greeting',
            ),
          ),
        );
        expect(find.text('Wunnegan'), findsOneWidget);
      });

      testWidgets('KuttiompButton meets touch target', (tester) async {
        await tester.pumpWidget(
          wrapMode(
            mode,
            KuttiompButton(
              speakerMetadata: speaker,
              contentContext: contentContext,
              label: 'Listen',
              onPressed: () {},
            ),
          ),
        );
        expect(find.text('Listen'), findsOneWidget);
      });

      testWidgets('OralFirstPlayer defaults to audio primary', (tester) async {
        await tester.pumpWidget(
          wrapMode(
            mode,
            OralFirstPlayer(
              speakerMetadata: speaker,
              contentContext: contentContext,
              audioLabel: 'Hear the word',
              textContent: 'Optional text',
            ),
          ),
        );
        expect(find.text('Hear the word'), findsOneWidget);
        expect(find.text('Show text (secondary)'), findsOneWidget);
      });

      testWidgets('dashboard renders mode-adapted vertical sections', (tester) async {
        await KuttiompTestHarness.initProtocol(mode: mode);
        await tester.pumpWidget(
          KuttiompTestHarness.wrapWithProviders(
            mode: mode,
            child: const DashboardScreen(),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('Welcome back'), findsOneWidget);
        expect(find.text('Lexemes'), findsOneWidget);
      });

      testWidgets('golden – dashboard per mode', (tester) async {
        await KuttiompTestHarness.initProtocol(mode: mode);
        await tester.pumpWidget(
          KuttiompTestHarness.wrapWithProviders(
            mode: mode,
            child: const DashboardScreen(),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('goldens/dashboard_${mode.id}.png'),
        );
      });

      test('ModeController history records switches', () async {
        await KuttiompTestHarness.initProtocol(mode: mode);
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final controller = container.read(modeControllerProvider.notifier);
        final next = KuttiompMode.values[
            (KuttiompMode.values.indexOf(mode) + 1) % KuttiompMode.values.length];
        await controller.switchMode(next);
        expect(controller.modeHistory, isNotEmpty);
        expect(controller.currentMode, next);
      });
    });
  }
}