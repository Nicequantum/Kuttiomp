import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/modes/content_renderer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
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

  group('ModeController switch (Component 4)', () {
    test('enforceNewMode called on every switch', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(modeControllerProvider.future);
      final controller = container.read(modeControllerProvider.notifier);
      final result = await controller.switchMode(KuttiompMode.elder);

      expect(result.mode, KuttiompMode.elder);
      expect(result.durationMs, lessThan(300));
      expect(result.logMessage, contains('Mode switched to Elder'));
      expect(result.logMessage, contains('Protocols 3,8,11 enforced'));
      expect(KuttiompProtocolService.instance.currentMode, KuttiompMode.elder);
      expect(controller.modeHistory, contains(KuttiompMode.elder));
    });

    test('cycles through all four modes', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(modeControllerProvider.future);
      final controller = container.read(modeControllerProvider.notifier);

      for (var i = 0; i < 4; i++) {
        await controller.cycleMode();
      }
      expect(controller.modeHistory.length, greaterThanOrEqualTo(4));
    });
  });

  group('ContentRenderer strategies', () {
    test('all four modes have strategies', () {
      for (final mode in KuttiompMode.values) {
        expect(ContentRenderer.strategyFor(mode).mode, mode);
        expect(ContentRenderer.longPressDescriptionFor(mode), isNotEmpty);
      }
    });
  });
}