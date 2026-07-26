import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/search/data/search_repository.dart';
import 'package:kuttiomp_mobile/features/search/domain/search_result_model.dart';
import 'package:kuttiomp_mobile/features/search/presentation/search_result_card.dart';

/// Golden-lock structural tests – search result card renders per mode (§11).
void main() {
  late SearchResultModel result;

  setUp(() {
    KuttiompProtocolService.instance.init(
      claims: {
        'mode': KuttiompMode.littleOnes.id,
        'clan': 'kuttiomp_clan',
        'role': 'learner',
        'tier': GenerationalTierBitmask.littleOnes,
      },
    );
    result = const SearchResultModel(
      id: 'lexeme-wunnegan',
      contentType: SearchContentType.lexeme,
      title: 'Wunnegan',
      subtitle: 'Good / It is good',
      speakerMetadata: {
        'speaker_id': 'grandmother-comus',
        'name': 'Grandmother Comus',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-wunnegan-001',
    );
  });

  Widget wrapMode(KuttiompMode mode, Widget child) {
    return ProviderScope(
      child: MaterialApp(
        theme: KuttiompTheme.forMode(mode).copyWith(
          extensions: [KuttiompThemeExtension.forMode(mode)],
        ),
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );
  }

  for (final mode in KuttiompMode.values) {
    group('Search golden lock – ${mode.label}', () {
      testWidgets('SearchResultCard renders type badge and oral-first', (tester) async {
        await tester.pumpWidget(
          wrapMode(
            mode,
            SearchResultCard.fromResult(result: result, onTap: () {}),
          ),
        );

        expect(find.text('Wunnegan'), findsOneWidget);
        expect(find.text('Word'), findsOneWidget);
        expect(find.textContaining('Hear Wunnegan'), findsOneWidget);
        expect(find.textContaining('Authority:'), findsOneWidget);
      });

      testWidgets('land result shows GeoContextBadge', (tester) async {
        const landResult = SearchResultModel(
          id: 'phrase-land-greeting',
          contentType: SearchContentType.phrase,
          title: 'Mish nuttum',
          subtitle: 'This land is beautiful',
          speakerMetadata: {
            'speaker_id': 'elder-narragansett',
            'name': 'Elder Keeper',
            'authority_source': 'elder',
          },
          primaryAudioId: 'audio-phrase-land-001',
          landContext: {
            'type': 'Point',
            'label': 'Narragansett Bay shoreline',
          },
        );

        await tester.pumpWidget(
          wrapMode(
            mode,
            SearchResultCard.fromResult(result: landResult),
          ),
        );

        expect(find.textContaining('Narragansett Bay'), findsOneWidget);
      });

      testWidgets('meets minimum font size for mode', (tester) async {
        await tester.pumpWidget(
          wrapMode(
            mode,
            Builder(
              builder: (context) {
                final ext = KuttiompThemeExtension.of(context);
                expect(ext.bodyLarge.fontSize, greaterThanOrEqualTo(mode.minimumFontSize));
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });
  }

  test('search log message matches verification contract', () {
    expect(
      SearchRepository.searchLogMessage,
      'Search executed | Protocols 1,4,5,6,9 enforced',
    );
  });
}