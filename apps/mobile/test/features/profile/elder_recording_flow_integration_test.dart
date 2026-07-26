import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/lexeme_repository.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approved_contributions_store.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/pending_approval_gate.dart';
import '../../helpers/kuttiomp_test_harness.dart';
import '../../helpers/kuttiomp_test_keys.dart';

/// End-to-end elder contribution flow — golden integration covenant (§11).
void main() {
  setUp(() {
    AuditLogStore.instance.clear();
    ApprovedContributionsStore.instance.clear();
  });

  testWidgets('Elder record → submit → approve → corpus promotion', (tester) async {
    await tester.pumpElderRecordingPage();

    await tester.enterText(find.byKey(KuttiompTestKeys.wordField), 'wunnegin');
    await tester.enterText(find.byKey(KuttiompTestKeys.translationField), 'It is good');
    await tester.tap(find.byKey(KuttiompTestKeys.recordStub));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(KuttiompTestKeys.submitSecure));
    await tester.pumpAndSettle();

    expect(
      find.text('Recording submitted | Protocol 2 pending elder review'),
      findsOneWidget,
    );
    expect(find.byType(PendingApprovalGate), findsOneWidget);

    await tester.pumpKeeperPanel();
    await tester.tap(find.byKey(KuttiompTestKeys.keeperApprove));
    await tester.pumpAndSettle();

    expect(
      AuditLogStore.instance.entries.any(
        (e) => e.outcome.contains('Protocols 2,8'),
      ),
      isTrue,
    );
    expect(find.textContaining('approved contribution'), findsOneWidget);

    final gateway = ProtocolGateway();
    final approved = ApprovedContributionsStore.instance.approvedRecordings();
    expect(approved.any((r) => r.word == 'wunnegin'), isTrue);
    final lexeme = await LexemeRepository(gateway: gateway).getById(approved.first.id);
    expect(lexeme.elderApproved, isTrue);

    expect(gateway.allAssertionsPassed(), isTrue);
    tester.verifyElderAccessibilityLabels();
    tester.verifyOfflineMirrorIntact();
  });
}