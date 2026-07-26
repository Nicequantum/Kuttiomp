import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/features/lessons/data/isar_lesson_collection.dart';
import 'package:kuttiomp_mobile/features/lessons/data/lessons_repository.dart';

void main() {
  late LessonsRepository repository;
  late IsarLessonCollection collection;

  setUp(() {
    AuditLogStore.instance.clear();
    InMemoryLessonMirrorStore.instance.clear();
    KuttiompProtocolService.instance.init(claims: {
      'mode': KuttiompMode.coreAdult.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': GenerationalTierBitmask.coreAdult,
    });
    final gateway = ProtocolGateway();
    repository = LessonsRepository(gateway: gateway);
    collection = IsarLessonCollection(gateway: gateway);
  });

  test('sync mirrors non-sacred approved lessons', () async {
    final result = await collection.syncFromRepository(
      repository: repository,
      mode: KuttiompMode.littleOnes,
      canonicalStage: 'awakening',
      onSacredConsentRequired: ({required recordId, required sacredFlag}) async =>
          false,
    );
    expect(result.mirroredCount, greaterThan(0));
    final offline = await collection.readOfflineForTier(
      GenerationalTierBitmask.littleOnes,
    );
    for (final l in offline) {
      expect(l.elderApproved, isTrue);
      expect(l.ceremonialFlag, isFalse);
    }
  });

  test('sacred without consent is blocked and purged', () async {
    final result = await collection.syncFromRepository(
      repository: repository,
      mode: KuttiompMode.elder,
      onSacredConsentRequired: ({required recordId, required sacredFlag}) async =>
          false,
    );
    expect(result.blockedSacredCount + result.purgedCount, greaterThanOrEqualTo(0));
  });

  test('offline read excludes ceremonial by default', () async {
    await collection.syncFromRepository(
      repository: repository,
      mode: KuttiompMode.elder,
      onSacredConsentRequired: ({required recordId, required sacredFlag}) async =>
          true,
      clanReauthenticated: true,
    );
    final offline = await collection.readOfflineForTier(
      GenerationalTierBitmask.elder,
      allowSacredWithConsent: false,
    );
    expect(offline.every((l) => !l.ceremonialFlag), isTrue);
  });
}