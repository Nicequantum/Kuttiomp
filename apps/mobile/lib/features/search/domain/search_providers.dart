import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/di/injection.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/di/lexeme_providers.dart';
import 'package:kuttiomp_mobile/core/di/lesson_providers.dart';
import 'package:kuttiomp_mobile/core/di/phrase_providers.dart';
import 'package:kuttiomp_mobile/features/search/data/search_repository.dart';
import 'package:kuttiomp_mobile/features/search/domain/search_result_model.dart';
import 'package:kuttiomp_mobile/features/search/domain/search_service.dart';

/// Filter state for unified discovery (dashboard Discover petal integration).
class SearchFilter {
  const SearchFilter({
    required this.mode,
    required this.canonicalStage,
    this.landGeometry,
    this.contentTypes = const {
      SearchContentType.lexeme,
      SearchContentType.phrase,
      SearchContentType.lesson,
    },
  });

  final KuttiompMode mode;
  final String canonicalStage;
  final Map<String, dynamic>? landGeometry;
  final Set<SearchContentType> contentTypes;

  static const SearchFilter defaultFilter = SearchFilter(
    mode: KuttiompMode.littleOnes,
    canonicalStage: 'awakening',
    landGeometry: {'type': 'Point', 'label': 'Narragansett territory'},
  );
}

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchFilterProvider = StateProvider<SearchFilter>(
  (ref) => SearchFilter.defaultFilter,
);

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(
    gateway: ref.watch(protocolGatewayProvider),
    auditedClient: ref.watch(auditedClientProvider),
    lexemeRepository: ref.watch(lexemeRepositoryProvider),
    phrasesRepository: ref.watch(phrasesRepositoryProvider),
    lessonsRepository: ref.watch(lessonsRepositoryProvider),
  );
});

final searchServiceProvider = Provider<SearchService>((ref) {
  return SearchService(repository: ref.watch(searchRepositoryProvider));
});

final searchResultsProvider = FutureProvider<List<SearchResultModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final filter = ref.watch(searchFilterProvider);
  final mode = ref.watch(modeControllerProvider).valueOrNull ?? filter.mode;
  final service = ref.watch(searchServiceProvider);

  return service.discover(
    query: query,
    mode: mode,
    canonicalStage: filter.canonicalStage,
    landGeometry: filter.landGeometry,
    contentTypes: filter.contentTypes,
  );
});