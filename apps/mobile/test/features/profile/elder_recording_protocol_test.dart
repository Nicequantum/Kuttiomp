import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/lexeme_repository.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approval_simulation.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approved_contributions_store.dart';
import 'package:kuttiomp_mobile/features/profile/domain/elder_recording_model.dart';
import 'package:kuttiomp_mobile/features/profile/domain/recording_service.dart';

void main() {
  late KuttiompProtocolService service;
  late RecordingService recordingService;
  late ApprovalSimulation approvalSimulation;
  late LexemeRepository lexemeRepository;

  setUp(() {
    AuditLogStore.instance.clear();
    ApprovedContributionsStore.instance.clear();
    service = KuttiompProtocolService.instance;
    service.init(claims: {
      'mode': KuttiompMode.elder.id,
      'clan': 'kuttiomp_clan',
      'role': 'elder',
      'tier': GenerationalTierBitmask.elder,
    });
    final gateway = ProtocolGateway(protocolService: service);
    recordingService = RecordingService(gateway: gateway);
    approvalSimulation = ApprovalSimulation(gateway: gateway);
    lexemeRepository = LexemeRepository(gateway: gateway);
  });

  group('RecordingService – Protocol 2 enforcement', () {
    test('capture requires elder mode (Protocol 3)', () async {
      service.init(claims: {
        'mode': KuttiompMode.littleOnes.id,
        'clan': 'kuttiomp_clan',
        'role': 'learner',
        'tier': GenerationalTierBitmask.littleOnes,
      });
      expect(
        () => recordingService.captureRecording(
          word: 'Test',
          translation: 'Test',
          speakerId: 's1',
          speakerName: 'Speaker',
        ),
        throwsA(isA<ProtocolViolationException>()),
      );
    });

    test('submit logs Protocol 2 pending message', () async {
      service.init(claims: {
        'mode': KuttiompMode.elder.id,
        'clan': 'kuttiomp_clan',
        'role': 'elder',
        'tier': GenerationalTierBitmask.elder,
      });

      final draft = await recordingService.captureRecording(
        word: 'Nuttum',
        translation: 'Beautiful',
        speakerId: 'elder-1',
        speakerName: 'Elder Contributor',
      );
      final pending = await recordingService.submitForApproval(draft);

      expect(pending.status, RecordingApprovalStatus.pending);
      expect(pending.elderApproved, isFalse);
      expect(
        AuditLogStore.instance.entries.any(
          (e) => e.outcome.contains('Protocol 2 pending'),
        ),
        isTrue,
      );
      expect(
        RecordingService.submitLogMessage,
        'Recording submitted | Protocol 2 pending elder review',
      );
    });

    test('recording model requires primary_audio_id (Protocol 7)', () {
      expect(
        () => ElderRecordingModel.fromJson({
          'id': 'bad',
          'word': 'Test',
        }),
        throwsArgumentError,
      );
    });

    test('uses audited RPC names only', () {
      expect(KuttiompRpc.submitElderRecording, 'submit_elder_recording_secure');
      expect(KuttiompRpc.approveElderRecording, 'approve_elder_recording_secure');
      expect(KuttiompRpc.all, contains('submit_elder_recording_secure'));
    });
  });

  group('ApprovalSimulation – Keeper workflow', () {
    test('approve promotes content to living corpus', () async {
      final draft = await recordingService.captureRecording(
        word: 'Nuttum',
        translation: 'Beautiful',
        speakerId: 'elder-1',
        speakerName: 'Elder Contributor',
      );
      final pending = await recordingService.submitForApproval(draft);

      final approved = await approvalSimulation.approveRecording(
        recordingId: pending.id,
        keeperId: 'keeper-elder',
      );

      expect(approved.isApproved, isTrue);
      expect(approved.elderApproved, isTrue);
      expect(approved.approvalChain, contains('keeper-elder'));
      expect(
        AuditLogStore.instance.entries.any(
          (e) => e.outcome.contains('Protocols 2,8'),
        ),
        isTrue,
      );
      expect(
        ApprovalSimulation.approveLogMessage,
        'Recording approved | Protocols 2,8 enforced',
      );

      final lexeme = await lexemeRepository.getById(pending.id);
      expect(lexeme.id, pending.id);
      expect(lexeme.elderApproved, isTrue);
    });
  });
}