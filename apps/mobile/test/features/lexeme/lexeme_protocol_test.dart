import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/lexeme_repository.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';

void main() {
  late KuttiompProtocolService service;
  late LexemeRepository repository;

  setUp(() {
    AuditLogStore.instance.clear();
    service = KuttiompProtocolService.instance;
    service.init(claims: {
      'mode': KuttiompMode.littleOnes.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': GenerationalTierBitmask.littleOnes,
    });
    repository = LexemeRepository(
      gateway: ProtocolGateway(protocolService: service),
    );
  });

  group('LexemeRepository – Protocol enforcement', () {
    test('getById returns lexeme with speaker attribution (Protocol 1)', () async {
      final lexeme = await repository.getById('lexeme-wunnegan');
      expect(lexeme.speakerId, isNotEmpty);
      expect(lexeme.speakerMetadata['name'], isNotNull);
    });

    test('getById logs Protocol 1,7,9 message', () async {
      await repository.getById('lexeme-wunnegan');
      expect(
        AuditLogStore.instance.entries.any(
          (e) => e.outcome.contains('Protocol 1,7,9'),
        ),
        isTrue,
      );
      expect(LexemeRepository.loadLogMessage, contains('Protocol 1,7,9'));
    });

    test('watchLexemesForTier enforces Protocol 3', () async {
      final list = await repository.watchLexemesForTier(
        GenerationalTierBitmask.littleOnes,
      );
      expect(list, isNotEmpty);
      for (final lex in list) {
        expect((lex.visibleToTiers & GenerationalTierBitmask.littleOnes) != 0, isTrue);
      }
    });

    test('lexeme assertCompliant passes for governed record', () {
      const lexeme = LexemeModel(
        id: 'test',
        word: 'Test',
        translation: 'Test gloss',
        speakerMetadata: {'speaker_id': 's1', 'name': 'Speaker', 'authority_source': 'elder'},
        primaryAudioId: 'audio-1',
        sacredFlag: false,
        clanScope: ['kuttiomp_clan'],
        visibleToTiers: GenerationalTierBitmask.allTiers,
        canonicalStage: 'awakening',
      );
      expect(() => lexeme.assertCompliant(ProtocolGateway(protocolService: service)), returnsNormally);
    });

    test('lexeme model includes oral-first context (Protocol 7)', () {
      const lexeme = LexemeModel(
        id: 'test',
        word: 'Test',
        translation: 'Test gloss',
        speakerMetadata: {'speaker_id': 's1', 'name': 'Speaker'},
        primaryAudioId: 'audio-1',
        sacredFlag: false,
        clanScope: ['kuttiomp_clan'],
        visibleToTiers: GenerationalTierBitmask.allTiers,
        canonicalStage: 'awakening',
      );
      final ctx = lexeme.toContentContext();
      expect(ctx['primary_audio_id'], 'audio-1');
      expect(() => service.assertOralFirst(context: {...ctx, 'text_only': true}), returnsNormally);
    });

    test('watchLexemesForTier filters by clan scope (Protocol 5)', () async {
      final lexemes = await repository.watchLexemesForTier(
        GenerationalTierBitmask.littleOnes,
        stage: 'awakening',
      );
      expect(lexemes, isNotEmpty);
      for (final l in lexemes) {
        expect(l.clanScope, contains('kuttiomp_clan'));
      }
    });

    test('sacred lexeme filtered for non-elder mode (Protocol 4)', () async {
      final lexemes = await repository.watchLexemesForTier(
        GenerationalTierBitmask.littleOnes,
        stage: 'deepening',
      );
      expect(lexemes.any((l) => l.sacredFlag), isFalse);
    });

    test('uses audited RPC names only', () {
      expect(KuttiompRpc.getLexemeById, 'get_lexeme_by_id');
      expect(KuttiompRpc.getLexemesForStage, 'get_lexemes_for_stage');
      expect(KuttiompRpc.all, contains('get_lexeme_by_id'));
    });
  });
}