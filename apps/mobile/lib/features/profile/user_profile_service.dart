import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/di/isar_database.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_client.dart';
import 'package:kuttiomp_mobile/core/supabase/isar_schemas.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/features/auth/auth_service.dart';
import 'package:kuttiomp_mobile/features/profile/domain/user_profile.dart';

/// Fetches and mirrors user profile + mastery via audited RPCs (§13, Protocol 9).
class UserProfileService {
  UserProfileService({
    required this.authService,
    AuditedSupabaseClient? auditedClient,
    KuttiompProtocolService? protocolService,
    Isar? isar,
  })  : _auditedClient = auditedClient,
        _protocolService = protocolService ?? KuttiompProtocolService.instance,
        _isar = isar;

  final KuttiompAuthService authService;
  final AuditedSupabaseClient? _auditedClient;
  final KuttiompProtocolService _protocolService;
  final Isar? _isar;

  static const String defaultStage = 'awakening';

  /// Encrypts profile payload for Isar mirror (clan-key derivation stub).
  static String encryptedMirror(Map<String, dynamic> profile) {
    final clan = profile['clan'] as String? ?? 'kuttiomp_clan';
    final role = profile['role'] as String? ?? 'learner';
    final key = IsarDatabase.deriveEncryptionKey(clanId: clan, role: role);
    final digest = sha256.convert(utf8.encode('$key:${jsonEncode(profile)}'));
    return digest.toString();
  }

  /// Fetches profile from secure RPC – never direct table access.
  Future<Map<String, dynamic>> fetchRemoteProfile() async {
    _protocolService.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false},
    );

    final client = _auditedClient ?? AuditedSupabaseClient.instance;
    if (client == null || !client.isInitialized) {
      return _localFallbackProfile();
    }

    try {
      final result = await client.rpc<Map<String, dynamic>>(
        KuttiompRpc.getUserProfile,
        params: {'elderApproved': true},
      );
      return Map<String, dynamic>.from(result);
    } catch (_) {
      return _localFallbackProfile();
    }
  }

  /// Reads encrypted Isar mirror for offline-first profile (§7).
  Future<UserProfile?> loadLocalProfile() async {
    final isar = _isar ?? IsarDatabase.instance;
    if (isar == null || !isar.isOpen) return null;

    final userId = authService.userId;
    final mirrors = await isar.userProfileMirrors.where().findAll();
    UserProfileMirror? mirror;
    for (final m in mirrors) {
      if (m.userId == userId) {
        mirror = m;
        break;
      }
    }
    if (mirror == null) return null;

    final mastery = await loadLocalMastery();
    return UserProfile(
      userId: mirror.userId,
      mode: mirror.mode,
      clan: mirror.clan,
      role: mirror.role,
      tier: mirror.tier,
      canonicalStage: mastery?.canonicalStage ?? defaultStage,
      wordCount: mastery?.wordCount ?? 0,
      modeProgress: mastery?.modeProgress ?? {},
      elderOverride: mirror.elderOverride,
      lastSyncedAt: mirror.lastSyncedAt,
    );
  }

  /// Reads unified mastery record from Isar mirror (§6).
  Future<UserMasterySummary?> loadLocalMastery() async {
    final isar = _isar ?? IsarDatabase.instance;
    if (isar == null || !isar.isOpen) return null;

    final userId = authService.userId;
    final mirrors = await isar.userMasteryMirrors.where().findAll();
    UserMasteryMirror? mirror;
    for (final m in mirrors) {
      if (m.userId == userId) {
        mirror = m;
        break;
      }
    }
    if (mirror == null) return null;

    final progressRaw = jsonDecode(mirror.modeProgressJson);
    final progress = <String, int>{};
    if (progressRaw is Map) {
      progressRaw.forEach((key, value) {
        progress[key.toString()] = value is int ? value : int.tryParse('$value') ?? 0;
      });
    }

    return UserMasterySummary(
      canonicalStage: mirror.canonicalStage,
      wordCount: mirror.wordCount,
      modeProgress: progress,
    );
  }

  Map<String, dynamic> _localFallbackProfile() {
    final claims = _protocolService.jwtClaims;
    final modeId = claims['mode'] as String? ?? KuttiompMode.littleOnes.id;
    final mode = KuttiompMode.fromId(modeId);
    return {
      'user_id': authService.userId,
      'mode': mode.id,
      'clan': claims['clan'] ?? 'kuttiomp_clan',
      'role': claims['role'] ?? 'learner',
      'tier': claims['tier'] ?? mode.tierBitmask,
      'canonical_stage': defaultStage,
      'word_count': 0,
      'mode_progress': {for (final m in KuttiompMode.values) m.id: 0},
    };
  }

  /// Writes encrypted mirror to Isar and returns mastery summary for dashboard petals.
  Future<UserMasterySummary> mirrorToIsar(Map<String, dynamic> profile) async {
    final isar = _isar ?? IsarDatabase.instance;
    if (isar == null || !isar.isOpen) {
      return UserMasterySummary.fromProfile(profile);
    }

    final userId = profile['user_id'] as String? ?? authService.userId;
    final now = DateTime.now().toUtc();

    final profileMirror = UserProfileMirror()
      ..userId = userId
      ..mode = profile['mode'] as String? ?? KuttiompMode.littleOnes.id
      ..clan = profile['clan'] as String? ?? 'kuttiomp_clan'
      ..role = profile['role'] as String? ?? 'learner'
      ..tier = profile['tier'] as int? ?? GenerationalTierBitmask.littleOnes
      ..encryptedPayload = encryptedMirror(profile)
      ..lastSyncedAt = now
      ..elderOverride = profile['elder_override'] as bool? ?? false;

    final masteryMirror = UserMasteryMirror()
      ..userId = userId
      ..canonicalStage = profile['canonical_stage'] as String? ?? defaultStage
      ..wordCount = profile['word_count'] as int? ?? 0
      ..modeProgressJson = jsonEncode(
        profile['mode_progress'] ?? {for (final m in KuttiompMode.values) m.id: 0},
      )
      ..lastSyncedAt = now;

    await isar.writeTxn(() async {
      await isar.userProfileMirrors.put(profileMirror);
      await isar.userMasteryMirrors.put(masteryMirror);
    });

    if (kDebugMode) {
      debugPrint('Profile sync: Isar mirror written for $userId');
    }

    return UserMasterySummary.fromProfile(profile);
  }

  /// Applies elder remote override with full Protocol 9 audit trail.
  Future<void> applyElderOverride({
    required Map<String, dynamic> override,
    required String elderId,
  }) async {
    _protocolService.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false, 'elder_override': true},
    );

    final profile = await fetchRemoteProfile();
    final merged = {...profile, ...override, 'elder_override': true};

    await mirrorToIsar(merged);

    await AuditLogStore.instance.log(
      AuditLogEntry(
        timestamp: DateTime.now().toUtc(),
        protocolId: KuttiompProtocol.dataSovereignty.id,
        operation: 'elder_override',
        outcome: 'applied',
        payloadSummary: 'elder=$elderId,mode=${override['mode']}',
      ),
    );

    final isar = _isar ?? IsarDatabase.instance;
    if (isar != null && isar.isOpen) {
      final entry = IsarAuditLogEntry()
        ..timestamp = DateTime.now().toUtc()
        ..protocolId = KuttiompProtocol.dataSovereignty.id
        ..operation = 'elder_override'
        ..outcome = 'applied'
        ..payloadSummary = 'elder=$elderId';
      await isar.writeTxn(() async {
        await isar.isarAuditLogEntrys.put(entry);
      });
    }

    if (kDebugMode) {
      debugPrint('Elder override audit: elder=$elderId applied');
    }
  }
}

/// Unified mastery record filtered view for dashboard petals (§6).
class UserMasterySummary {
  const UserMasterySummary({
    required this.canonicalStage,
    required this.wordCount,
    required this.modeProgress,
  });

  final String canonicalStage;
  final int wordCount;
  final Map<String, int> modeProgress;

  int progressFor(KuttiompMode mode) => modeProgress[mode.id] ?? 0;

  factory UserMasterySummary.fromProfile(Map<String, dynamic> profile) {
    final raw = profile['mode_progress'];
    final progress = <String, int>{};
    if (raw is Map) {
      raw.forEach((key, value) {
        progress[key.toString()] = value is int ? value : int.tryParse('$value') ?? 0;
      });
    } else {
      for (final mode in KuttiompMode.values) {
        progress[mode.id] = 0;
      }
    }
    return UserMasterySummary(
      canonicalStage: profile['canonical_stage'] as String? ?? UserProfileService.defaultStage,
      wordCount: profile['word_count'] as int? ?? 0,
      modeProgress: progress,
    );
  }

  static const UserMasterySummary empty = UserMasterySummary(
    canonicalStage: UserProfileService.defaultStage,
    wordCount: 0,
    modeProgress: {},
  );
}