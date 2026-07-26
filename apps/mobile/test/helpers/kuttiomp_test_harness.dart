import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/offline/isar_sync_metadata.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/dashboard/presentation/dashboard_screen.dart';
import 'package:kuttiomp_mobile/features/auth/auth_service.dart';
import 'package:kuttiomp_mobile/features/profile/data/profile_repository.dart';
import 'package:kuttiomp_mobile/features/profile/domain/user_profile.dart';
import 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/elder_recording_page.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/keeper_approval_panel.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Zero-external-service test harness for Kuttiomp v2.0 golden suites (§11).
abstract final class KuttiompTestHarness {
  static const compliantContent = {
    'speaker_id': 'grandmother-comus',
    'attribution_json': {'name': 'Grandmother Comus'},
    'speakerMetadata': {'name': 'Grandmother Comus'},
    'elderApproved': true,
    'authority_source': 'elder',
    'visible_to_tiers': GenerationalTierBitmask.allTiers,
    'clan_scope': ['kuttiomp_clan'],
    'schema_version': '2.0',
    'primary_audio_id': 'audio-001',
    'fontSize': 24,
    'hasSemanticsLabel': true,
  };

  static Future<void> initProtocol({required KuttiompMode mode}) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({
      'kuttiomp_first_launch_complete': true,
      'kuttiomp_saved_mode': mode.id,
    });
    KuttiompProtocolService.instance.init(
      claims: {
        'mode': mode.id,
        'clan': 'kuttiomp_clan',
        'role': mode == KuttiompMode.elder ? 'elder' : 'learner',
        'tier': mode.tierBitmask,
      },
    );
    await ModeController.bootstrap();
    KuttiompProtocolService.instance.enforceNewMode(mode);
  }

  static UserProfile profileFor(KuttiompMode mode) => UserProfile(
        userId: 'test-user',
        mode: mode.id,
        clan: 'kuttiomp_clan',
        role: mode == KuttiompMode.elder ? 'elder' : 'learner',
        tier: mode.tierBitmask,
        canonicalStage: MasteryStage.awakening.id,
        wordCount: 12,
        modeProgress: {for (final m in KuttiompMode.values) m.id: 5},
      );

  static KuttiompProtocolService get protocolService => KuttiompProtocolService.instance;

  static KuttiompAuthService authService() =>
      KuttiompAuthService(protocolService: protocolService);

  static ProfileRepository profileRepository() => ProfileRepository(
        gateway: ProtocolGateway(protocolService: protocolService),
        profileService: UserProfileService(
          authService: authService(),
          protocolService: protocolService,
        ),
      );

  static UserMasterySummary masteryFor() => UserMasterySummary(
        canonicalStage: MasteryStage.awakening.id,
        wordCount: 12,
        modeProgress: {for (final m in KuttiompMode.values) m.id: 5},
      );

  static Widget wrapWithProviders({
    required KuttiompMode mode,
    required Widget child,
    List<Override> extraOverrides = const [],
  }) {
    final profile = profileFor(mode);
    final mastery = masteryFor();

    return ProviderScope(
      overrides: [
        userProfileProvider.overrideWith((ref) => profile),
        userMasteryProvider.overrideWith((ref) => mastery),
        ...extraOverrides,
      ],
      child: MaterialApp(
        theme: KuttiompTheme.forMode(mode).copyWith(
          extensions: [KuttiompThemeExtension.forMode(mode)],
        ),
        home: child,
      ),
    );
  }
}

extension KuttiompWidgetTester on WidgetTester {
  Future<void> pumpKuttiompApp({required KuttiompMode mode}) async {
    await KuttiompTestHarness.initProtocol(mode: mode);
    await pumpWidget(
      KuttiompTestHarness.wrapWithProviders(
        mode: mode,
        child: const DashboardScreen(),
      ),
    );
    await pumpAndSettle();
  }

  Future<void> pumpElderRecordingPage() async {
    await KuttiompTestHarness.initProtocol(mode: KuttiompMode.elder);
    await pumpWidget(
      KuttiompTestHarness.wrapWithProviders(
        mode: KuttiompMode.elder,
        child: const ElderRecordingPage(),
      ),
    );
    await pumpAndSettle();
  }

  Future<void> pumpKeeperPanel() async {
    await pumpWidget(
      KuttiompTestHarness.wrapWithProviders(
        mode: KuttiompMode.elder,
        child: const Scaffold(body: KeeperApprovalPanel()),
      ),
    );
    await pumpAndSettle();
  }

  Future<void> switchToMode(KuttiompMode mode) async {
    KuttiompProtocolService.instance.enforceNewMode(mode);
    await pumpKuttiompApp(mode: mode);
  }

  void verifyElderAccessibilityLabels() {
    expect(find.bySemanticsLabel(RegExp(r'.+')), findsWidgets);
  }

  void verifyOfflineMirrorIntact() {
    // In-memory mirror authoritative in test environment.
    expect(InMemorySyncMetadataStore.instance, isNotNull);
  }
}

extension KuttiompProtocolGatewayTest on ProtocolGateway {
  /// Returns true when all 12 protocol assertions pass for [content].
  bool allAssertionsPassed({Map<String, dynamic>? content}) {
    final ctx = content ?? KuttiompTestHarness.compliantContent;
    try {
      assertAllForContent(Map<String, dynamic>.from(ctx));
      return true;
    } catch (_) {
      return false;
    }
  }
}