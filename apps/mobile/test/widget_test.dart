import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';

/// Smoke compile gate — app entry and protocol service load on device targets.
void main() {
  test('protocol service arms for offline launch path', () {
    KuttiompProtocolService.instance.init(claims: {
      'mode': KuttiompMode.littleOnes.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': 1,
    });
    expect(KuttiompProtocolService.instance.isInitialized, isTrue);
  });
}
