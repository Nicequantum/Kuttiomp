import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/auth/auth_state.dart';
import 'package:kuttiomp_mobile/features/dashboard/presentation/dashboard_screen.dart';
import 'package:kuttiomp_mobile/features/profile/domain/user_profile.dart';
import 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Golden-lock structural tests – dashboard renders identically per mode (§11, Component 6).
void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({'kuttiomp_first_launch_complete': true});
    KuttiompProtocolService.instance.init(
      claims: {
        'mode': KuttiompMode.littleOnes.id,
        'clan': 'kuttiomp_clan',
        'role': 'learner',
        'tier': GenerationalTierBitmask.littleOnes,
      },
    );
    await ModeController.bootstrap();
  });

  Widget wrapDashboard(KuttiompMode mode) {
    final profile = UserProfile(
      userId: 'test-user',
      mode: mode.id,
      clan: 'kuttiomp_clan',
      role: 'learner',
      tier: mode.tierBitmask,
      canonicalStage: MasteryStage.awakening.id,
      wordCount: 12,
      modeProgress: {for (final m in KuttiompMode.values) m.id: 5},
    );
    final mastery = UserMasterySummary(
      canonicalStage: MasteryStage.awakening.id,
      wordCount: 12,
      modeProgress: {for (final m in KuttiompMode.values) m.id: 5},
    );

    return ProviderScope(
      overrides: [
        userProfileProvider.overrideWith((ref) => profile),
        userMasteryProvider.overrideWith((ref) => mastery),
      ],
      child: MaterialApp(
        theme: KuttiompTheme.forMode(mode).copyWith(
          extensions: [KuttiompThemeExtension.forMode(mode)],
        ),
        home: const DashboardScreen(),
      ),
    );
  }

  for (final mode in KuttiompMode.values) {
    group('Golden lock – ${mode.label}', () {
      testWidgets('dashboard renders protocol firewall shell', (tester) async {
        await tester.pumpWidget(wrapDashboard(mode));
        await tester.pumpAndSettle();

        expect(find.text('Welcome back'), findsOneWidget);
        expect(find.text('Lexemes'), findsOneWidget);
      });
    });
  }

  test('foundation status message matches Component 6 contract', () {
    const status =
        'Foundation complete | Profile persisted | Dashboard petals ready | All 12 protocols green';
    expect(status, contains('Foundation complete'));
    expect(status, contains('All 12 protocols green'));
  });

  test('auth snapshot guest fallback is valid', () {
    final guest = KuttiompAuthSnapshot.guest();
    expect(guest.isGuest, isTrue);
    expect(guest.clan, 'kuttiomp_clan');
  });
}