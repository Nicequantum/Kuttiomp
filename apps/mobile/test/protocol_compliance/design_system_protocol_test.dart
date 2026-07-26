import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme.dart';
import 'package:kuttiomp_mobile/shared/design_system/approved_content_gate.dart';
import 'package:kuttiomp_mobile/shared/design_system/audio_dominant_view.dart';
import 'package:kuttiomp_mobile/shared/design_system/buttons.dart';
import 'package:kuttiomp_mobile/shared/design_system/cards.dart';
import 'package:kuttiomp_mobile/shared/design_system/geo_context_badge.dart';
import 'package:kuttiomp_mobile/shared/design_system/kuttiomp_content_widget.dart';
import 'package:kuttiomp_mobile/shared/design_system/living_authority_decorator.dart';
import 'package:kuttiomp_mobile/shared/design_system/protocol_base_widget.dart';
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

  group('ProtocolBaseWidget enforcement', () {
    testWidgets('UnguardedContentProbe throws without speaker', (tester) async {
      expect(
        () => KuttiompProtocolService.instance.assertSpeakerPresent(context: const {}),
        throwsA(isA<Exception>()),
      );
    });

    testWidgets('AuthorityBadge renders through ProtocolBaseWidget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: KuttiompTheme.forMode(KuttiompMode.coreAdult),
          home: Scaffold(
            body: AuthorityBadge(
              speakerMetadata: speaker,
              contentContext: contentContext,
            ),
          ),
        ),
      );
      expect(find.textContaining('Authority:'), findsOneWidget);
    });
  });

  group('KuttiompContentWidget', () {
    test('buildContentContext merges protocol fields', () {
      final ctx = KuttiompContentWidget.buildContentContext(
        speakerMetadata: speaker,
        elderApproved: true,
        clanScope: const ['kuttiomp_clan'],
        extra: const {'primary_audio_id': 'audio-001'},
      );
      expect(ctx['elderApproved'], isTrue);
      expect(ctx['clan_scope'], ['kuttiomp_clan']);
      expect(ctx['speaker_id'], 'grandmother-comus');
    });
  });

  group('Design system primitives', () {
    testWidgets('KuttiompButton renders with Semantics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: KuttiompTheme.forMode(KuttiompMode.elder),
          home: Scaffold(
            body: KuttiompButton(
              speakerMetadata: speaker,
              contentContext: contentContext,
              label: 'Continue',
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('ContentCard renders attributed title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: KuttiompTheme.forMode(KuttiompMode.coreAdult),
          home: Scaffold(
            body: ContentCard(
              speakerMetadata: speaker,
              contentContext: contentContext,
              title: 'Wunnegan',
              subtitle: 'Good',
            ),
          ),
        ),
      );
      expect(find.text('Wunnegan'), findsOneWidget);
      expect(find.text('Good'), findsOneWidget);
    });

    testWidgets('AudioDominantView prioritizes audio control', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: KuttiompTheme.forMode(KuttiompMode.coreAdult),
          home: Scaffold(
            body: AudioDominantView(
              speakerMetadata: speaker,
              contentContext: contentContext,
              audioLabel: 'Hear word',
              textContent: 'Translation',
            ),
          ),
        ),
      );
      expect(find.text('Hear word'), findsOneWidget);
      expect(find.text('Show text (secondary)'), findsOneWidget);
    });

    testWidgets('GeoContextBadge renders land label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: KuttiompTheme.forMode(KuttiompMode.coreAdult),
          home: Scaffold(
            body: GeoContextBadge(
              speakerMetadata: speaker,
              contentContext: {
                ...contentContext,
                'requires_land_context': true,
                'landContext': 'Narragansett Bay',
              },
              landLabel: 'Narragansett Bay',
            ),
          ),
        ),
      );
      expect(find.text('Narragansett Bay'), findsOneWidget);
    });

    testWidgets('ApprovedContentGate blocks unapproved content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ApprovedContentGate(
            contentContext: {...contentContext, 'elderApproved': false},
            builder: (_) => const Text('Should not render'),
          ),
        ),
      );
      expect(find.text('Should not render'), findsNothing);
    });

    testWidgets('LivingAuthorityDecorator requires acknowledgment', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: KuttiompTheme.forMode(KuttiompMode.coreAdult),
          home: Scaffold(
            body: LivingAuthorityDecorator(
              speakerMetadata: speaker,
              contentContext: contentContext,
              child: const Text('Protected content'),
            ),
          ),
        ),
      );
      expect(find.text('Protected content'), findsNothing);
      await tester.tap(find.text('Acknowledge Authority'));
      await tester.pump();
      expect(find.text('Protected content'), findsOneWidget);
    });
  });
}