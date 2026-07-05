import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_repository.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approved_contributions_store.dart';
import 'package:kuttiomp_mobile/features/profile/domain/elder_recording_model.dart';

/// Mobile-side elder audio upload stub with Protocol 2 pending gate (§6, Protocol 2,7,8).
class RecordingService extends AuditedRepository {
  RecordingService({super.gateway, super.auditedClient});

  static const String submitLogMessage =
      'Recording submitted | Protocol 2 pending elder review';

  static const String uploadStubPath = 'assets/audio/elder_upload_stub.mp3';

  /// Simulates capturing oral audio; returns governed metadata (Protocol 7).
  Future<ElderRecordingModel> captureRecording({
    required String word,
    required String translation,
    required String speakerId,
    required String speakerName,
    String contentType = 'lexeme',
    String canonicalStage = 'awakening',
    Map<String, dynamic>? campaignMetadata,
    Duration simulatedDuration = const Duration(seconds: 3),
  }) async {
    gateway.assertCompliant(
      KuttiompProtocol.oralTraditionPrimacy.id,
      context: {
        'primary_audio_id': 'audio-elder-capture-${DateTime.now().millisecondsSinceEpoch}',
        'text_only': false,
      },
    );

    final mode = gateway.protocolService.currentMode;
    if (mode != KuttiompMode.elder) {
      throw ProtocolViolationException(
        '3',
        respectfulMessage:
            'Elder recordings are available in Elder learning path only.',
      );
    }

    if (kDebugMode) {
      debugPrint(
        'Recording capture stub: $word ($simulatedDuration) → $uploadStubPath',
      );
    }

    return ElderRecordingModel(
      id: 'recording-${DateTime.now().millisecondsSinceEpoch}',
      word: word,
      translation: translation,
      speakerMetadata: {
        'speaker_id': speakerId,
        'name': speakerName,
        'authority_source': 'elder',
        if (campaignMetadata != null) ...campaignMetadata,
      },
      primaryAudioId: 'audio-elder-${DateTime.now().millisecondsSinceEpoch}',
      contentType: contentType,
      status: RecordingApprovalStatus.draft,
      canonicalStage: canonicalStage,
      visibleToTiers: GenerationalTierBitmask.allTiers,
    );
  }

  /// Submits recording for elder approval chain (Protocol 2 pending).
  Future<ElderRecordingModel> submitForApproval(ElderRecordingModel draft) async {
    gateway.assertSpeakerPresent(context: draft.toContentContext());
    gateway.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false},
    );

    // Pending submissions must NOT pass elderApproved gate yet.
    try {
      gateway.assertElderApproved(context: {'elderApproved': false});
    } on ProtocolViolationException {
      // Expected – content awaits keeper review.
    }

    final pending = draft.copyWith(
      status: RecordingApprovalStatus.pending,
      elderApproved: false,
      submittedAt: DateTime.now().toUtc(),
    );

    try {
      await auditedRpc<void>(
        KuttiompRpc.submitElderRecording,
        params: {
          'recording_id': pending.id,
          'word': pending.word,
          'translation': pending.translation,
          'primary_audio_id': pending.primaryAudioId,
          'content_type': pending.contentType,
          'canonical_stage': pending.canonicalStage,
          'elderApproved': false,
        },
      );
    } catch (_) {
      // Offline stub – local pending queue authoritative until sync.
    }

    ApprovedContributionsStore.instance.submitPending(pending);

    await logRepositoryOperation(
      operation: 'recording:submit',
      outcome: submitLogMessage,
      payloadSummary: pending.id,
    );
    if (kDebugMode) debugPrint('$submitLogMessage (${pending.id})');

    return pending;
  }
}