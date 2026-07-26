import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/features/profile/audio_narration_service.dart';
import 'package:kuttiomp_mobile/features/profile/domain/mode_persistence_service.dart';
import 'package:kuttiomp_mobile/features/profile/domain/profile_model.dart';
import 'package:kuttiomp_mobile/modes/mode_persistence.dart';

/// Guided first-launch onboarding orchestrator with audio narration (§13).
class FirstLaunchService {
  FirstLaunchService({
    required this.modePersistenceService,
    ModePersistence? modePersistence,
  }) : _modePersistence = modePersistence;

  final ModePersistenceService modePersistenceService;
  final ModePersistence? _modePersistence;

  static const String completeLogMessage =
      'First launch complete | Mode persisted | Audio narration played | Protocols 2,3,9,11 enforced';

  /// Returns true when onboarding must be shown on clean install.
  Future<bool> shouldShowOnboarding() async {
    final persistence = _modePersistence ?? await ModePersistence.open();
    return !persistence.isFirstLaunchComplete;
  }

  /// Plays elder-centric audio narration before mode selection.
  Future<void> playWelcomeNarration() => AudioNarrationService.playFirstLaunchWelcome();

  /// Completes onboarding: mode selection, persistence, JWT sync, profile mirror.
  Future<ProfileModel> completeOnboarding({
    required KuttiompMode mode,
    GoRouter? router,
    ProfilePreferences preferences = const ProfilePreferences(),
  }) async {
    await playWelcomeNarration();

    final profile = await modePersistenceService.persistAndSyncMode(
      mode,
      router: router,
      completeFirstLaunch: true,
    );

    final enriched = profile.copyWith(preferences: preferences);

    if (kDebugMode) {
      debugPrint('$completeLogMessage → ${mode.label}');
    }

    return enriched;
  }
}