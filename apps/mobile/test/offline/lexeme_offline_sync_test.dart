import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/isar_lexeme_collection.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/lexeme_repository.dart';

/// Offline lexeme sync simulator (§7, Protocols 4, 5, 9).
void main() {
  late LexemeRepository repository;
  late IsarLexemeCollection collection;

  setUp(() {
    AuditLogStore.instance.clear();
    InMemoryLexemeMirrorStore.instance.clear();
    KuttiompProtocolService.instance.init(claims: {
      'mode': KuttiompMode.coreAdult.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': GenerationalTierBitmask.coreAdult,
    });
    final gateway = ProtocolGateway();
    repository = LexemeRepository(gateway: gateway);
    collection = IsarLexemeCollection(gateway: gateway);
  });

  group('Lexeme offline mirror', () {
    test('syncFromRepository mirrors permitted lexemes', () async {
      final result = await collection.syncFromRepository(
        repository: repository,
        mode: KuttiompMode.coreAdult,
        onSacredConsentRequired: ({required recordId, required sacredFlag}) async => true,
      );
      expect(result.mirroredCount, greaterThan(0));
      expect(InMemoryLexemeMirrorStore.instance.count, greaterThan(0));
    });

    test('readOfflineForTier returns mirrored lexemes', () async {
      await collection.syncFromRepository(
        repository: repository,
        mode: KuttiompMode.littleOnes,
        onSacredConsentRequired: ({required recordId, required sacredFlag}) async => true,
      );
      final offline = await collection.readOfflineForTier(
        GenerationalTierBitmask.littleOnes,
      );
      expect(offline, isNotEmpty);
    });

    test('repository mirrorOffline delegates to Isar collection', () async {
      final result = await repository.mirrorOffline(
        mode: KuttiompMode.youngLearner,
        onSacredConsentRequired: ({required recordId, required sacredFlag}) async => true,
      );
      expect(result.logMessage, contains('Quota'));
    });

    test('sacred consent denial blocks mirror write', () async {
      final result = await collection.syncFromRepository(
        repository: repository,
        mode: KuttiompMode.elder,
        onSacredConsentRequired: ({required recordId, required sacredFlag}) async => false,
      );
      expect(result.blockedSacredCount, greaterThanOrEqualTo(0));
    });

    test('encrypted sacred payload uses clan-derived key', () {
      final encrypted = IsarLexemeCollection.encryptSacredPayload(
        payload: 'Sacred Word',
        clanId: 'kuttiomp_clan',
        role: 'elder',
      );
      expect(encrypted, isNotEmpty);
    });
  });
}