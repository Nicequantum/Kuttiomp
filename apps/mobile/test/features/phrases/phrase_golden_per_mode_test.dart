import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/phrases/data/phrases_repository.dart';
import 'package:kuttiomp_mobile/features/phrases/domain/phrase.dart';
import 'package:kuttiomp_mobile/features/phrases/presentation/phrase_card.dart';

void main() {
  late PhraseModel phrase;

  setUp(() {
    KuttiompProtocolService.instance.init(
      claims: {
        'mode': KuttiompMode.littleOnes.id,
        'clan': 'kuttiomp_clan',
        'role': 'learner',
        'tier': GenerationalTierBitmask.littleOnes,
      },
    );
    phrase = const PhraseModel(
      id: 'phrase-greeting',
      phrase: 'Anska, wunnegan!',
      translation: 'Hello, it is good!',
      speakerMetadata: {
        'speaker_id': 'grandmother-comus',
        'name': 'Grandmother Comus',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-phrase-greeting-001',
      conversationPrompt: 'Greet an elder respectfully.',
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
    group('Phrase golden lock – ${mode.label}', () {
      testWidgets('PhraseCard renders oral-first with authority gate', (tester) async {
        await tester.pumpWidget(
          wrapMode(
            mode,
            PhraseCard.fromPhrase(phrase: phrase, onTap: () {}),
          ),
        );

        expect(find.text('Anska, wunnegan!'), findsOneWidget);
        expect(find.text('Acknowledge Authority'), findsOneWidget);
        expect(find.textContaining('Hear phrase'), findsOneWidget);

        await tester.tap(find.text('Acknowledge Authority'));
        await tester.pumpAndSettle();

        expect(find.text('Show text (secondary)'), findsOneWidget);
      });

      testWidgets('land phrase shows GeoContextBadge', (tester) async {
        const landPhrase = PhraseModel(
          id: 'phrase-land',
          phrase: 'Mish nuttum',
          translation: 'This land is beautiful',
          speakerMetadata: {
            'speaker_id': 'elder',
            'name': 'Elder Keeper',
            'authority_source': 'elder',
          },
          primaryAudioId: 'audio-land-001',
          landContext: {'type': 'Point', 'label': 'Narragansett Bay'},
        );

        await tester.pumpWidget(
          wrapMode(
            mode,
            PhraseCard.fromPhrase(phrase: landPhrase),
          ),
        );

        await tester.tap(find.text('Acknowledge Authority'));
        await tester.pumpAndSettle();

        expect(find.textContaining('Narragansett Bay'), findsOneWidget);
      });
    });
  }

  test('load log message matches verification contract', () {
    expect(
      PhrasesRepository.loadLogMessage,
      'Phrase loaded | Protocols 1,6,7 enforced',
    );
  });
}