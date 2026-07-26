import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/lexeme_repository.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';
import 'package:kuttiomp_mobile/features/lexeme/presentation/lexeme_card.dart';
import '../../helpers/kuttiomp_test_harness.dart';

void main() {
  setUp(() async {
    await KuttiompTestHarness.initProtocol(mode: KuttiompMode.coreAdult);
  });

  group('Lexeme §4 flow – card and repository', () {
    testWidgets('LexemeCard renders governed lexeme content', (tester) async {
      const lexeme = LexemeModel(
        id: 'lexeme-wunnegan',
        word: 'Wunnegan',
        translation: 'Good / It is good',
        speakerMetadata: {
          'speaker_id': 'grandmother-comus',
          'name': 'Grandmother Comus',
          'authority_source': 'elder',
        },
        primaryAudioId: 'audio-wunnegan-001',
        sacredFlag: false,
        clanScope: ['kuttiomp_clan'],
        visibleToTiers: GenerationalTierBitmask.allTiers,
        canonicalStage: 'awakening',
      );

      await tester.pumpWidget(
        KuttiompTestHarness.wrapWithProviders(
          mode: KuttiompMode.coreAdult,
          child: Scaffold(
            body: LexemeCard.fromLexeme(lexeme: lexeme),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Wunnegan'), findsOneWidget);
      expect(find.text('Good / It is good'), findsOneWidget);
    });

    test('watchLexemesForTier enforces protocols', () async {
      final gateway = ProtocolGateway();
      final repository = LexemeRepository(gateway: gateway);
      final lexemes = await repository.watchLexemesForTier(
        GenerationalTierBitmask.littleOnes,
        stage: 'awakening',
      );

      expect(lexemes, isNotEmpty);
      expect(lexemes.every((l) => l.elderApproved), isTrue);
      expect(gateway.allAssertionsPassed(), isTrue);
    });

    test('LexemeModel geo context supports land badge (Protocol 6)', () {
      const lexeme = LexemeModel(
        id: 'lexeme-mish',
        word: 'Mish',
        translation: 'Land / Earth',
        speakerMetadata: {
          'speaker_id': 'elder-narragansett',
          'name': 'Elder Keeper',
          'authority_source': 'elder',
        },
        primaryAudioId: 'audio-mish-001',
        sacredFlag: false,
        clanScope: ['kuttiomp_clan'],
        visibleToTiers: GenerationalTierBitmask.coreAdult,
        canonicalStage: 'rooted',
        requiresLandContext: true,
        geoContext: GeoContext(label: 'Narragansett territory'),
      );

      expect(lexeme.hasGeoContext, isTrue);
      expect(lexeme.toContentContext()['requires_land_context'], isTrue);
    });
  });
}