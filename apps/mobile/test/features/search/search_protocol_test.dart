import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/features/search/data/search_repository.dart';
import 'package:kuttiomp_mobile/features/search/domain/search_result_model.dart';

void main() {
  late KuttiompProtocolService service;
  late SearchRepository repository;

  setUp(() {
    AuditLogStore.instance.clear();
    service = KuttiompProtocolService.instance;
    service.init(claims: {
      'mode': KuttiompMode.littleOnes.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': GenerationalTierBitmask.littleOnes,
    });
    repository = SearchRepository(
      gateway: ProtocolGateway(protocolService: service),
    );
  });

  group('SearchRepository – Protocol enforcement', () {
    test('search returns results with required primary_audio_id (Protocol 7)', () async {
      final results = await repository.search(
        query: 'anska',
        mode: KuttiompMode.littleOnes,
      );
      expect(results, isNotEmpty);
      for (final result in results) {
        expect(result.primaryAudioId, isNotEmpty);
        expect(result.speakerId, isNotEmpty);
      }
    });

    test('search logs Protocols 1,4,5,6,9 message', () async {
      await repository.search(query: 'wunnegan', mode: KuttiompMode.littleOnes);
      expect(
        AuditLogStore.instance.entries.any(
          (e) => e.outcome.contains('Protocols 1,4,5,6,9'),
        ),
        isTrue,
      );
      expect(
        SearchRepository.searchLogMessage,
        'Search executed | Protocols 1,4,5,6,9 enforced',
      );
    });

    test('search result model requires primary_audio_id', () {
      expect(
        () => SearchResultModel.fromJson({
          'id': 'bad',
          'content_type': 'lexeme',
          'title': 'Test',
        }),
        throwsArgumentError,
      );
    });

    test('search filters sacred content for little ones (Protocol 4)', () async {
      final results = await repository.search(
        query: 'sacred',
        mode: KuttiompMode.littleOnes,
      );
      expect(results.any((r) => r.requiresSacredGate), isFalse);
    });

    test('search filters by clan scope (Protocol 5)', () async {
      final results = await repository.search(
        query: '',
        mode: KuttiompMode.littleOnes,
        clanId: 'kuttiomp_clan',
      );
      expect(results, isNotEmpty);
      for (final result in results) {
        expect(result.clanScope, contains('kuttiomp_clan'));
      }
    });

    test('search respects content type filter', () async {
      final results = await repository.search(
        query: '',
        mode: KuttiompMode.littleOnes,
        contentTypes: {SearchContentType.lexeme},
      );
      expect(results, isNotEmpty);
      expect(results.every((r) => r.contentType == SearchContentType.lexeme), isTrue);
    });

    test('land-context result includes geometry metadata (Protocol 6)', () async {
      final results = await repository.search(
        query: 'mish',
        mode: KuttiompMode.coreAdult,
      );
      final landResult = results.firstWhere((r) => r.requiresLandContext);
      expect(landResult.landContext, isNotNull);
      expect(() => service.assertLandContext(
            context: {
              'requires_land_context': true,
              'land_geometry': landResult.landContext,
            },
          ), returnsNormally);
    });

    test('uses audited RPC names only', () {
      expect(KuttiompRpc.searchContent, 'search_content_secure');
      expect(KuttiompRpc.all, contains('search_content_secure'));
    });
  });
}