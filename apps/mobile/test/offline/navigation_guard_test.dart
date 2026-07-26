import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/routing/app_router.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';
import 'package:kuttiomp_mobile/modes/mode_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late KuttiompProtocolService protocolService;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    protocolService = KuttiompProtocolService.instance;
    protocolService.init(claims: {
      'mode': KuttiompMode.littleOnes.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': GenerationalTierBitmask.littleOnes,
    });
  });

  group('Navigation guards via createAppRouter', () {
    test('initial location is first-launch when not complete', () async {
      SharedPreferences.setMockInitialValues({});
      final persistence = await ModePersistence.open();
      final refresh = _TestListenable();
      addTearDown(refresh.dispose);

      final router = createAppRouter(
        persistence: persistence,
        bootstrapStatus: 'Foundation complete | Profile persisted | Dashboard petals ready',
        refreshListenable: refresh,
        mastery: UserMasterySummary.empty,
      );
      addTearDown(router.dispose);

      expect(router.routeInformationProvider.value.uri.path, '/first-launch');
    });

    test('initial location is dashboard when first launch complete', () async {
      SharedPreferences.setMockInitialValues({
        'kuttiomp_first_launch_complete': true,
        'kuttiomp_saved_mode': KuttiompMode.coreAdult.id,
      });
      final persistence = await ModePersistence.open();
      final refresh = _TestListenable();
      addTearDown(refresh.dispose);

      final router = createAppRouter(
        persistence: persistence,
        bootstrapStatus: 'Foundation complete | Profile persisted | Dashboard petals ready',
        refreshListenable: refresh,
        mastery: UserMasterySummary.empty,
      );
      addTearDown(router.dispose);

      expect(router.routeInformationProvider.value.uri.path, '/dashboard');
    });

    testWidgets('redirects to first-launch when navigating before completion', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final persistence = await ModePersistence.open();
      final refresh = _TestListenable();

      final router = createAppRouter(
        persistence: persistence,
        bootstrapStatus: 'Bootstrap complete',
        refreshListenable: refresh,
        mastery: UserMasterySummary.empty,
      );
      addTearDown(router.dispose);
      addTearDown(refresh.dispose);

      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router),
      );
      await tester.pumpAndSettle();

      router.go('/dashboard');
      await tester.pumpAndSettle();

      expect(router.routeInformationProvider.value.uri.path, '/first-launch');
    });
  });
}

class _TestListenable extends ChangeNotifier {}