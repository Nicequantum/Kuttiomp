import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/di/injection.dart';
import 'package:kuttiomp_mobile/core/di/isar_database.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_client.dart';
import 'package:kuttiomp_mobile/features/auth/auth_service.dart';
import 'package:kuttiomp_mobile/features/profile/domain/user_profile.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';

/// Profile persistence orchestrator – Supabase RPC + encrypted Isar mirror (§13).
class UserProfilePersistence {
  UserProfilePersistence({
    required this.profileService,
    KuttiompProtocolService? protocolService,
  }) : _protocolService = protocolService ?? KuttiompProtocolService.instance;

  final UserProfileService profileService;
  final KuttiompProtocolService _protocolService;

  UserMasterySummary lastMastery = UserMasterySummary.empty;
  bool profilePersisted = false;
  String? lastSyncLog;

  UserProfile? lastProfile;

  /// Syncs profile from audited RPC into encrypted Isar mirror with Protocol 9 audit.
  Future<UserMasterySummary> syncWithSupabase() async {
    _protocolService.assertCompliant(
      '9',
      context: const {'direct_table_access': false},
    );

    final profileMap = await profileService.fetchRemoteProfile();
    lastMastery = await profileService.mirrorToIsar(profileMap);
    lastProfile = UserProfile.fromMap(profileMap);
    profilePersisted = true;
    lastSyncLog = 'Profile sync log: ${profileMap['user_id']} mirrored | Protocol 9 audit';

    return lastMastery;
  }

  /// Loads profile from offline Isar mirror when remote unavailable.
  Future<UserProfile> loadProfile() async {
    final local = await profileService.loadLocalProfile();
    if (local != null) {
      lastProfile = local;
      final mastery = await profileService.loadLocalMastery();
      if (mastery != null) lastMastery = mastery;
      return local;
    }
    final remote = await profileService.fetchRemoteProfile();
    lastProfile = UserProfile.fromMap(remote);
    return lastProfile!;
  }

  /// Simulates elder remote override for dev verification.
  Future<void> simulateElderOverride({
    required String mode,
    required String elderId,
  }) async {
    await profileService.applyElderOverride(
      override: {'mode': mode},
      elderId: elderId,
    );
    lastSyncLog = 'Elder override simulation: audit entry logged';
  }
}

final kuttiompAuthServiceProvider = Provider<KuttiompAuthService>((ref) {
  return KuttiompAuthService(
    protocolService: ref.watch(protocolServiceProvider),
    client: ref.watch(auditedClientProvider)?.rawClient,
    auditedClient: ref.watch(auditedClientProvider),
  );
});

final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  return UserProfileService(
    authService: ref.watch(kuttiompAuthServiceProvider),
    auditedClient: ref.watch(auditedClientProvider),
    protocolService: ref.watch(protocolServiceProvider),
    isar: ref.watch(isarInstanceProvider),
  );
});

final userProfilePersistenceProvider = Provider<UserProfilePersistence>((ref) {
  return UserProfilePersistence(
    profileService: ref.watch(userProfileServiceProvider),
    protocolService: ref.watch(protocolServiceProvider),
  );
});

/// Holds bootstrap mastery summary for dashboard petals.
final userMasteryProvider = StateProvider<UserMasterySummary>(
  (ref) => UserMasterySummary.empty,
);

/// Governed user profile for dashboard header and profile page.
final userProfileProvider = StateProvider<UserProfile>(
  (ref) => UserProfile.guest,
);