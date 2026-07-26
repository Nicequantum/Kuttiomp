import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/features/dashboard/data/dashboard_repository.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';

void main() {
  late DashboardRepository repository;

  setUp(() {
    AuditLogStore.instance.clear();
    KuttiompProtocolService.instance.init(
      claims: {
        'mode': KuttiompMode.coreAdult.id,
        'clan': 'kuttiomp_clan',
        'role': 'learner',
        'tier': GenerationalTierBitmask.coreAdult,
      },
    );
    repository = DashboardRepository(
      gateway: ProtocolGateway(),
    );
  });

  group('DashboardRepository', () {
    test('watchDashboardForTier returns governed snapshot', () async {
      final snapshot = await repository.watchDashboardForTier(
        tierBitmask: GenerationalTierBitmask.coreAdult,
        mastery: const UserMasterySummary(
          canonicalStage: 'awakening',
          wordCount: 12,
          modeProgress: {
            for (final m in KuttiompMode.values) m.id: m == KuttiompMode.coreAdult ? 8 : 5,
          },
        ),
        modeHistory: [KuttiompMode.littleOnes],
        bootstrapStatus: 'Foundation complete',
      );

      expect(snapshot.modePetals.length, 4);
      expect(snapshot.lexemeCount, greaterThan(0));
      expect(snapshot.masteryStage.label, isNotEmpty);
    });
  });
}