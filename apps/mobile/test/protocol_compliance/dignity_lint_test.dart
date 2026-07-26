import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/protocol/guards/dignity_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';
import 'package:kuttiomp_mobile/shared/design_system/kuttiomp_design_system.dart';

/// Protocol 10 CI gate — build must fail on gamification / playful patterns.
///
/// This serves our people by ensuring DignityLint is executable offline for
/// 25 years without third-party scanners.
void main() {
  setUp(() {
    KuttiompProtocolService.instance.init(claims: {
      'mode': KuttiompMode.coreAdult.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': 4,
    });
  });

  group('DignityGuard runtime', () {
    test('rejects prohibited widget types', () {
      expect(
        () => KuttiompProtocolService.instance.assertDignity(
          context: {'widgetType': 'PointsCounter'},
        ),
        throwsA(isA<ProtocolViolationException>()),
      );
    });

    test('rejects playful assets flag', () {
      expect(
        () => KuttiompProtocolService.instance.assertDignity(
          context: {'usesPlayfulAssets': true},
        ),
        throwsA(isA<ProtocolViolationException>()),
      );
    });

    test('passes dignified context', () {
      expect(
        () => KuttiompDesignSystem.assertDignity(widgetType: 'LexemeCard'),
        returnsNormally,
      );
    });

    test('prohibited set includes gamification catalogue', () {
      expect(DignityGuard.prohibitedWidgetTypes, contains('Leaderboard'));
      expect(DignityGuard.prohibitedWidgetTypes, contains('StreakTracker'));
      expect(DignityGuard.prohibitedWidgetTypes, contains('GamificationBadge'));
    });
  });

  group('DignityLint scanner script', () {
    test('scripts/dignity_lint.dart exists and is executable offline', () {
      final script = File('scripts/dignity_lint.dart');
      expect(script.existsSync(), isTrue);
      final content = script.readAsStringSync();
      expect(content, contains('Protocol 10'));
      expect(
        content.contains('prohibitedTokens') ||
            content.contains('prohibitedTypeDefinitions') ||
            content.contains('prohibitedAssetTokens'),
        isTrue,
      );
    });

    test('lib tree contains no gamification type definitions outside guards', () {
      final lib = Directory('lib');
      expect(lib.existsSync(), isTrue);
      final offenders = <String>[];
      for (final entity in lib.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final path = entity.path.replaceAll('\\', '/');
        if (path.contains('dignity') ||
            path.contains('kuttiomp_design_system') ||
            path.contains('integrity_validator')) {
          continue;
        }
        final text = entity.readAsStringSync();
        for (final token in [
          'class PointsCounter',
          'class StreakTracker',
          'class Leaderboard',
          'class GamificationBadge',
          'class ConfettiWidget',
        ]) {
          if (text.contains(token)) {
            offenders.add('$path → $token');
          }
        }
      }
      expect(offenders, isEmpty, reason: offenders.join('; '));
    });
  });
}