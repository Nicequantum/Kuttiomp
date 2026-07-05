import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/di/injection.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/features/auth/auth_service.dart';
import 'package:kuttiomp_mobile/features/profile/data/profile_repository.dart';
import 'package:kuttiomp_mobile/features/profile/domain/mode_persistence_service.dart';
import 'package:kuttiomp_mobile/features/profile/domain/profile_model.dart';
import 'package:kuttiomp_mobile/features/profile/domain/user_profile.dart';
import 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';

export 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    gateway: ref.watch(protocolGatewayProvider),
    auditedClient: ref.watch(auditedClientProvider),
    profileService: ref.watch(userProfileServiceProvider),
  );
});

final modePersistenceServiceProvider = Provider<ModePersistenceService>((ref) {
  return ModePersistenceService(
    profileRepository: ref.watch(profileRepositoryProvider),
    authService: ref.watch(kuttiompAuthServiceProvider),
    protocolService: ref.watch(protocolServiceProvider),
    modeController: ref.read(modeControllerProvider.notifier),
  );
});

final profileModelProvider = StateProvider<ProfileModel>(
  (ref) => ProfileModel.guest,
);

final profilePreferencesProvider = StateProvider<ProfilePreferences>(
  (ref) => const ProfilePreferences(),
);

final profileAuditLogProvider = Provider<List<AuditLogEntry>>((ref) {
  return ref.watch(profileRepositoryProvider).getAuditLog();
});

final corpusStatsProvider = Provider<CorpusStats>((ref) {
  return ref.watch(profileRepositoryProvider).getCorpusStats();
});

final profileSyncProvider = FutureProvider<ProfileModel>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  final model = await repository.syncProfile();
  ref.read(profileModelProvider.notifier).state = model;
  ref.read(userProfileProvider.notifier).state = model.toUserProfile();
  ref.read(userMasteryProvider.notifier).state = UserMasterySummary(
    canonicalStage: model.canonicalStage,
    wordCount: model.wordCount,
    modeProgress: model.modeProgress,
  );
  return model;
});

/// Switches mode with full persistence stack (§13).
final modeSwitchProvider = FutureProvider.family<ProfileModel, KuttiompMode>((ref, mode) async {
  final service = ref.watch(modePersistenceServiceProvider);
  final model = await service.persistAndSyncMode(mode);
  ref.read(profileModelProvider.notifier).state = model;
  ref.read(userProfileProvider.notifier).state = model.toUserProfile();
  return model;
});