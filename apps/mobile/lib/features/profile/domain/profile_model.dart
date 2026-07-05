import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/features/profile/domain/user_profile.dart';

/// Accessibility and offline preference flags (§8, §11, §13).
@immutable
class ProfilePreferences {
  const ProfilePreferences({
    this.highContrastEnabled = true,
    this.elderAccessibilityOverlay = false,
    this.audioNarrationEnabled = true,
    this.offlineQuotaMb = 256,
  });

  final bool highContrastEnabled;
  final bool elderAccessibilityOverlay;
  final bool audioNarrationEnabled;
  final int offlineQuotaMb;

  factory ProfilePreferences.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const ProfilePreferences();
    return ProfilePreferences(
      highContrastEnabled: map['high_contrast_enabled'] as bool? ?? true,
      elderAccessibilityOverlay: map['elder_accessibility_overlay'] as bool? ?? false,
      audioNarrationEnabled: map['audio_narration_enabled'] as bool? ?? true,
      offlineQuotaMb: map['offline_quota_mb'] as int? ?? 256,
    );
  }

  Map<String, dynamic> toMap() => {
        'high_contrast_enabled': highContrastEnabled,
        'elder_accessibility_overlay': elderAccessibilityOverlay,
        'audio_narration_enabled': audioNarrationEnabled,
        'offline_quota_mb': offlineQuotaMb,
      };

  ProfilePreferences copyWith({
    bool? highContrastEnabled,
    bool? elderAccessibilityOverlay,
    bool? audioNarrationEnabled,
    int? offlineQuotaMb,
  }) {
    return ProfilePreferences(
      highContrastEnabled: highContrastEnabled ?? this.highContrastEnabled,
      elderAccessibilityOverlay: elderAccessibilityOverlay ?? this.elderAccessibilityOverlay,
      audioNarrationEnabled: audioNarrationEnabled ?? this.audioNarrationEnabled,
      offlineQuotaMb: offlineQuotaMb ?? this.offlineQuotaMb,
    );
  }
}

/// Governed profile record with mode prefs, accessibility flags, and quota (§13).
@immutable
class ProfileModel {
  const ProfileModel({
    required this.userId,
    required this.mode,
    required this.clan,
    required this.role,
    required this.tier,
    required this.canonicalStage,
    required this.wordCount,
    required this.modeProgress,
    required this.preferences,
    this.elderOverride = false,
    this.lastSyncedAt,
  });

  final String userId;
  final String mode;
  final String clan;
  final String role;
  final int tier;
  final String canonicalStage;
  final int wordCount;
  final Map<String, int> modeProgress;
  final ProfilePreferences preferences;
  final bool elderOverride;
  final DateTime? lastSyncedAt;

  KuttiompMode get kuttiompMode => KuttiompMode.fromId(mode);

  MasteryStage get masteryStage => MasteryStage.fromId(canonicalStage);

  int progressFor(KuttiompMode m) => modeProgress[m.id] ?? 0;

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    final raw = map['mode_progress'];
    final progress = <String, int>{};
    if (raw is Map) {
      raw.forEach((key, value) {
        progress[key.toString()] = value is int ? value : int.tryParse('$value') ?? 0;
      });
    }

    return ProfileModel(
      userId: map['user_id'] as String? ?? 'guest-kuttiomp',
      mode: map['mode'] as String? ?? KuttiompMode.littleOnes.id,
      clan: map['clan'] as String? ?? 'kuttiomp_clan',
      role: map['role'] as String? ?? 'learner',
      tier: map['tier'] as int? ?? KuttiompMode.littleOnes.tierBitmask,
      canonicalStage: map['canonical_stage'] as String? ?? MasteryStage.awakening.id,
      wordCount: map['word_count'] as int? ?? 0,
      modeProgress: progress,
      preferences: ProfilePreferences.fromMap(
        map['preferences'] is Map ? Map<String, dynamic>.from(map['preferences'] as Map) : null,
      ),
      elderOverride: map['elder_override'] as bool? ?? false,
      lastSyncedAt: map['last_synced_at'] is DateTime
          ? map['last_synced_at'] as DateTime
          : null,
    );
  }

  factory ProfileModel.fromUserProfile(
    UserProfile profile, {
    ProfilePreferences? preferences,
  }) {
    return ProfileModel(
      userId: profile.userId,
      mode: profile.mode,
      clan: profile.clan,
      role: profile.role,
      tier: profile.tier,
      canonicalStage: profile.canonicalStage,
      wordCount: profile.wordCount,
      modeProgress: profile.modeProgress,
      preferences: preferences ?? const ProfilePreferences(),
      elderOverride: profile.elderOverride,
      lastSyncedAt: profile.lastSyncedAt,
    );
  }

  UserProfile toUserProfile() => UserProfile(
        userId: userId,
        mode: mode,
        clan: clan,
        role: role,
        tier: tier,
        canonicalStage: canonicalStage,
        wordCount: wordCount,
        modeProgress: modeProgress,
        elderOverride: elderOverride,
        lastSyncedAt: lastSyncedAt,
      );

  Map<String, dynamic> toMap() => {
        'user_id': userId,
        'mode': mode,
        'clan': clan,
        'role': role,
        'tier': tier,
        'canonical_stage': canonicalStage,
        'word_count': wordCount,
        'mode_progress': modeProgress,
        'preferences': preferences.toMap(),
        'elder_override': elderOverride,
        if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt!.toIso8601String(),
      };

  ProfileModel copyWith({
    String? mode,
    int? tier,
    String? role,
    bool? elderOverride,
    ProfilePreferences? preferences,
    DateTime? lastSyncedAt,
  }) {
    return ProfileModel(
      userId: userId,
      mode: mode ?? this.mode,
      clan: clan,
      role: role ?? this.role,
      tier: tier ?? this.tier,
      canonicalStage: canonicalStage,
      wordCount: wordCount,
      modeProgress: modeProgress,
      preferences: preferences ?? this.preferences,
      elderOverride: elderOverride ?? this.elderOverride,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  static ProfileModel guest = ProfileModel.fromUserProfile(UserProfile.guest);
}