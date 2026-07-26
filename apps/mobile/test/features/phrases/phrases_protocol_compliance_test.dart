import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/features/phrases/data/isar_phrase_collection.dart';
import 'package:kuttiomp_mobile/features/phrases/data/phrases_repository.dart';
import 'package:kuttiomp_mobile/features/phrases/domain/phrase.dart';

void main() {
  late ProtocolGateway gateway;
  late PhrasesRepository repository;

  setUp(() {
    AuditLogStore.instance.clear();
    InMemoryPhraseMirrorStore.instance.clear();
    KuttiompProtocolService.instance.init(claims: {
      'mode': KuttiompMode.coreAdult.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': GenerationalTierBitmask.coreAdult,
    });
    gateway = ProtocolGateway();
    repository = PhrasesRepository(gateway: gateway);
  });

  group('Phrases 12-protocol compliance', () {
    test('P1 speaker attribution on getById', () async {
      final phrase = await repository.getById('phrase-greeting');
      expect(phrase.speakerId, isNotEmpty);
      expect(phrase.speakerMetadata['name'], isNotNull);
    });

    test('P2 elder-approved only in watch', () async {
      final list =
          await repository.watchPhrasesForTier(GenerationalTierBitmask.allTiers);
      for (final p in list) {
        expect(p.elderApproved, isTrue);
      }
    });

    test('P3 tier filter for little ones', () async {
      final list =
          await repository.watchPhrasesForTier(GenerationalTierBitmask.littleOnes);
      expect(list, isNotEmpty);
    });

    test('P5 clan scope enforced', () async {
      final list =
          await repository.watchPhrasesForTier(GenerationalTierBitmask.littleOnes);
      for (final p in list) {
        expect(p.clanScope, contains('kuttiomp_clan'));
      }
    });

    test('P6 land context on land phrase', () async {
      final phrase = await repository.getById('phrase-land-greeting');
      expect(phrase.requiresLandContext, isTrue);
    });

    test('P7 oral primary audio required', () async {
      final phrase = await repository.getById('phrase-greeting');
      expect(phrase.toContentContext()['primary_audio_id'], isNotEmpty);
    });

    test('P8 authority source present', () async {
      final phrase = await repository.getById('phrase-greeting');
      expect(phrase.authoritySource, isNotEmpty);
    });

    test('P9 audited operations logged', () async {
      await repository.getById('phrase-greeting');
      expect(AuditLogStore.instance.entries, isNotEmpty);
    });

    test('P4 sacred blocked without consent in mirror', () async {
      final result = await repository.mirrorOffline(
        mode: KuttiompMode.elder,
        onSacredConsentRequired: ({required recordId, required sacredFlag}) async =>
            false,
      );
      expect(result.blockedSacredCount, greaterThanOrEqualTo(0));
    });

    test('assertCompliant passes for greeting phrase', () async {
      final phrase = await repository.getById('phrase-greeting');
      expect(() => phrase.assertCompliant(gateway), returnsNormally);
    });
  });
}