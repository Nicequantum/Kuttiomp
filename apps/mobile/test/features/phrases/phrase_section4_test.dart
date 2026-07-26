import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/di/lexeme_providers.dart';
import 'package:kuttiomp_mobile/core/di/phrase_providers.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/features/phrases/data/phrases_repository.dart';
import 'package:kuttiomp_mobile/features/phrases/domain/phrase.dart';
import 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';
import '../../helpers/kuttiomp_test_harness.dart';

void main() {
  setUp(() async {
    await KuttiompTestHarness.initProtocol(mode: KuttiompMode.coreAdult);
  });

  group('phrases §4 structure', () {
    test('PhraseModel assertCompliant passes governed content', () {
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
      final gateway = ProtocolGateway();
      phrase.assertCompliant(gateway);
      expect(gateway.allAssertionsPassed(content: phrase.toContentContext()), isTrue);
    });

    test('phraseDashboardFilterProvider derives mode and mastery', () {
      final container = ProviderContainer(
        overrides: [
          userMasteryProvider.overrideWith(
            (ref) => const UserMasterySummary(
              canonicalStage: 'flowing',
              wordCount: 120,
              modeProgress: {'core_adult': 15},
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final filter = container.read(phraseDashboardFilterProvider);
      expect(filter.canonicalStage, 'flowing');
    });

    test('phraseLexemePairsProvider resolves related lexemes', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final pairs = await container.read(phraseLexemePairsProvider('phrase-greeting').future);
      expect(pairs, isNotEmpty);
      expect(pairs.first.word, isNotEmpty);
    });

    test('watchPhrasesForTier is sole tier entry point', () async {
      final repository = PhrasesRepository(gateway: ProtocolGateway());
      final phrases = await repository.watchPhrasesForTier(
        GenerationalTierBitmask.coreAdult,
        stage: 'awakening',
      );
      expect(phrases, isNotEmpty);
    });
  });
}