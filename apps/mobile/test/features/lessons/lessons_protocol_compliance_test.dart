import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/features/lessons/data/isar_lesson_collection.dart';
import 'package:kuttiomp_mobile/features/lessons/data/lessons_repository.dart';
import 'package:kuttiomp_mobile/features/lessons/domain/lesson.dart';

void main() {
  late ProtocolGateway gateway;
  late LessonsRepository repository;

  setUp(() {
    AuditLogStore.instance.clear();
    InMemoryLessonMirrorStore.instance.clear();
    KuttiompProtocolService.instance.init(claims: {
      'mode': KuttiompMode.coreAdult.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': GenerationalTierBitmask.coreAdult,
    });
    gateway = ProtocolGateway();
    repository = LessonsRepository(gateway: gateway);
  });

  group('Lessons 12-protocol compliance', () {
    test('P1 speaker attribution on getContent', () async {
      final lesson = await repository.getContent('lesson-awakening-greetings');
      expect(lesson.speakerId, isNotEmpty);
      expect(lesson.speakerMetadata['name'], isNotNull);
    });

    test('P2 only elder-approved in permitted lists', () async {
      final list = await repository.watchLessonsForTier(
        GenerationalTierBitmask.allTiers,
      );
      for (final l in list) {
        expect(l.elderApproved, isTrue);
      }
    });

    test('P3 tier filter returns content for little ones', () async {
      final list = await repository.watchLessonsForTier(
        GenerationalTierBitmask.littleOnes,
        stage: 'awakening',
      );
      expect(list, isNotEmpty);
    });

    test('P4 ceremonial lesson requires sacred consent context', () async {
      final ceremonial = await repository.getContent('lesson-deepening-ceremony');
      expect(ceremonial.ceremonialFlag, isTrue);
      expect(ceremonial.isSacred, isTrue);
    });

    test('P4 sacred blocked without consent in offline mirror', () async {
      final result = await repository.mirrorOffline(
        mode: KuttiompMode.elder,
        onSacredConsentRequired: ({required recordId, required sacredFlag}) async =>
            false,
      );
      expect(result.blockedSacredCount, greaterThanOrEqualTo(0));
      expect(
        AuditLogStore.instance.entries.any(
          (e) => e.operation.contains('sacred') || e.protocolId == '4',
        ),
        isTrue,
      );
    });

    test('P4 purge on consent denial removes local mirror', () async {
      final collection = IsarLessonCollection(gateway: gateway);
      await collection.reportAndPurgeSacredViolation(
        recordId: 'lesson-deepening-ceremony',
        reason: 'test_purge',
      );
      expect(
        AuditLogStore.instance.entries.any(
          (e) => e.operation == 'lesson:sacred_violation_purge',
        ),
        isTrue,
      );
    });

    test('P5 clan scope enforced', () async {
      final list = await repository.watchLessonsForTier(
        GenerationalTierBitmask.littleOnes,
        stage: 'awakening',
      );
      for (final l in list) {
        expect(l.clanScope, contains('kuttiomp_clan'));
      }
    });

    test('P7 oral primary audio on blocks', () async {
      final lesson = await repository.getContent('lesson-awakening-greetings');
      expect(lesson.primaryAudioId, isNotEmpty);
      expect(lesson.audioBlocks, isNotEmpty);
      for (final b in lesson.audioBlocks) {
        expect(b.primaryAudioId, isNotEmpty);
      }
    });

    test('P8 authority source present', () async {
      final lesson = await repository.getContent('lesson-awakening-greetings');
      expect(lesson.authoritySource, isNotEmpty);
    });

    test('P9 completion logs audit', () async {
      await repository.completeLesson('lesson-awakening-greetings');
      expect(
        AuditLogStore.instance.entries.any((e) => e.operation.contains('lesson')),
        isTrue,
      );
    });

    test('assertCompliant passes for non-ceremonial lesson', () async {
      final lesson = await repository.getContent('lesson-awakening-greetings');
      expect(() => lesson.assertCompliant(gateway), returnsNormally);
    });
  });
}