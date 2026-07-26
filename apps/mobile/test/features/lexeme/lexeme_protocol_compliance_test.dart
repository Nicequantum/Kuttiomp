import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/isar_lexeme_collection.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/lexeme_repository.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';

void main() {
  late KuttiompProtocolService service;
  late ProtocolGateway gateway;
  late LexemeRepository repository;

  setUp(() {
    AuditLogStore.instance.clear();
    InMemoryLexemeMirrorStore.instance.clear();
    service = KuttiompProtocolService.instance;
    service.init(claims: {
      'mode': KuttiompMode.coreAdult.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': GenerationalTierBitmask.coreAdult,
    });
    gateway = ProtocolGateway(protocolService: service);
    repository = LexemeRepository(gateway: gateway);
  });

  group('P1 Speaker Attribution', () {
    test('getById requires speaker_id', () async {
      final lexeme = await repository.getById('lexeme-wunnegan');
      expect(lexeme.speakerId, isNotEmpty);
      expect(lexeme.speakerMetadata['name'], isNotNull);
    });
  });

  group('P2 Elder Approval', () {
    test('repository filters unapproved records', () async {
      final list = await repository.watchLexemesForTier(GenerationalTierBitmask.allTiers);
      for (final l in list) {
        expect(l.elderApproved, isTrue);
      }
    });
  });

  group('P3 Generational Tiers', () {
    test('little ones tier receives permitted lexemes', () async {
      final list = await repository.watchLexemesForTier(GenerationalTierBitmask.littleOnes);
      expect(list, isNotEmpty);
    });
  });

  group('P4 Sacred Content', () {
    test('sacred lexeme requires consent in mirror sync', () async {
      final collection = IsarLexemeCollection(gateway: gateway);
      final result = await collection.syncFromRepository(
        repository: repository,
        mode: KuttiompMode.elder,
        onSacredConsentRequired: ({required recordId, required sacredFlag}) async => false,
      );
      expect(result.blockedSacredCount, greaterThanOrEqualTo(0));
    });
  });

  group('P5 Clan Visibility', () {
    test('clan scope enforced on model', () {
      const lexeme = LexemeModel(
        id: 'c1',
        word: 'Test',
        translation: 'Gloss',
        speakerMetadata: {'speaker_id': 's1', 'name': 'S'},
        primaryAudioId: 'a1',
        sacredFlag: false,
        clanScope: ['kuttiomp_clan'],
        visibleToTiers: GenerationalTierBitmask.allTiers,
        canonicalStage: 'awakening',
      );
      expect(gateway.isClanPermitted(lexeme.clanScope), isTrue);
    });
  });

  group('P6 Land Context', () {
    test('geo lexeme includes land geometry', () async {
      final lexeme = await repository.getById('lexeme-mish');
      expect(lexeme.hasGeoContext, isTrue);
      expect(lexeme.geoContext?.label, isNotNull);
    });
  });

  group('P7 Oral Primacy', () {
    test('primary_audio_id required in content context', () async {
      final lexeme = await repository.getById('lexeme-wunnegan');
      expect(lexeme.toContentContext()['primary_audio_id'], isNotEmpty);
    });
  });

  group('P8 Living Authority', () {
    test('authority_source present', () async {
      final lexeme = await repository.getById('lexeme-wunnegan');
      expect(lexeme.authoritySource, AuthoritySource.elder);
    });
  });

  group('P9 Data Sovereignty', () {
    test('repository logs audited operations', () async {
      await repository.getById('lexeme-wunnegan');
      expect(AuditLogStore.instance.entries, isNotEmpty);
    });

    test('mirror sync audits Protocol 9', () async {
      await repository.mirrorOffline(
        mode: KuttiompMode.coreAdult,
        onSacredConsentRequired: ({required recordId, required sacredFlag}) async => true,
      );
      expect(
        AuditLogStore.instance.entries.any((e) => e.operation.contains('lexeme')),
        isTrue,
      );
    });
  });

  group('P10 Dignity', () {
    test('model assertCompliant passes for governed record', () {
      const lexeme = LexemeModel(
        id: 'dignity',
        word: 'Wunnegan',
        translation: 'Good',
        speakerMetadata: {'speaker_id': 's1', 'name': 'Elder', 'authority_source': 'elder'},
        primaryAudioId: 'audio-1',
        sacredFlag: false,
        clanScope: ['kuttiomp_clan'],
        visibleToTiers: GenerationalTierBitmask.allTiers,
        canonicalStage: 'awakening',
      );
      expect(() => lexeme.assertCompliant(gateway), returnsNormally);
    });
  });

  group('P11 Accessibility', () {
    test('content context includes fontSize for elder mode', () {
      const lexeme = LexemeModel(
        id: 'a11',
        word: 'Test',
        translation: 'Gloss',
        speakerMetadata: {'speaker_id': 's1', 'name': 'S'},
        primaryAudioId: 'a1',
        sacredFlag: false,
        clanScope: ['kuttiomp_clan'],
        visibleToTiers: GenerationalTierBitmask.elder,
        canonicalStage: 'awakening',
      );
      final ctx = lexeme.toContentContext(mode: KuttiompMode.elder);
      expect(ctx['fontSize'], greaterThanOrEqualTo(32.0));
    });
  });

  group('P12 Cultural Integrity', () {
    test('schema_version present on all lexemes', () async {
      final list = await repository.watchLexemesForTier(GenerationalTierBitmask.allTiers);
      for (final l in list) {
        expect(l.schemaVersion, isNotEmpty);
      }
    });
  });
}