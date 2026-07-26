import 'package:flutter/foundation.dart';

int stewardshipAsInt(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v?.toString() ?? '') ?? 0;
}

/// Absolute stewardship counts — Protocol 10 compliant (no scores/ranks).
///
/// This serves our people by honoring speaker labor as service, never as a game,
/// for 25 years of dignified language entry.
@immutable
class SpeakerStewardshipSummary {
  const SpeakerStewardshipSummary({
    required this.speakerId,
    required this.submittedCount,
    required this.pendingApprovalCount,
    required this.approvedLivingCount,
    this.lastContributionAt,
    required this.primaryAudioCount,
  });

  final String speakerId;
  final int submittedCount;
  final int pendingApprovalCount;
  final int approvedLivingCount;
  final DateTime? lastContributionAt;
  final int primaryAudioCount;

  factory SpeakerStewardshipSummary.fromJson(Map<String, dynamic> json) {
    return SpeakerStewardshipSummary(
      speakerId: json['speaker_id']?.toString() ?? 'unknown',
      submittedCount: stewardshipAsInt(json['submitted_count']),
      pendingApprovalCount: stewardshipAsInt(json['pending_approval_count']),
      approvedLivingCount: stewardshipAsInt(json['approved_living_count']),
      lastContributionAt: json['last_contribution_at'] != null
          ? DateTime.tryParse(json['last_contribution_at'].toString())
          : null,
      primaryAudioCount: stewardshipAsInt(json['primary_audio_count']),
    );
  }

  /// Offline sample for walkthrough — attributed, elder-approvable, non-sacred.
  static const sample = SpeakerStewardshipSummary(
    speakerId: 'grandmother-comus',
    submittedCount: 3,
    pendingApprovalCount: 0,
    approvedLivingCount: 3,
    lastContributionAt: null,
    primaryAudioCount: 3,
  );
}

/// Corpus continuity — absolute approved count only; target remains null.
@immutable
class CorpusContinuityMetrics {
  const CorpusContinuityMetrics({
    required this.totalApprovedLexemes,
    this.lastApprovedAt,
    this.targetLexemes,
    this.continuityPct,
  });

  final int totalApprovedLexemes;
  final DateTime? lastApprovedAt;

  /// Keeper-defined target; **null** until Keepers supply a value.
  final int? targetLexemes;

  /// null when [targetLexemes] is null — never invent a percentage.
  final double? continuityPct;

  bool get hasKeeperTarget => targetLexemes != null && targetLexemes! > 0;

  factory CorpusContinuityMetrics.fromJson(Map<String, dynamic> json) {
    final targetRaw = json['target_lexemes'];
    final pctRaw = json['continuity_pct'];
    return CorpusContinuityMetrics(
      totalApprovedLexemes: stewardshipAsInt(json['total_approved_lexemes']),
      lastApprovedAt: json['last_approved_at'] != null
          ? DateTime.tryParse(json['last_approved_at'].toString())
          : null,
      targetLexemes: targetRaw == null ? null : stewardshipAsInt(targetRaw),
      continuityPct: pctRaw == null ? null : double.tryParse(pctRaw.toString()),
    );
  }

  /// Offline sample for prototype walkthrough (no invented target).
  static const sample = CorpusContinuityMetrics(
    totalApprovedLexemes: 4,
    lastApprovedAt: null,
    targetLexemes: null,
    continuityPct: null,
  );
}