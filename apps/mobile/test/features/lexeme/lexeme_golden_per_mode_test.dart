import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/lexeme_repository.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';
import 'package:kuttiomp_mobile/features/lexeme/presentation/lexeme_card.dart';

/// Golden-lock structural tests – lexeme card renders per mode (§11).
void main() {
  late LexemeModel lexeme;

  setUp(() {
    KuttiompProtocolService.instance.init(
      claims: {
        'mode': KuttiompMode.littleOnes.id,
        'clan': 'kuttiomp_clan',
        'role': 'learner',
        'tier': GenerationalTierBitmask.littleOnes,
      },
    );
    lexeme = const LexemeModel(
      id: 'lexeme-wunnegan',
      word: 'Wunnegan',
      translation: 'Good / It is good',
      speakerMetadata: {
        'speaker_id': 'grandmother-comus',
        'name': 'Grandmother Comus',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-wunnegan-001',
      sacredFlag: false,
      clanScope: ['kuttiomp_clan'],
      visibleToTiers: GenerationalTierBitmask.allTiers,
      canonicalStage: 'awakening',
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
    group('Lexeme golden lock – ${mode.label}', () {
      testWidgets('LexemeCard renders oral-first with attribution', (tester) async {
        await tester.pumpWidget(
          wrapMode(
            mode,
            LexemeCard.fromLexeme(
              lexeme: lexeme,
              onTap: () {},
              onPlayAudio: () {},
            ),
          ),
        );

        expect(find.text('Wunnegan'), findsOneWidget);
        expect(find.textContaining('Hear Wunnegan'), findsOneWidget);
        expect(find.textContaining('Authority:'), findsOneWidget);
        expect(find.text('Show text (secondary)'), findsOneWidget);
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

  test('load log message matches verification contract', () {
    expect(
      LexemeRepository.loadLogMessage,
      'Lexeme loaded | Protocol 1,7,9 enforced',
    );
  });
}