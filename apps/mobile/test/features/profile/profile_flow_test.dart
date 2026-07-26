import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/bootstrap/first_launch_service.dart';
import 'package:kuttiomp_mobile/features/profile/domain/mode_persistence_service.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/first_launch_onboarding.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/profile_page.dart';
import 'package:kuttiomp_mobile/modes/mode_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/kuttiomp_test_harness.dart';

void main() {
  setUp(() async {
    await KuttiompTestHarness.initProtocol(mode: KuttiompMode.coreAdult);
  });

  group('Profile v2.2 flow – onboarding and persistence covenant', () {
    test('shouldShowOnboarding true on clean install', () async {
      SharedPreferences.setMockInitialValues({});
      final persistence = await ModePersistence.open();
      final service = FirstLaunchService(
        modePersistenceService: ModePersistenceService(
          profileRepository: KuttiompTestHarness.profileRepository(),
          authService: KuttiompTestHarness.authService(),
          protocolService: KuttiompTestHarness.protocolService,
          modePersistence: persistence,
        ),
        modePersistence: persistence,
      );

      expect(await service.shouldShowOnboarding(), isTrue);
    });

    test('mode persistence survives restart', () async {
      SharedPreferences.setMockInitialValues({});
      final persistence = await ModePersistence.open();
      await persistence.completeFirstLaunch(mode: KuttiompMode.elder);
      final reopened = await ModePersistence.open();
      expect(reopened.isFirstLaunchComplete, isTrue);
      expect(reopened.savedMode, KuttiompMode.elder);
    });

    testWidgets('FirstLaunchOnboarding renders guided tour', (tester) async {
      await tester.pumpWidget(
        KuttiompTestHarness.wrapWithProviders(
          mode: KuttiompMode.littleOnes,
          child: const FirstLaunchOnboarding(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Begin Your Journey'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('ProfilePage renders settings and accessibility toggles', (tester) async {
      await tester.pumpWidget(
        KuttiompTestHarness.wrapWithProviders(
          mode: KuttiompMode.coreAdult,
          child: const ProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Your Profile'), findsOneWidget);
      expect(find.text('Accessibility'), findsOneWidget);
      expect(find.text('Change Learning Path'), findsOneWidget);
      expect(find.text('Explore the Corpus'), findsOneWidget);
    });

    testWidgets('ProfilePage shows Keeper dashboard section', (tester) async {
      await tester.pumpWidget(
        KuttiompTestHarness.wrapWithProviders(
          mode: KuttiompMode.elder,
          child: const ProfilePage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Keeper Dashboard'), findsOneWidget);
      expect(find.text('Contribute Recording'), findsOneWidget);
    });
  });
}