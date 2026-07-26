import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';

/// Pilot cohort observation status through Keeper review (vRollout-1.0).
enum PilotSignoffStatus {
  pending('pending'),
  keeperReview('keeper_review'),
  approvedReadyForScale('approved_ready_for_scale'),
  needsRevision('needs_revision');

  const PilotSignoffStatus(this.id);

  final String id;

  static PilotSignoffStatus fromId(String? raw) {
    return PilotSignoffStatus.values.firstWhere(
      (s) => s.id == raw,
      orElse: () => PilotSignoffStatus.pending,
    );
  }
}

/// Structured day-in-the-life observation from a pilot household (§1 validation).
@immutable
class PilotObservation {
  const PilotObservation({
    required this.id,
    required this.householdId,
    required this.observerRole,
    required this.mode,
    required this.deviceType,
    required this.journeyStep,
    required this.observation,
    required this.protocolsEnforced,
    required this.speakerMetadata,
    this.elderApproved = true,
    this.voiceFeedbackAudioId,
    this.screenshotRef,
    this.timestamp,
  });

  final String id;
  final String householdId;
  final String observerRole;
  final KuttiompMode mode;
  final String deviceType;
  final String journeyStep;
  final String observation;
  final List<String> protocolsEnforced;
  final Map<String, dynamic> speakerMetadata;
  final bool elderApproved;
  final String? voiceFeedbackAudioId;
  final String? screenshotRef;
  final DateTime? timestamp;

  Map<String, dynamic> toJson() => {
        'id': id,
        'household_id': householdId,
        'observer_role': observerRole,
        'mode': mode.id,
        'device_type': deviceType,
        'journey_step': journeyStep,
        'observation': observation,
        'protocols_enforced': protocolsEnforced,
        'speaker_metadata': speakerMetadata,
        'elder_approved': elderApproved,
        if (voiceFeedbackAudioId != null) 'voice_feedback_audio_id': voiceFeedbackAudioId,
        if (screenshotRef != null) 'screenshot_ref': screenshotRef,
        'timestamp': (timestamp ?? DateTime.now().toUtc()).toIso8601String(),
      };

  factory PilotObservation.fromJson(Map<String, dynamic> json) {
    final protocols = <String>[];
    final raw = json['protocols_enforced'];
    if (raw is List) {
      for (final item in raw) {
        protocols.add(item.toString());
      }
    }

    final speakerRaw = json['speaker_metadata'];
    final speaker = speakerRaw is Map<String, dynamic>
        ? Map<String, dynamic>.from(speakerRaw)
        : <String, dynamic>{
            'speaker_id': json['observer_id'] ?? 'pilot-observer',
            'name': json['observer_name'] ?? 'Pilot Observer',
            'authority_source': 'elder',
          };

    return PilotObservation(
      id: json['id'] as String? ?? 'pilot-obs-unknown',
      householdId: json['household_id'] as String? ?? 'household-unknown',
      observerRole: json['observer_role'] as String? ?? 'observer',
      mode: KuttiompMode.fromId(
        json['mode'] as String? ?? KuttiompMode.littleOnes.id,
      ),
      deviceType: json['device_type'] as String? ?? 'android_phone',
      journeyStep: json['journey_step'] as String? ?? 'unspecified',
      observation: json['observation'] as String? ?? '',
      protocolsEnforced: protocols,
      speakerMetadata: speaker,
      elderApproved: json['elder_approved'] as bool? ?? true,
      voiceFeedbackAudioId: json['voice_feedback_audio_id'] as String?,
      screenshotRef: json['screenshot_ref'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString())
          : null,
    );
  }
}

/// Keeper sign-off record after pilot cohort review.
@immutable
class PilotSignoffRecord {
  const PilotSignoffRecord({
    required this.cohortId,
    required this.keeperId,
    required this.keeperName,
    required this.status,
    required this.observationCount,
    required this.protocolCoverage,
    required this.timestamp,
    required this.proclamation,
  });

  final String cohortId;
  final String keeperId;
  final String keeperName;
  final PilotSignoffStatus status;
  final int observationCount;
  final String protocolCoverage;
  final DateTime timestamp;
  final String proclamation;

  bool get isApprovedForScale => status == PilotSignoffStatus.approvedReadyForScale;
}