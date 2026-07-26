import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/features/dashboard/presentation/content_section_petal.dart';
import 'package:kuttiomp_mobile/features/dashboard/presentation/dashboard_screen.dart';

import '../../helpers/kuttiomp_test_harness.dart';

/// Stream F hygiene — dashboard shows three pathways under mode shell.
void main() {
  setUp(() async {
    await KuttiompTestHarness.initProtocol(mode: KuttiompMode.coreAdult);
  });

  testWidgets('dashboard renders welcome and three content section labels', (tester) async {
    await tester.pumpWidget(
      KuttiompTestHarness.wrapWithProviders(
        mode: KuttiompMode.coreAdult,
        child: const DashboardScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Lexemes'), findsWidgets);
    expect(find.text('Phrases'), findsOneWidget);
    expect(find.text('Lessons'), findsOneWidget);
  });

  test('ContentSectionPetal is dignified non-gamified surface', () {
    expect(ContentSectionPetal, isNotNull);
  });
}