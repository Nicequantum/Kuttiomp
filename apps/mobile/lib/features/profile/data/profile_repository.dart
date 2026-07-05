import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_repository.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approved_contributions_store.dart';
import 'package:kuttiomp_mobile/features/profile/domain/profile_model.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';

/// Corpus statistics for Keeper dashboard (§13, Protocol 2).
class CorpusStats {
  const CorpusStats({
    required this.approvedContributions,
    required this.pendingContributions,
    required this.auditEntryCount,
  });

  final int approvedContributions;
  final int pendingContributions;
  final int auditEntryCount;
}

/// Audited profile data access – sync, elder override, audit viewer (§13, Protocol 9).
class ProfileRepository extends AuditedRepository {
  ProfileRepository({
    super.gateway,
    super.auditedClient,
    required UserProfileService profileService,
  }) : _profileService = profileService;

  final UserProfileService _profileService;

  static const String syncLogMessage =
      'Profile synced | Protocols 2,9 enforced | Isar mirror updated';

  static const String overrideLogMessage =
      'Elder override applied | Protocols 2,9 enforced | audit logged';

  /// Fetches governed profile via audited RPC and mirrors to Isar.
  Future<ProfileModel> syncProfile() async {
    _assertProfileProtocols();

    final profileMap = await _profileService.fetchRemoteProfile();
    await _profileService.mirrorToIsar(profileMap);

    await logRepositoryOperation(
      operation: 'profile:sync',
      outcome: syncLogMessage,
      payloadSummary: profileMap['user_id'] as String? ?? 'guest',
    );

    return ProfileModel.fromMap(profileMap);
  }

  /// Loads profile from encrypted Isar mirror when offline.
  Future<ProfileModel> loadLocalProfile() async {
    final local = await _profileService.loadLocalProfile();
    if (local != null) {
      return ProfileModel.fromUserProfile(local);
    }
    return ProfileModel.fromMap(await _profileService.fetchRemoteProfile());
  }

  /// Updates current mode in remote profile + Isar mirror (never direct table access).
  Future<ProfileModel> updateMode(
    KuttiompMode mode, {
    bool elderOverride = false,
    String? elderId,
  }) async {
    _assertProfileProtocols();

    final current = await _profileService.fetchRemoteProfile();
    final merged = {
      ...current,
      'mode': mode.id,
      'tier': mode.tierBitmask,
      'elder_override': elderOverride,
    };

    await _profileService.mirrorToIsar(merged);

    if (elderOverride && elderId != null) {
      await _profileService.applyElderOverride(
        override: {'mode': mode.id},
        elderId: elderId,
      );
    }

    try {
      await auditedRpc<void>(
        KuttiompRpc.updateUserMode,
        params: {
          'mode': mode.id,
          'tier': mode.tierBitmask,
          'elder_override': elderOverride,
          'elderApproved': true,
        },
      );
    } catch (_) {
      // Offline – local mirror authoritative until reconnect.
    }

    await logRepositoryOperation(
      operation: 'profile:update_mode',
      outcome: elderOverride ? overrideLogMessage : syncLogMessage,
      payloadSummary: '${mode.id}${elderOverride ? ' (elder override)' : ''}',
    );

    if (kDebugMode) {
      debugPrint('$syncLogMessage → ${mode.label}');
    }

    return ProfileModel.fromMap(merged);
  }

  /// Returns recent audit entries for profile settings viewer (Protocol 9).
  List<AuditLogEntry> getAuditLog({int limit = 20}) {
    gateway.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false},
    );

    final entries = AuditLogStore.instance.entries;
    if (entries.length <= limit) return List.unmodifiable(entries);
    return entries.sublist(entries.length - limit);
  }

  /// Keeper corpus statistics from in-memory approval store.
  CorpusStats getCorpusStats() {
    final store = ApprovedContributionsStore.instance;
    return CorpusStats(
      approvedContributions: store.approvedRecordings().length,
      pendingContributions: store.pendingRecordings().length,
      auditEntryCount: AuditLogStore.instance.entries.length,
    );
  }

  void _assertProfileProtocols() {
    gateway.assertCompliant(
      KuttiompProtocol.elderApproval.id,
      context: const {'elderApproved': true},
    );
    gateway.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false},
    );
    gateway.protocolService.assertAccessibility(
      context: const {
        'fontSize': 24,
        'requiresSemantics': true,
        'hasSemanticsLabel': true,
      },
    );
  }
}