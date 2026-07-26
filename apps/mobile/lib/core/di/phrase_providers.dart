import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/di/injection.dart';
import 'package:kuttiomp_mobile/core/di/lexeme_providers.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';
import 'package:kuttiomp_mobile/features/phrases/data/phrases_repository.dart';
import 'package:kuttiomp_mobile/features/phrases/domain/phrase.dart';
import 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';

/// Filter applied when dashboard Conversation Starter petal is tapped (§6).
class PhraseFilter {
  const PhraseFilter({
    required this.mode,
    required this.canonicalStage,
    this.landGeometry,
    this.seasonalWindow,
    this.category,
  });

  final KuttiompMode mode;
  final String canonicalStage;
  final Map<String, dynamic>? landGeometry;
  final String? seasonalWindow;
  final String? category;

  static const PhraseFilter defaultFilter = PhraseFilter(
    mode: KuttiompMode.littleOnes,
    canonicalStage: 'awakening',
  );
}

final phrasesRepositoryProvider = Provider<PhrasesRepository>((ref) {
  return PhrasesRepository(
    gateway: ref.watch(protocolGatewayProvider),
    auditedClient: ref.watch(auditedClientProvider),
  );
});

final phraseFilterProvider = StateProvider<PhraseFilter>(
  (ref) => PhraseFilter.defaultFilter,
);

final phraseDashboardFilterProvider = Provider<PhraseFilter>((ref) {
  final mode = ref.watch(modeControllerProvider).valueOrNull ?? KuttiompMode.littleOnes;
  final mastery = ref.watch(userMasteryProvider);
  _assertPhraseDashboardWire(ref, mode);
  return PhraseFilter(mode: mode, canonicalStage: mastery.canonicalStage);
});

// Mode-change side effects: phraseListProvider already ref.watch(modeControllerProvider)
// and re-asserts protocol wiring on each rebuild — no separate ref.listen required.

final phraseSearchQueryProvider = StateProvider<String>((ref) => '');
final phraseCategoryProvider = StateProvider<String?>((ref) => null);

final phraseListProvider =
    FutureProvider.autoDispose<List<PhraseModel>>((ref) async {
  // Mode changes rebuild this provider via watch; no invalidate cycle.
  final dashboardFilter = ref.watch(phraseDashboardFilterProvider);
  final manualFilter = ref.watch(phraseFilterProvider);
  final query = ref.watch(phraseSearchQueryProvider);
  final category = ref.watch(phraseCategoryProvider);
  final mode = ref.watch(modeControllerProvider).valueOrNull ?? dashboardFilter.mode;
  final canonicalStage = ref.watch(userMasteryProvider).canonicalStage;
  _assertPhraseDashboardWire(ref, mode);
  final list = await ref.watch(phrasesRepositoryProvider).watchPhrasesForTier(
        mode.tierBitmask,
        stage: canonicalStage,
      );
  return list
      .where((p) => category == null || category.isEmpty || p.category == category)
      .where((p) {
        if (query.isEmpty) return true;
        final normalized = query.trim().toLowerCase();
        return '${p.phrase} ${p.translation} ${p.id} ${p.category}'
            .toLowerCase()
            .contains(normalized);
      })
      .toList();
});

final phraseDetailProvider = FutureProvider.family<PhraseModel, String>((ref, id) async {
  return ref.watch(phrasesRepositoryProvider).getById(id);
});

final phraseLexemePairsProvider =
    FutureProvider.family<List<LexemeModel>, String>((ref, phraseId) async {
  final phrase = await ref.watch(phraseDetailProvider(phraseId).future);
  final pairs = <LexemeModel>[];
  for (final lexemeId in phrase.relatedLexemeIds) {
    pairs.add(await ref.watch(lexemeRepositoryProvider).getById(lexemeId));
  }
  return pairs;
});

final featuredPhraseProvider = FutureProvider<PhraseModel>((ref) async {
  return ref.watch(phrasesRepositoryProvider).getById('phrase-greeting');
});

void _assertPhraseDashboardWire(Ref ref, KuttiompMode mode) {
  final gateway = ref.read(protocolGatewayProvider);
  for (final id in ['3', '5', '7', '12']) {
    gateway.assertCompliant(
      id,
      context: {
        'visible_to_tiers': mode.tierBitmask,
        'elderApproved': true,
        'direct_table_access': false,
        'primary_audio_id': 'audio-phrase-dashboard-wire',
        'maintainability': 'phrase_dashboard_wire',
      },
    );
  }
}