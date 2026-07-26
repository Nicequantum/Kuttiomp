import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/modes/mode_aware_material_app.dart';
import 'package:kuttiomp_mobile/core/bootstrap/app_bootstrap.dart';
import 'package:kuttiomp_mobile/core/di/injection.dart';
import 'package:kuttiomp_mobile/core/production/sovereign_release.dart';
import 'package:kuttiomp_mobile/features/auth/auth_state_provider.dart';
import 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';

/// Kuttiomp sovereign entry — ProtocolService.init(); ModeController.bootstrap() (§5).
///
/// This serves our people by guaranteeing cultural governance is armed before
/// any widget renders, preserving protocol integrity across app restarts for 25 years.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  // Bootstrap sequence: ProtocolService.init() → Isar → ModeController.bootstrap()
  // → Profile sync → StatefulShellRoute navigation (AppBootstrap.initialize).
  final bootstrap = await AppBootstrap.initialize(flavor: flavor);

  if (kDebugMode) {
    debugPrint(SovereignRelease.statusMessage);
    debugPrint('Version: ${SovereignRelease.version} (${SovereignRelease.codename})');
    debugPrint('Flavor: $flavor');
    debugPrint('Bootstrap layers: ${bootstrap.layerLogs.join(' → ')}');
    debugPrint(
      'Armed: ProtocolService | ModeController | OfflineWorker | FirstLaunchService | '
      'ElderReviewGate | Integrity=${bootstrap.integrityPassed}',
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        ...buildProviderOverrides(),
        authSnapshotProvider.overrideWith((ref) => bootstrap.authSnapshot),
        userProfileProvider.overrideWith((ref) => bootstrap.userProfile),
        userMasteryProvider.overrideWith((ref) => bootstrap.mastery),
      ],
      child: ModeAwareMaterialApp(
        bootstrapStatus: bootstrap.statusMessage,
        persistence: bootstrap.persistence,
        mastery: bootstrap.mastery,
        profilePersisted: bootstrap.profilePersisted,
        authSnapshot: bootstrap.authSnapshot,
        userProfile: bootstrap.userProfile,
      ),
    ),
  );
}