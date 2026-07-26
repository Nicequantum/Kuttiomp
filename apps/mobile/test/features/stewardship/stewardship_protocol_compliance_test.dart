import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/features/stewardship/data/stewardship_repository.dart';
import 'package:kuttiomp_mobile/features/stewardship/domain/stewardship_models.dart';

void main() {
  late StewardshipRepository repository;

  setUp(() {
    AuditLogStore.instance.clear();
    KuttiompProtocolService.instance.init(claims: {
      'mode': KuttiompMode.coreAdult.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': GenerationalTierBitmask.coreAdult,
    });
    repository = StewardshipRepository();
  });

  group('Stewardship Protocol 10 + absolute metrics', () {
    test('corpus metrics never invent target or continuity pct', () async {
      final metrics = await repository.fetchCorpusMetrics();
      expect(metrics.targetLexemes, isNull);
      expect(metrics.continuityPct, isNull);
      expect(metrics.totalApprovedLexemes, greaterThanOrEqualTo(0));
    });

    test('speaker summary uses absolute non-negative counts', () async {
      final summary =
          await repository.fetchSpeakerSummary('grandmother-comus');
      expect(summary.submittedCount, greaterThanOrEqualTo(0));
      expect(summary.approvedLivingCount, greaterThanOrEqualTo(0));
      expect(summary.pendingApprovalCount, greaterThanOrEqualTo(0));
      expect(summary.primaryAudioCount, greaterThanOrEqualTo(0));
    });

    test('models contain no gamification field names', () {
      const m = CorpusContinuityMetrics.sample;
      final jsonKeys = [
        'totalApprovedLexemes',
        'targetLexemes',
        'continuityPct',
      ];
      for (final k in jsonKeys) {
        expect(k.toLowerCase().contains('points'), isFalse);
        expect(k.toLowerCase().contains('streak'), isFalse);
        expect(k.toLowerCase().contains('leaderboard'), isFalse);
        expect(k.toLowerCase().contains('rank'), isFalse);
      }
      expect(m.hasKeeperTarget, isFalse);
    });

    test('dignity assert rejects playful stewardship widgets', () {
      expect(
        () => KuttiompProtocolService.instance.assertDignity(
          context: {'widgetType': 'PointsCounter'},
        ),
        throwsA(anything),
      );
    });

    test('operations are audited (Protocol 9)', () async {
      await repository.fetchCorpusMetrics();
      expect(
        AuditLogStore.instance.entries.any(
          (e) => e.operation.contains('stewardship'),
        ),
        isTrue,
      );
    });
  });
}