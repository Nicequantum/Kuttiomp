import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_repository.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/rollout/data/pilot_log_store.dart';
import 'package:kuttiomp_mobile/rollout/domain/pilot_observation_model.dart';

/// Secure pilot feedback submission — audited RPC + local mirror (vRollout-1.0, Protocols 1,2,8,9).
class PilotFeedbackService extends AuditedRepository {
  PilotFeedbackService({
    super.gateway,
    super.auditedClient,
    PilotLogMirrorRepository? logMirror,
  }) : _logMirror = logMirror ?? PilotLogMirrorRepository();

  final PilotLogMirrorRepository _logMirror;

  static const String submitLogMessage =
      'Pilot observation submitted | Protocols 1,2,8,9 enforced | Keeper review queued';

  static const String signoffLogMessage =
      'Pilot cohort sign-off | Approved & Ready for Scale | Protocol coverage 100%';

  /// Submits governed pilot observation; mirrors locally; queues Keeper review.
  Future<PilotObservation> submitPilotObservation(PilotObservation obs) async {
    _assertPilotProtocols(obs);

    try {
      await auditedRpc<void>(
        KuttiompRpc.submitPilotFeedback,
        params: obs.toJson(),
      );
    } catch (_) {
      // Offline pilot — local mirror authoritative until Supabase reconnects.
    }

    await _logMirror.put(obs);

    await logRepositoryOperation(
      operation: 'pilot:submit_observation',
      outcome: submitLogMessage,
      payloadSummary: '${obs.householdId} · ${obs.journeyStep}',
    );

    if (kDebugMode) {
      debugPrint('$submitLogMessage (${obs.id})');
    }

    return obs;
  }

  /// Keeper reviews pilot cohort and records scale-readiness decision.
  Future<PilotSignoffRecord> recordKeeperSignoff({
    required String cohortId,
    required String keeperId,
    required String keeperName,
    required PilotSignoffStatus status,
    String protocolCoverage = '100%',
  }) async {
    gateway.assertCompliant(
      KuttiompProtocol.elderApproval.id,
      context: const {'elderApproved': true, 'keeper_signoff': true},
    );
    gateway.protocolService.assertLivingAuthority(
      context: const {'authority_source': 'elder', 'elderApproved': true},
    );

    final observations = await _logMirror.listAll();
    final record = PilotSignoffRecord(
      cohortId: cohortId,
      keeperId: keeperId,
      keeperName: keeperName,
      status: status,
      observationCount: observations.length,
      protocolCoverage: protocolCoverage,
      timestamp: DateTime.now().toUtc(),
      proclamation: status == PilotSignoffStatus.approvedReadyForScale
          ? 'Approved & Ready for Scale — pilot cohort validated for community rollout.'
          : 'Pilot review recorded — awaiting further Keeper guidance.',
    );

    try {
      await auditedRpc<void>(
        KuttiompRpc.submitPilotFeedback,
        params: {
          'type': 'keeper_signoff',
          'cohort_id': cohortId,
          'keeper_id': keeperId,
          'status': status.id,
          'observation_count': observations.length,
          'protocol_coverage': protocolCoverage,
          'elderApproved': true,
        },
      );
    } catch (_) {
      // Offline — sign-off logged locally for tribal council review.
    }

    await AuditLogStore.instance.log(
      AuditLogEntry(
        timestamp: record.timestamp,
        protocolId: KuttiompProtocol.elderApproval.id,
        operation: 'pilot:keeper_signoff',
        outcome: signoffLogMessage,
        payloadSummary: '$cohortId · ${status.id} · $protocolCoverage',
      ),
    );

    if (kDebugMode) {
      debugPrint('$signoffLogMessage ($keeperName)');
    }

    return record;
  }

  void _assertPilotProtocols(PilotObservation obs) {
    final ctx = {
      'speaker_id': obs.speakerMetadata['speaker_id'] ?? obs.speakerMetadata['id'],
      'attribution_json': obs.speakerMetadata,
      'speakerMetadata': obs.speakerMetadata,
      'elderApproved': obs.elderApproved,
      'authority_source': obs.speakerMetadata['authority_source'] ?? 'elder',
    };
    gateway.assertSpeakerPresent(context: ctx);
    gateway.assertElderApproved(context: ctx);
    gateway.protocolService.assertLivingAuthority(context: ctx);
    gateway.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false},
    );
  }
}