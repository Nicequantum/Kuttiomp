import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/features/phrases/data/phrases_repository.dart';
import 'package:kuttiomp_mobile/features/phrases/domain/phrase.dart';
import 'package:kuttiomp_mobile/features/phrases/presentation/phrase_card.dart';
import '../../helpers/kuttiomp_test_harness.dart';

void main() {
  setUp(() async {
    await KuttiompTestHarness.initProtocol(mode: KuttiompMode.coreAdult);
  });

  group('Phrases §4 flow – card and repository', () {
    testWidgets('PhraseCard renders governed phrase content', (tester) async {
      const phrase = PhraseModel(
        id: 'phrase-greeting',
        phrase: 'Anska, wunnegan!',
        translation: 'Hello, it is good!',
        speakerMetadata: {
          'speaker_id': 'grandmother-comus',
          'name': 'Grandmother Comus',
          'authority_source': 'elder',
        },
        primaryAudioId: 'audio-phrase-greeting-001',
      );

      await tester.pumpWidget(
        KuttiompTestHarness.wrapWithProviders(
          mode: KuttiompMode.coreAdult,
          child: Scaffold(
            body: PhraseCard.fromPhrase(phrase: phrase),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Anska, wunnegan!'), findsOneWidget);
      expect(find.text('Hello, it is good!'), findsOneWidget);
    });

    test('watchPhrasesForTier returns elder-approved phrases', () async {
      final gateway = ProtocolGateway();
      final repository = PhrasesRepository(gateway: gateway);
      final phrases = await repository.watchPhrasesForTier(
        GenerationalTierBitmask.coreAdult,
        stage: 'awakening',
      );

      expect(phrases, isNotEmpty);
      expect(phrases.every((p) => p.elderApproved), isTrue);
      expect(gateway.allAssertionsPassed(), isTrue);
    });
  });
}