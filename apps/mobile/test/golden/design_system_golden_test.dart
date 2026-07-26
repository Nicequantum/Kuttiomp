import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme.dart';
import 'package:kuttiomp_mobile/shared/design_system/buttons.dart';
import 'package:kuttiomp_mobile/shared/design_system/cards.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';
import 'package:kuttiomp_mobile/shared/widgets/elder_mode_overlay.dart';

import '../helpers/kuttiomp_test_harness.dart';

/// Golden test stubs per mode – run locally with `flutter test --update-goldens`.
///
/// This serves our people by locking dignified visual baselines that tribal
/// reviewers can diff across OS upgrades through 2050.
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
    'fontSize': 32,
    'visible_to_tiers': GenerationalTierBitmask.allTiers,
  };

  setUp(() async {
    await KuttiompTestHarness.initProtocol(mode: KuttiompMode.elder);
  });

  for (final mode in KuttiompMode.values) {
    testWidgets('golden stub – design system elder typography in ${mode.label}', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: KuttiompTheme.forMode(mode),
          home: Scaffold(
            body: ElderModeOverlay(
              mode: mode,
              child: Column(
                children: [
                  ContentCard(
                    speakerMetadata: speaker,
                    contentContext: {
                      ...contentContext,
                      'fontSize': mode.minimumFontSize,
                    },
                    title: 'Wunnegan',
                    subtitle: 'Good',
                  ),
                  const SizedBox(height: 16),
                  KuttiompButton(
                    speakerMetadata: speaker,
                    contentContext: contentContext,
                    label: 'Listen',
                    onPressed: () {},
                  ),
                  const SizedBox(height: 16),
                  AuthorityBadge(
                    speakerMetadata: speaker,
                    contentContext: contentContext,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Stub: uncomment when capturing goldens locally.
      // await expectLater(
      //   find.byType(Scaffold),
      //   matchesGoldenFile('design_system_${mode.id}.png'),
      // );
      expect(find.text('Wunnegan'), findsOneWidget);
    });
  }
}