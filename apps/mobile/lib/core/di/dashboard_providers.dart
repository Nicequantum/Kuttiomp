import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/di/injection.dart';
import 'package:kuttiomp_mobile/core/di/lexeme_providers.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/features/dashboard/data/dashboard_repository.dart';
import 'package:kuttiomp_mobile/features/dashboard/domain/dashboard.dart';
import 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(
    gateway: ref.watch(protocolGatewayProvider),
    auditedClient: ref.watch(auditedClientProvider),
    lexemeRepository: ref.watch(lexemeRepositoryProvider),
  );
});

final dashboardSnapshotProvider = FutureProvider.family<DashboardSnapshot, String>(
  (ref, bootstrapStatus) async {
    final mode = ref.watch(modeControllerProvider).valueOrNull ?? KuttiompMode.littleOnes;
    final mastery = ref.watch(userMasteryProvider);
    final controller = ref.read(modeControllerProvider.notifier);
    return ref.watch(dashboardRepositoryProvider).watchDashboardForTier(
          tierBitmask: mode.tierBitmask,
          mastery: mastery,
          modeHistory: controller.modeHistory,
          bootstrapStatus: bootstrapStatus,
        );
  },
);