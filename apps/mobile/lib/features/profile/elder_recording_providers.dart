import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/di/injection.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approval_simulation.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approved_contributions_store.dart';
import 'package:kuttiomp_mobile/features/profile/domain/elder_recording_model.dart';
import 'package:kuttiomp_mobile/features/profile/domain/recording_service.dart';
import 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';

final recordingServiceProvider = Provider<RecordingService>((ref) {
  return RecordingService(
    gateway: ref.watch(protocolGatewayProvider),
    auditedClient: ref.watch(auditedClientProvider),
  );
});

final approvalSimulationProvider = Provider<ApprovalSimulation>((ref) {
  return ApprovalSimulation(
    gateway: ref.watch(protocolGatewayProvider),
    auditedClient: ref.watch(auditedClientProvider),
  );
});

final pendingRecordingsProvider = FutureProvider<List<ElderRecordingModel>>((ref) async {
  return ref.watch(approvalSimulationProvider).listPending();
});

final approvedRecordingsProvider = FutureProvider<List<ElderRecordingModel>>((ref) async {
  return ref.watch(approvalSimulationProvider).listApproved();
});

final approvedLexemeContributionsProvider = Provider<List<LexemeModel>>((ref) {
  ref.watch(approvedRecordingsProvider);
  return ApprovedContributionsStore.instance.approvedLexemes();
});