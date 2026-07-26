import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/profile/domain/elder_recording_model.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/pending_approval_gate.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/keeper_approval_panel.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approved_contributions_store.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import '../../helpers/kuttiomp_test_harness.dart';
import '../../helpers/kuttiomp_test_keys.dart';

void main() {
  late ElderRecordingModel pending;

  setUp(() {
    AuditLogStore.instance.clear();
    ApprovedContributionsStore.instance.clear();
    KuttiompProtocolService.instance.init(
      claims: {
        'mode': KuttiompMode.elder.id,
        'clan': 'kuttiomp_clan',
        'role': 'elder',
        'tier': GenerationalTierBitmask.elder,
      },
    );
    pending = const ElderRecordingModel(
      id: 'recording-test',
      word: 'Nuttum',
      translation: 'Beautiful',
      speakerMetadata: {
        'speaker_id': 'elder-1',
        'name': 'Elder Contributor',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-elder-test',
      contentType: 'lexeme',
      status: RecordingApprovalStatus.pending,
      elderApproved: false,
    );
  });

  Widget wrap(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        theme: KuttiompTheme.forMode(KuttiompMode.elder).copyWith(
          extensions: [KuttiompThemeExtension.forMode(KuttiompMode.elder)],
        ),
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('PendingApprovalGate shows respectful pending message', (tester) async {
    await tester.pumpWidget(
      wrap(
        PendingApprovalGate(
          recording: pending,
          child: const Text('Approved content'),
        ),
      ),
    );

    expect(find.text('Content pending elder review'), findsOneWidget);
    expect(find.textContaining('Nuttum'), findsOneWidget);
    expect(find.text('Approved content'), findsNothing);
  });

  testWidgets('PendingApprovalGate renders child when approved', (tester) async {
    const approved = ElderRecordingModel(
      id: 'recording-approved',
      word: 'Nuttum',
      translation: 'Beautiful',
      speakerMetadata: {
        'speaker_id': 'elder-1',
        'name': 'Elder Contributor',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-elder-test',
      contentType: 'lexeme',
      status: RecordingApprovalStatus.approved,
      elderApproved: true,
    );

    await tester.pumpWidget(
      wrap(
        PendingApprovalGate(
          recording: approved,
          child: const Text('Approved content'),
        ),
      ),
    );

    expect(find.text('Approved content'), findsOneWidget);
    expect(find.text('Content pending elder review'), findsNothing);
  });

  testWidgets('full elder contribution golden path', (tester) async {
    await tester.pumpElderRecordingPage();
    await tester.enterText(find.byKey(KuttiompTestKeys.wordField), 'wunnegin');
    await tester.tap(find.byKey(KuttiompTestKeys.recordStub));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(KuttiompTestKeys.submitSecure));
    await tester.pumpAndSettle();

    expect(find.byType(PendingApprovalGate), findsOneWidget);

    await tester.pumpWidget(
      KuttiompTestHarness.wrapWithProviders(
        mode: KuttiompMode.elder,
        child: const Scaffold(body: KeeperApprovalPanel()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(KuttiompTestKeys.keeperApprove));
    await tester.pumpAndSettle();

    expect(find.textContaining('approved contribution'), findsOneWidget);
  });
}