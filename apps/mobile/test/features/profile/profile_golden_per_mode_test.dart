import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/profile/domain/mode_persistence_service.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/mode_selection_bottom_sheet.dart';

/// Golden-lock structural tests – profile mode selection per mode (§11).
void main() {
  setUp(() {
    KuttiompProtocolService.instance.init(
      claims: {
        'mode': KuttiompMode.littleOnes.id,
        'clan': 'kuttiomp_clan',
        'role': 'learner',
        'tier': GenerationalTierBitmask.littleOnes,
      },
    );
  });

  Widget wrapMode(KuttiompMode mode, Widget child) {
    return MaterialApp(
      theme: KuttiompTheme.forMode(mode).copyWith(
        extensions: [KuttiompThemeExtension.forMode(mode)],
      ),
      home: Scaffold(body: child),
    );
  }

  for (final mode in KuttiompMode.values) {
    group('Profile golden lock – ${mode.label}', () {
      testWidgets('ModeSelectionBottomSheet renders all modes', (tester) async {
        await tester.pumpWidget(
          wrapMode(
            mode,
            ModeSelectionBottomSheet(
              initialMode: mode,
              onSelect: (_) async {},
            ),
          ),
        );

        for (final m in KuttiompMode.values) {
          expect(find.text(m.label), findsOneWidget);
        }
        expect(find.text('Use ${mode.label}'), findsOneWidget);
      });

      test('mode persistence log message matches covenant', () {
        expect(
          ModePersistenceService.persistLogMessage,
          contains('Protocols 2,3,9,11,12'),
        );
      });
    });
  }
}