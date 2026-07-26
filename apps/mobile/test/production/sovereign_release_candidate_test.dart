import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/bootstrap/app_bootstrap.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/l10n/elder_review_gate.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/production/keeper_blessing_simulation.dart';
import 'package:kuttiomp_mobile/core/production/sovereign_release.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approved_contributions_store.dart';
import 'package:kuttiomp_mobile/features/profile/domain/elder_recording_model.dart'
    show ElderRecordingModel, RecordingApprovalStatus;
import 'package:kuttiomp_mobile/features/search/data/search_repository.dart';
import 'package:kuttiomp_mobile/features/search/domain/search_service.dart';
import 'package:kuttiomp_mobile/modes/mode_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Sovereign Production Release Candidate — ultimate verification covenant (§11).
void main() {
  late ProtocolGateway gateway;
  late SearchService searchService;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    AuditLogStore.instance.clear();
    ApprovedContributionsStore.instance.clear();
    KuttiompProtocolService.instance.init(claims: {
      'mode': KuttiompMode.coreAdult.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': GenerationalTierBitmask.coreAdult,
    });
    gateway = ProtocolGateway();
    searchService = SearchService(repository: SearchRepository(gateway: gateway));
  });

  group('Sovereign Release v2.3.0+1', () {
    test('release constants match production candidate', () {
      expect(SovereignRelease.version, '2.3.0+1');
      expect(SovereignRelease.requiredBootstrapLayers, contains('OfflineWorker'));
      expect(SovereignRelease.requiredBootstrapLayers, contains('FirstLaunch'));
      expect(SovereignRelease.requiredBootstrapLayers, contains('L10nElderGate'));
    });

    test('covenant step 1 — mode persistence on clean install', () async {
      SharedPreferences.setMockInitialValues({});
      final persistence = await ModePersistence.open();
      expect(persistence.isFirstLaunchComplete, isFalse);
      await persistence.completeFirstLaunch(mode: KuttiompMode.littleOnes);
      final reopened = await ModePersistence.open();
      expect(reopened.savedMode, KuttiompMode.littleOnes);
    });

    test('covenant step 2 — search land returns governed results', () async {
      final results = await searchService.discover(
        query: 'land',
        mode: KuttiompMode.coreAdult,
      );
      expect(results, isNotEmpty);
      expect(results.any((r) => r.primaryAudioId.isNotEmpty), isTrue);
    });

    test('covenant step 4 — elder contribution appears post-approval', () async {
      ApprovedContributionsStore.instance.promoteToApproved(
        ElderRecordingModel(
          id: 'elder-rc-phrase',
          word: 'Nuttermish',
          translation: 'Beautiful land',
          contentType: 'phrase',
          status: RecordingApprovalStatus.approved,
          speakerMetadata: const {
            'speaker_id': 'elder-rc',
            'name': 'Elder RC',
            'authority_source': 'elder',
          },
          primaryAudioId: 'audio-rc-001',
          elderApproved: true,
        ),
      );
      final results = await searchService.discover(
        query: 'nuttermish',
        mode: KuttiompMode.coreAdult,
      );
      expect(results.any((r) => r.id == 'elder-rc-phrase'), isTrue);
    });

    test('covenant step 7 — Keeper blessing records audit entry', () async {
      final simulation = KeeperBlessingSimulation(gateway: gateway);
      final record = await simulation.recordBlessing(
        keeperId: 'keeper-council-rc',
        keeperName: 'Authorized Keeper',
      );
      expect(record.protocolsAffirmed.length, 12);
      expect(
        AuditLogStore.instance.entries.any((e) => e.operation == 'keeper:blessing'),
        isTrue,
      );
      expect(
        simulation.formatBlessingLogTemplate(record),
        contains('Sovereign Production-Ready'),
      );
    });

    test('Elder Review Gate validates l10n manifest', () async {
      final result = await ElderReviewGate().validate(productionFlavor: false);
      expect(result.passed, isTrue);
      expect(result.approvedKeyCount, greaterThan(0));
    });

    test('AppBootstrap includes sovereign bootstrap layers', () async {
      SharedPreferences.setMockInitialValues({});
      final result = await AppBootstrap.initialize(flavor: 'production');
      expect(result.layerLogs, contains('Protocol'));
      expect(result.layerLogs, contains('OfflineWorker'));
      expect(result.layerLogs, contains('FirstLaunch'));
      expect(result.layerLogs, contains('L10nElderGate'));
      expect(result.integrityPassed, isTrue);
    });

    test('ProtocolGateway.allAssertionsPassed after full covenant', () async {
      await searchService.discover(query: 'anska', mode: KuttiompMode.littleOnes);
      expect(gateway.allAssertionsPassed(), isTrue);
    });
  });
}