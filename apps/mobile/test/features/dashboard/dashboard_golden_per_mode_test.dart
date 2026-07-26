import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/features/dashboard/presentation/dashboard_screen.dart';
import '../../helpers/kuttiomp_test_harness.dart';

/// Dashboard golden-lock structural tests across four modes (§11).
void main() {
  setUp(() async {
    await KuttiompTestHarness.initProtocol(mode: KuttiompMode.coreAdult);
  });

  for (final mode in KuttiompMode.values) {
    group('Dashboard golden – ${mode.label}', () {
      testWidgets('renders minimal vertical dashboard', (tester) async {
        await KuttiompTestHarness.initProtocol(mode: mode);
        await tester.pumpWidget(
          KuttiompTestHarness.wrapWithProviders(
            mode: mode,
            child: const DashboardScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Welcome back'), findsOneWidget);
        expect(find.text('Lexemes'), findsOneWidget);
        expect(find.text('Phrases'), findsOneWidget);
        expect(find.text('Lessons'), findsOneWidget);
        expect(find.text('Lexemes'), findsOneWidget);

        expect(ProtocolGateway().allAssertionsPassed(), isTrue);
      });
    });
  }
}