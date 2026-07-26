import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/di/injection.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/lexeme_repository.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';
import 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';

/// Filter applied when dashboard Learn petal is tapped (§6).
class LexemeFilter {
  const LexemeFilter({required this.mode, required this.canonicalStage});

  final KuttiompMode mode;
  final String canonicalStage;

  static const LexemeFilter defaultFilter = LexemeFilter(
    mode: KuttiompMode.littleOnes,
    canonicalStage: 'awakening',
  );
}

final lexemeRepositoryProvider = Provider<LexemeRepository>((ref) {
  return LexemeRepository(
    gateway: ref.watch(protocolGatewayProvider),
    auditedClient: ref.watch(auditedClientProvider),
  );
});

final lexemeFilterProvider = StateProvider<LexemeFilter>(
  (ref) => LexemeFilter.defaultFilter,
);

final lexemeDashboardFilterProvider = Provider<LexemeFilter>((ref) {
  final mode = ref.watch(modeControllerProvider).valueOrNull ?? KuttiompMode.littleOnes;
  final mastery = ref.watch(userMasteryProvider);
  _assertLexemeDashboardWire(ref, mode);
  return LexemeFilter(mode: mode, canonicalStage: mastery.canonicalStage);
});

// Mode-change side effects: lexemeListProvider already ref.watch(modeControllerProvider)
// and re-asserts protocol wiring on each rebuild — no separate ref.listen required.

final lexemeSearchQueryProvider = StateProvider<String>((ref) => '');

final lexemeListProvider =
    FutureProvider.autoDispose<List<LexemeModel>>((ref) async {
  // Mode changes rebuild this provider via watch; no invalidate cycle.
  final dashboardFilter = ref.watch(lexemeDashboardFilterProvider);
  final query = ref.watch(lexemeSearchQueryProvider);
  final mode = ref.watch(modeControllerProvider).valueOrNull ?? dashboardFilter.mode;
  final canonicalStage = ref.watch(userMasteryProvider).canonicalStage;
  _assertLexemeDashboardWire(ref, mode);
  final list = await ref.watch(lexemeRepositoryProvider).watchLexemesForTier(
        mode.tierBitmask,
        stage: canonicalStage,
      );
  if (query.isEmpty) return list;
  final normalized = query.trim().toLowerCase();
  return list
      .where(
        (l) => '${l.word} ${l.translation} ${l.id}'.toLowerCase().contains(normalized),
      )
      .toList();
});

final lexemeDetailProvider = FutureProvider.family<LexemeModel, String>((ref, id) async {
  return ref.watch(lexemeRepositoryProvider).getById(id);
});

final featuredLexemeProvider = FutureProvider<LexemeModel>((ref) async {
  return ref.watch(lexemeRepositoryProvider).getById('lexeme-wunnegan');
});

void _assertLexemeDashboardWire(Ref ref, KuttiompMode mode) {
  final gateway = ref.read(protocolGatewayProvider);
  for (final id in ['3', '5', '6', '12']) {
    gateway.assertCompliant(
      id,
      context: {
        'visible_to_tiers': mode.tierBitmask,
        'elderApproved': true,
        'direct_table_access': false,
        'maintainability': 'lexeme_dashboard_wire',
      },
    );
  }
}