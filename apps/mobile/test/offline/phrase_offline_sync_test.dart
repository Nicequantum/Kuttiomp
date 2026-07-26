import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/features/phrases/data/isar_phrase_collection.dart';
import 'package:kuttiomp_mobile/features/phrases/data/phrases_repository.dart';

void main() {
  late PhrasesRepository repository;
  late IsarPhraseCollection collection;

  setUp(() {
    AuditLogStore.instance.clear();
    InMemoryPhraseMirrorStore.instance.clear();
    KuttiompProtocolService.instance.init(claims: {
      'mode': KuttiompMode.coreAdult.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': GenerationalTierBitmask.coreAdult,
    });
    final gateway = ProtocolGateway();
    repository = PhrasesRepository(gateway: gateway);
    collection = IsarPhraseCollection(gateway: gateway);
  });

  test('syncFromRepository mirrors phrases offline', () async {
    final result = await collection.syncFromRepository(
      repository: repository,
      mode: KuttiompMode.coreAdult,
      onSacredConsentRequired: ({required recordId, required sacredFlag}) async =>
          true,
    );
    expect(result.mirroredCount, greaterThan(0));
    expect(InMemoryPhraseMirrorStore.instance.count, greaterThan(0));
  });

  test('readOfflineForTier returns elder-approved phrases', () async {
    await collection.syncFromRepository(
      repository: repository,
      mode: KuttiompMode.littleOnes,
      onSacredConsentRequired: ({required recordId, required sacredFlag}) async =>
          true,
    );
    final offline =
        await collection.readOfflineForTier(GenerationalTierBitmask.littleOnes);
    expect(offline, isNotEmpty);
    for (final p in offline) {
      expect(p.elderApproved, isTrue);
    }
  });
}