import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';

/// Governed user profile record (§13).
class UserProfile {
  const UserProfile({
    required this.userId,
    required this.mode,
    required this.clan,
    required this.role,
    required this.tier,
    required this.canonicalStage,
    required this.wordCount,
    required this.modeProgress,
    this.elderOverride = false,
    this.lastSyncedAt,
    this.seedingCohort,
    this.monitorSessionId,
  });

  final String userId;
  final String mode;
  final String clan;
  final String role;
  final int tier;
  final String canonicalStage;
  final int wordCount;
  final Map<String, int> modeProgress;
  final bool elderOverride;
  final DateTime? lastSyncedAt;
  final String? seedingCohort;
  final String? monitorSessionId;

  KuttiompMode get kuttiompMode => KuttiompMode.fromId(mode);

  MasteryStage get masteryStage => MasteryStage.fromId(canonicalStage);

  int progressFor(KuttiompMode m) => modeProgress[m.id] ?? 0;

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    final raw = map['mode_progress'];
    final progress = <String, int>{};
    if (raw is Map) {
      raw.forEach((key, value) {
        progress[key.toString()] = value is int ? value : int.tryParse('$value') ?? 0;
      });
    }
    return UserProfile(
      userId: map['user_id'] as String? ?? 'guest-kuttiomp',
      mode: map['mode'] as String? ?? KuttiompMode.littleOnes.id,
      clan: map['clan'] as String? ?? 'kuttiomp_clan',
      role: map['role'] as String? ?? 'learner',
      tier: map['tier'] as int? ?? KuttiompMode.littleOnes.tierBitmask,
      canonicalStage: map['canonical_stage'] as String? ?? MasteryStage.awakening.id,
      wordCount: map['word_count'] as int? ?? 0,
      modeProgress: progress,
      elderOverride: map['elder_override'] as bool? ?? false,
      lastSyncedAt: map['last_synced_at'] is DateTime
          ? map['last_synced_at'] as DateTime
          : null,
      seedingCohort: map['seeding_cohort'] as String?,
      monitorSessionId: map['monitor_session_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'user_id': userId,
        'mode': mode,
        'clan': clan,
        'role': role,
        'tier': tier,
        'canonical_stage': canonicalStage,
        'word_count': wordCount,
        'mode_progress': modeProgress,
        'elder_override': elderOverride,
        if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt!.toIso8601String(),
        if (seedingCohort != null) 'seeding_cohort': seedingCohort,
        if (monitorSessionId != null) 'monitor_session_id': monitorSessionId,
      };

  static const UserProfile guest = UserProfile(
    userId: 'guest-kuttiomp',
    mode: 'little_ones',
    clan: 'kuttiomp_clan',
    role: 'learner',
    tier: 1,
    canonicalStage: 'awakening',
    wordCount: 0,
    modeProgress: {},
  );
}