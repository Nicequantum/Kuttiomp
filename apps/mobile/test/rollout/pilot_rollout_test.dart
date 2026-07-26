import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/rollout/data/pilot_log_store.dart';
import 'package:kuttiomp_mobile/rollout/domain/pilot_observation_model.dart';
import 'package:kuttiomp_mobile/rollout/pilot_feedback_service.dart';
import 'package:kuttiomp_mobile/rollout/pilot_simulation_runner.dart';
import 'package:kuttiomp_mobile/rollout/rollout_release.dart';

void main() {
  late PilotFeedbackService service;
  late PilotSimulationRunner runner;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    AuditLogStore.instance.clear();
    PilotLogStore.instance.clear();
    KuttiompProtocolService.instance.init(claims: {
      'mode': KuttiompMode.coreAdult.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': GenerationalTierBitmask.coreAdult,
    });
    final gateway = ProtocolGateway();
    service = PilotFeedbackService(gateway: gateway);
    runner = PilotSimulationRunner(service: service);
  });

  group('vRollout-1.0 — Community rollout simulation', () {
    test('submitPilotObservation mirrors locally with protocol log', () async {
      const obs = PilotObservation(
        id: 'pilot-test-01',
        householdId: 'household-test',
        observerRole: 'parent_observer',
        mode: KuttiompMode.littleOnes,
        deviceType: 'family_ipad',
        journeyStep: 'search_land',
        observation: 'Child heard land lexeme with oral-first player.',
        protocolsEnforced: ['1', '2', '6', '7', '8', '9'],
        speakerMetadata: {
          'speaker_id': 'pilot-parent-01',
          'name': 'Pilot Parent',
          'authority_source': 'elder',
        },
      );

      await service.submitPilotObservation(obs);
      expect(PilotLogStore.instance.count, 1);
      expect(
        AuditLogStore.instance.entries.any((e) => e.operation == 'pilot:submit_observation'),
        isTrue,
      );
      expect(PilotFeedbackService.submitLogMessage, contains('Protocols 1,2,8,9'));
    });

    test('uses audited RPC name for pilot feedback', () {
      expect(KuttiompRpc.submitPilotFeedback, 'submit_pilot_feedback_secure');
      expect(KuttiompRpc.all, contains('submit_pilot_feedback_secure'));
    });

    test('full device matrix simulation generates day-in-the-life logs', () async {
      final result = await runner.run(cohortId: 'pilot-sim-test');

      expect(result.deviceCount, PilotSimulationRunner.defaultDeviceMatrix.length);
      expect(result.journeyStepCount, PilotSimulationRunner.journeySteps.length);
      expect(
        result.observations.length,
        result.deviceCount * result.journeyStepCount,
      );

      for (final mode in KuttiompMode.values) {
        expect(result.observations.any((o) => o.mode == mode), isTrue);
      }

      expect(result.signoff.isApprovedForScale, isTrue);
      expect(result.signoff.protocolCoverage, '100%');
    });

    test('Keeper sign-off triggers Approved & Ready for Scale', () async {
      await runner.run();
      final signoff = await service.recordKeeperSignoff(
        cohortId: 'pilot-cohort-signoff-test',
        keeperId: 'keeper-test',
        keeperName: 'Test Keeper Council',
        status: PilotSignoffStatus.approvedReadyForScale,
      );

      expect(signoff.status, PilotSignoffStatus.approvedReadyForScale);
      expect(
        AuditLogStore.instance.entries.any((e) => e.operation == 'pilot:keeper_signoff'),
        isTrue,
      );
      expect(PilotFeedbackService.signoffLogMessage, contains('Approved & Ready for Scale'));
    });

    test('council report formats for tribal archives', () async {
      final result = await runner.run();
      final report = PilotSimulationRunner.formatCouncilReport(result);
      expect(report, contains('vRollout-1.0'));
      expect(report, contains('approved_ready_for_scale'));
      // ignore: avoid_print
      print(report);
    });

    test('full journey steps represented in simulation', () async {
      final result = await runner.run();
      for (final step in PilotSimulationRunner.journeySteps) {
        expect(result.observations.any((o) => o.journeyStep == step), isTrue,
            reason: 'Missing journey step: $step');
      }
    });

    test('rollout release version matches package', () {
      expect(RolloutRelease.version, 'vRollout-1.0');
      expect(RolloutRelease.mobileBaseVersion, '2.3.0+1');
    });
  });
}