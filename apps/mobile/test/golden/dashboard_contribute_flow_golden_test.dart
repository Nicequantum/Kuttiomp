import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approved_contributions_store.dart';
import '../helpers/kuttiomp_test_harness.dart';
import '../helpers/kuttiomp_test_keys.dart';

/// Four-mode dashboard Contribute flow golden lock (§11).
void main() {
  setUp(() {
    AuditLogStore.instance.clear();
    ApprovedContributionsStore.instance.clear();
  });

  for (final mode in KuttiompMode.values) {
    group('Dashboard contribute golden – ${mode.label}', () {
      testWidgets('Contribute navigation and elder flow integrity', (tester) async {
        await tester.pumpKuttiompApp(mode: mode);

        expect(find.text('Welcome back'), findsOneWidget);

        if (mode == KuttiompMode.elder) {
          await tester.pumpElderRecordingPage();
          await tester.enterText(find.byKey(KuttiompTestKeys.wordField), 'wunnegin');
          await tester.tap(find.byKey(KuttiompTestKeys.recordStub));
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(KuttiompTestKeys.submitSecure));
          await tester.pumpAndSettle();

          expect(
            find.text('Recording submitted | Protocol 2 pending elder review'),
            findsOneWidget,
          );

          final gateway = ProtocolGateway();
          expect(gateway.allAssertionsPassed(), isTrue);
          tester.verifyElderAccessibilityLabels();
        }

        await tester.switchToMode(mode);
        expect(ProtocolGateway().allAssertionsPassed(), isTrue);
        tester.verifyOfflineMirrorIntact();
      });
    });
  }
}