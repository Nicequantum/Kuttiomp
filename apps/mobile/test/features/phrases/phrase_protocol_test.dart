import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/features/phrases/data/phrases_repository.dart';
import 'package:kuttiomp_mobile/features/phrases/domain/phrase.dart';

void main() {
  late KuttiompProtocolService service;
  late PhrasesRepository repository;

  setUp(() {
    AuditLogStore.instance.clear();
    service = KuttiompProtocolService.instance;
    service.init(claims: {
      'mode': KuttiompMode.littleOnes.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': GenerationalTierBitmask.littleOnes,
    });
    repository = PhrasesRepository(
      gateway: ProtocolGateway(protocolService: service),
    );
  });

  group('PhrasesRepository – Protocol enforcement', () {
    test('getById returns phrase with required primary_audio_id (Protocol 7)', () async {
      final phrase = await repository.getById('phrase-greeting');
      expect(phrase.primaryAudioId, isNotEmpty);
      expect(phrase.speakerId, isNotEmpty);
    });

    test('getById logs Protocols 1,6,7 message', () async {
      await repository.getById('phrase-greeting');
      expect(
        AuditLogStore.instance.entries.any(
          (e) => e.outcome.contains('Protocols 1,6,7'),
        ),
        isTrue,
      );
      expect(PhrasesRepository.loadLogMessage, contains('Protocols 1,6,7'));
    });

    test('phrase model requires primary_audio_id', () {
      expect(
        () => PhraseModel.fromJson({
          'id': 'bad',
          'phrase': 'Test',
          'translation': 'Test',
        }),
        throwsArgumentError,
      );
    });

    test('land-context phrase includes geometry (Protocol 6)', () async {
      final phrase = await repository.getById('phrase-land-greeting');
      expect(phrase.landContext, isNotNull);
      expect(phrase.requiresLandContext, isTrue);
      expect(() => service.assertLandContext(
            context: {
              'requires_land_context': true,
              'land_geometry': phrase.landContext,
            },
          ), returnsNormally);
    });

    test('watchPhrasesForTier filters sacred phrases for little ones (Protocol 4)', () async {
      final phrases = await repository.watchPhrasesForTier(
        GenerationalTierBitmask.littleOnes,
        stage: 'deepening',
      );
      expect(phrases.any((p) => p.sacredFlag), isFalse);
    });

    test('watchPhrasesForTier returns governed corpus', () async {
      final phrases = await repository.watchPhrasesForTier(
        GenerationalTierBitmask.littleOnes,
        stage: 'awakening',
      );
      expect(phrases.any((p) => p.phrase.toLowerCase().contains('anska')), isTrue);
    });

    test('phrase model includes protocol metadata embed', () {
      const phrase = PhraseModel(
        id: 'test',
        phrase: 'Test',
        translation: 'Test gloss',
        speakerMetadata: {'speaker_id': 's1', 'name': 'Speaker', 'authority_source': 'elder'},
        primaryAudioId: 'audio-1',
        category: 'greeting',
      );
      final embed = phrase.protocolMetadataEmbed();
      expect(embed['speaker_id'], 's1');
      expect(embed['primary_audio_id'], 'audio-1');
    });

    test('uses audited RPC names only', () {
      expect(KuttiompRpc.getPhrasesForStage, 'get_phrases_for_stage');
      expect(KuttiompRpc.getPhraseContext, 'get_phrase_context');
      expect(KuttiompRpc.all, contains('get_phrases_for_stage'));
    });
  });
}