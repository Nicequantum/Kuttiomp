import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/offline_worker.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approved_contributions_store.dart';
import 'package:kuttiomp_mobile/features/profile/domain/elder_recording_model.dart'
    show ElderRecordingModel, RecordingApprovalStatus;
import 'package:kuttiomp_mobile/features/search/data/search_repository.dart';
import 'package:kuttiomp_mobile/features/search/domain/search_result_model.dart';
import 'package:kuttiomp_mobile/features/search/domain/search_service.dart';
import 'package:kuttiomp_mobile/features/search/presentation/search_page.dart';
import '../../helpers/kuttiomp_test_harness.dart';

void main() {
  late SearchRepository repository;
  late SearchService service;
  late ProtocolGateway gateway;

  setUp(() async {
    await KuttiompTestHarness.initProtocol(mode: KuttiompMode.coreAdult);
    ApprovedContributionsStore.instance.clear();
    gateway = ProtocolGateway();
    repository = SearchRepository(gateway: gateway);
    service = SearchService(repository: repository);
  });

  group('Search v2.1 flow – discover covenant', () {
    test('query "land" returns land-context results with attribution', () async {
      final results = await service.discover(
        query: 'land',
        mode: KuttiompMode.coreAdult,
      );

      expect(results, isNotEmpty);
      expect(results.any((r) => r.requiresLandContext), isTrue);
      for (final result in results) {
        expect(result.primaryAudioId, isNotEmpty);
        expect(result.speakerId, isNotEmpty);
      }
    });

    test('lesson delegation returns governed lesson results', () async {
      final results = await service.discover(
        query: 'greeting',
        mode: KuttiompMode.littleOnes,
        contentTypes: {SearchContentType.lesson},
      );

      expect(results, isNotEmpty);
      expect(results.every((r) => r.contentType == SearchContentType.lesson), isTrue);
    });

    test('elder-approved phrase appears in search post-approval', () async {
      ApprovedContributionsStore.instance.promoteToApproved(
        ElderRecordingModel(
          id: 'elder-phrase-search-test',
          word: 'Nuttermish',
          translation: 'Beautiful land',
          contentType: 'phrase',
          status: RecordingApprovalStatus.approved,
          speakerMetadata: const {
            'speaker_id': 'elder-test',
            'name': 'Elder Test',
            'authority_source': 'elder',
          },
          primaryAudioId: 'audio-elder-phrase-search',
          canonicalStage: 'rooted',
          clanScope: ['kuttiomp_clan'],
          visibleToTiers: GenerationalTierBitmask.allTiers,
          elderApproved: true,
          authoritySource: 'elder',
        ),
      );

      final results = await service.discover(
        query: 'nuttermish',
        mode: KuttiompMode.coreAdult,
        contentTypes: {SearchContentType.phrase},
      );

      expect(results.any((r) => r.id == 'elder-phrase-search-test'), isTrue);
      expect(
        results.firstWhere((r) => r.id == 'elder-phrase-search-test').elderApproved,
        isTrue,
      );
    });

    test('Elder mode voice-first preview differs from Little Ones', () {
      const result = SearchResultModel(
        id: 'lexeme-mish',
        contentType: SearchContentType.lexeme,
        title: 'Mish',
        subtitle: 'Land / Earth',
        speakerMetadata: {
          'speaker_id': 'elder-narragansett',
          'name': 'Elder Keeper',
          'authority_source': 'elder',
        },
        primaryAudioId: 'audio-mish-001',
        landContext: {'label': 'Narragansett territory'},
      );

      final elderPreview = service.voiceFirstPreview(mode: KuttiompMode.elder, result: result);
      final littlePreview =
          service.voiceFirstPreview(mode: KuttiompMode.littleOnes, result: result);

      expect(elderPreview, contains('Our elders remember'));
      expect(littlePreview, isNot(contains('Our elders remember')));
    });

    testWidgets('SearchPage renders search field and governed results', (tester) async {
      await tester.pumpWidget(
        KuttiompTestHarness.wrapWithProviders(
          mode: KuttiompMode.coreAdult,
          child: const SearchPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Discover Language'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'land');
      await tester.pumpAndSettle();

      expect(find.textContaining('Mish'), findsWidgets);
    });

    test('OfflineWorker bootstrap completes with protocol log', () async {
      final result = await OfflineWorker.bootstrap(mode: KuttiompMode.coreAdult);
      expect(result.logMessage, contains('Sync complete'));
      expect(OfflineWorker.bootstrapLogMessage, contains('Protocols 4,5,9'));
    });

    test('gateway assertions pass after search flow', () async {
      await service.discover(query: 'anska', mode: KuttiompMode.littleOnes);
      expect(gateway.allAssertionsPassed(), isTrue);
    });
  });
}