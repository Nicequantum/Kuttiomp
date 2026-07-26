import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';

/// Validates golden PNG asset presence for four-mode capture (§11).
void main() {
  final goldenRoot = Directory('test/golden');
  final profileGoldenRoot = Directory('test/features/profile/elder_recording_golden');

  test('dashboard v1.8 golden assets exist for all modes', () {
    for (final mode in KuttiompMode.values) {
      final file = File('${goldenRoot.path}/dashboard_contribute_flow_${mode.id}.png');
      expect(file.existsSync(), isTrue, reason: 'Missing ${file.path}');
      expect(file.lengthSync(), greaterThan(0));
    }
  });

  test('elder contribution profile golden assets exist for all modes', () {
    for (final mode in KuttiompMode.values) {
      final file = File('${profileGoldenRoot.path}/elder_contribution_${mode.id}.png');
      expect(file.existsSync(), isTrue, reason: 'Missing ${file.path}');
      expect(file.lengthSync(), greaterThan(0));
    }
  });
}