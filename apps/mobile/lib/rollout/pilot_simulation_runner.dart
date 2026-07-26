import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/rollout/domain/pilot_observation_model.dart';
import 'package:kuttiomp_mobile/rollout/pilot_feedback_service.dart';

/// Device matrix entry for pilot cohort simulation (vRollout-1.0).
class PilotDeviceMatrixEntry {
  const PilotDeviceMatrixEntry({
    required this.householdId,
    required this.mode,
    required this.deviceType,
    required this.observerRole,
  });

  final String householdId;
  final KuttiompMode mode;
  final String deviceType;
  final String observerRole;
}

/// Generates day-in-the-life pilot logs across the device matrix.
class PilotSimulationRunner {
  PilotSimulationRunner({PilotFeedbackService? service})
      : _service = service ?? PilotFeedbackService(gateway: ProtocolGateway());

  final PilotFeedbackService _service;

  static const String version = 'vRollout-1.0';

  static const List<PilotDeviceMatrixEntry> defaultDeviceMatrix = [
    PilotDeviceMatrixEntry(
      householdId: 'household-01-little-ones',
      mode: KuttiompMode.littleOnes,
      deviceType: 'family_ipad',
      observerRole: 'parent_observer',
    ),
    PilotDeviceMatrixEntry(
      householdId: 'household-02-young-learner',
      mode: KuttiompMode.youngLearner,
      deviceType: 'youth_android',
      observerRole: 'young_learner_self',
    ),
    PilotDeviceMatrixEntry(
      householdId: 'household-03-core-adult',
      mode: KuttiompMode.coreAdult,
      deviceType: 'android_phone',
      observerRole: 'tribal_member',
    ),
    PilotDeviceMatrixEntry(
      householdId: 'household-04-elder',
      mode: KuttiompMode.elder,
      deviceType: 'elder_android_phone',
      observerRole: 'elder_keeper',
    ),
  ];

  static const journeySteps = [
    'onboarding',
    'mode_switch',
    'search_land',
    'lesson_complete',
    'elder_contribute',
    'keeper_approve',
    'profile_audit',
    'offline_toggle',
  ];

  static const seedingJourneySteps = [
    'seeding_dashboard',
    'campaign_record',
    'keeper_approve_seed',
    'corpus_promotion',
    'search_land_seeded',
  ];

  /// Runs full simulated pilot across device matrix and journey steps.
  Future<PilotSimulationResult> run({
    List<PilotDeviceMatrixEntry>? deviceMatrix,
    String cohortId = 'pilot-cohort-2026-q3',
    bool withSeeding = false,
  }) async {
    final matrix = deviceMatrix ?? defaultDeviceMatrix;
    final observations = <PilotObservation>[];

    final steps = withSeeding
        ? [...journeySteps, ...seedingJourneySteps]
        : journeySteps;

    for (final device in matrix) {
      for (final step in steps) {
        final obs = PilotObservation(
          id: 'pilot-${device.householdId}-$step',
          householdId: device.householdId,
          observerRole: device.observerRole,
          mode: device.mode,
          deviceType: device.deviceType,
          journeyStep: step,
          observation: _observationForStep(step, device.mode),
          protocolsEnforced: _protocolsForStep(step),
          speakerMetadata: {
            'speaker_id': 'pilot-${device.householdId}',
            'name': 'Pilot Observer ${device.householdId}',
            'authority_source': 'elder',
          },
          elderApproved: true,
          screenshotRef: 'pilot_screenshots/${device.householdId}/$step.png',
        );
        await _service.submitPilotObservation(obs);
        observations.add(obs);
      }
    }

    final signoff = await _service.recordKeeperSignoff(
      cohortId: cohortId,
      keeperId: 'keeper-pilot-council',
      keeperName: 'Knowledge Keepers Pilot Council',
      status: PilotSignoffStatus.approvedReadyForScale,
    );

    return PilotSimulationResult(
      observations: observations,
      signoff: signoff,
      deviceCount: matrix.length,
      journeyStepCount: steps.length,
    );
  }

  String _observationForStep(String step, KuttiompMode mode) {
    switch (step) {
      case 'onboarding':
        return 'Audio-guided onboarding completed; mode ${mode.label} persisted.';
      case 'mode_switch':
        return 'FAB long-press mode selector saved path; renders adapted with dignity.';
      case 'search_land':
        return 'Search "land" returned governed results with audio preview and attribution.';
      case 'lesson_complete':
        return 'Lesson activity completed; progress radial updated canonically.';
      case 'elder_contribute':
        return 'Elder recording submitted; pending gate displayed respectfully.';
      case 'keeper_approve':
        return 'Keeper approved contribution; corpus mirror updated in search.';
      case 'profile_audit':
        return 'Profile audit log reviewed; accessibility toggles functional.';
      case 'offline_toggle':
        return 'Offline mirror served cached content; sacred consent gate honored.';
      case 'seeding_dashboard':
        return 'Elder opened seeding dashboard; Land Stewardship campaign selected.';
      case 'campaign_record':
        return 'Campaign oral recording captured with land-season context.';
      case 'keeper_approve_seed':
        return 'Keeper approved seed; promoteAfterApproval indexed all corpora.';
      case 'corpus_promotion':
        return 'Corpus promotion mirror verified across lexeme/phrase/lesson/search.';
      case 'search_land_seeded':
        return 'Search "land" returned seeded elder phrase with geo badge.';
      default:
        return 'Journey step observed with protocol compliance.';
    }
  }

  List<String> _protocolsForStep(String step) {
    const base = ['1', '2', '8', '9'];
    switch (step) {
      case 'search_land':
        return [...base, '6', '7'];
      case 'offline_toggle':
        return [...base, '4', '5'];
      case 'mode_switch':
        return [...base, '3', '11'];
      case 'seeding_dashboard':
      case 'campaign_record':
      case 'keeper_approve_seed':
      case 'corpus_promotion':
        return [...base, '6', '7'];
      case 'search_land_seeded':
        return [...base, '6', '7'];
      default:
        return base;
    }
  }

  /// Formats tribal council report from simulation result.
  static String formatCouncilReport(PilotSimulationResult result) {
    final buffer = StringBuffer()
      ..writeln('=== Kuttiomp Pilot Simulation Report ($version) ===')
      ..writeln('Households simulated: ${result.deviceCount}')
      ..writeln('Journey steps per household: ${result.journeyStepCount}')
      ..writeln('Total observations: ${result.observations.length}')
      ..writeln('Sign-off status: ${result.signoff.status.id}')
      ..writeln('Protocol coverage: ${result.signoff.protocolCoverage}')
      ..writeln('Keeper: ${result.signoff.keeperName}')
      ..writeln('Proclamation: ${result.signoff.proclamation}')
      ..writeln('================================================');
    return buffer.toString();
  }
}

/// Result of a full pilot simulation run.
class PilotSimulationResult {
  const PilotSimulationResult({
    required this.observations,
    required this.signoff,
    required this.deviceCount,
    required this.journeyStepCount,
  });

  final List<PilotObservation> observations;
  final PilotSignoffRecord signoff;
  final int deviceCount;
  final int journeyStepCount;
}