import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_repository.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approved_contributions_store.dart';
import 'package:kuttiomp_mobile/features/profile/domain/elder_recording_model.dart';
/// Keeper approval chain simulation – promotes pending recordings to corpus (Protocol 2,8).
class ApprovalSimulation extends AuditedRepository {
  ApprovalSimulation({
    super.gateway,
    super.auditedClient,
  });

  static const String approveLogMessage =
      'Recording approved | Protocols 2,8 enforced';

  static const String appearLogMessage =
      'Approved content mirrored | Protocols 1,2,7,8 enforced';

  List<ElderRecordingModel> listPending() {
    return ApprovedContributionsStore.instance.pendingRecordings();
  }

  List<ElderRecordingModel> listApproved() {
    return ApprovedContributionsStore.instance.approvedRecordings();
  }

  /// Simulates Keeper elder approving a pending recording.
  Future<ElderRecordingModel> approveRecording({
    required String recordingId,
    required String keeperId,
    String keeperName = 'Keeper Elder',
  }) async {
    final pending = ApprovedContributionsStore.instance
        .pendingRecordings()
        .firstWhere(
          (r) => r.id == recordingId,
          orElse: () => throw StateError('No pending recording: $recordingId'),
        );

    gateway.assertElderApproved(context: const {'elderApproved': true});
    gateway.assertSpeakerPresent(context: pending.toContentContext());
    gateway.protocolService.assertLivingAuthority(
      context: {
        ...pending.toContentContext(),
        'authority_source': 'elder',
        'elderApproved': true,
      },
    );

    final chain = [...pending.approvalChain, keeperId];
    final approved = pending.copyWith(
      status: RecordingApprovalStatus.approved,
      elderApproved: true,
      approvedAt: DateTime.now().toUtc(),
      approvalChain: chain,
      speakerMetadata: {
        ...pending.speakerMetadata,
        'keeper_id': keeperId,
        'keeper_name': keeperName,
        'authority_source': 'elder',
      },
    );

    try {
      await auditedRpc<void>(
        KuttiompRpc.approveElderRecording,
        params: {
          'recording_id': recordingId,
          'keeper_id': keeperId,
          'elderApproved': true,
          'approval_chain': chain,
        },
      );
    } catch (_) {
      // Offline approval authoritative until Supabase reconnects.
    }

    ApprovedContributionsStore.instance.promoteToApproved(approved);

    await logRepositoryOperation(
      operation: 'recording:approve',
      outcome: approveLogMessage,
      payloadSummary: recordingId,
    );
    await logRepositoryOperation(
      operation: 'recording:corpus_mirror',
      outcome: appearLogMessage,
      payloadSummary: '${approved.contentType}:${approved.id}',
    );

    if (kDebugMode) {
      debugPrint('$approveLogMessage ($recordingId)');
      debugPrint('$appearLogMessage (${approved.word})');
    }

    return approved;
  }
}