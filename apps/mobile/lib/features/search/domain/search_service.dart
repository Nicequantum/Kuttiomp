import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/features/search/data/search_repository.dart';
import 'package:kuttiomp_mobile/features/search/domain/search_result_model.dart';
import 'package:kuttiomp_mobile/modes/content_renderer.dart';
import 'package:kuttiomp_mobile/modes/mode_visual_strategy.dart';

/// Strategy contract for mode-adaptive search result rendering (§5).
abstract class SearchModeStrategy {
  KuttiompMode get mode;
  ModeVisualStrategy get visualStrategy;

  Widget wrap({
    required BuildContext context,
    required SearchResultModel result,
    required Widget child,
  }) {
    return ContentRenderer.adaptForMode(
      context: context,
      mode: mode,
      contentContext: result.toContentContext(mode: mode),
      child: child,
    );
  }

  /// Elder mode surfaces narrative voice-first preview snippets (Protocol 7).
  String voiceFirstPreview(SearchResultModel result) {
    return 'Hear ${result.title} — ${result.subtitle}';
  }
}

class LittleOnesSearchStrategy extends SearchModeStrategy {
  @override
  KuttiompMode get mode => KuttiompMode.littleOnes;

  @override
  ModeVisualStrategy get visualStrategy => ContentRenderer.strategyFor(mode);
}

class YoungLearnerSearchStrategy extends SearchModeStrategy {
  @override
  KuttiompMode get mode => KuttiompMode.youngLearner;

  @override
  ModeVisualStrategy get visualStrategy => ContentRenderer.strategyFor(mode);
}

class CoreAdultSearchStrategy extends SearchModeStrategy {
  @override
  KuttiompMode get mode => KuttiompMode.coreAdult;

  @override
  ModeVisualStrategy get visualStrategy => ContentRenderer.strategyFor(mode);
}

class ElderVoiceNarrativeSearchStrategy extends SearchModeStrategy {
  @override
  KuttiompMode get mode => KuttiompMode.elder;

  @override
  ModeVisualStrategy get visualStrategy => ContentRenderer.strategyFor(mode);

  @override
  String voiceFirstPreview(SearchResultModel result) {
    return 'Our elders remember: ${result.title}. ${result.subtitle}. '
        'Listen first, then read when ready.';
  }
}

/// Search domain service – unified discovery with ranking + mode adaptation (§4, §5).
class SearchService {
  SearchService({required this.repository});

  final SearchRepository repository;

  static SearchModeStrategy strategyFor(KuttiompMode mode) {
    switch (mode) {
      case KuttiompMode.littleOnes:
        return LittleOnesSearchStrategy();
      case KuttiompMode.youngLearner:
        return YoungLearnerSearchStrategy();
      case KuttiompMode.coreAdult:
        return CoreAdultSearchStrategy();
      case KuttiompMode.elder:
        return ElderVoiceNarrativeSearchStrategy();
    }
  }

  Future<List<SearchResultModel>> discover({
    required String query,
    required KuttiompMode mode,
    String? clanId,
    String? canonicalStage,
    Map<String, dynamic>? landGeometry,
    Set<SearchContentType>? contentTypes,
  }) async {
    final raw = await repository.search(
      query: query,
      mode: mode,
      clanId: clanId,
      canonicalStage: canonicalStage,
      landGeometry: landGeometry,
      contentTypes: contentTypes,
    );
    return rankResults(raw, query: query, mode: mode);
  }

  /// Ranks by title match, land relevance, oral authority, and content type weight.
  List<SearchResultModel> rankResults(
    List<SearchResultModel> results, {
    required String query,
    required KuttiompMode mode,
  }) {
    final normalized = query.trim().toLowerCase();
    final deduped = <String, SearchResultModel>{};
    for (final result in results) {
      deduped[result.id] = result;
    }

    final ranked = deduped.values.toList()
      ..sort((a, b) => _score(b, normalized, mode).compareTo(_score(a, normalized, mode)));
    return ranked;
  }

  int _score(SearchResultModel result, String query, KuttiompMode mode) {
    var score = 0;
    final title = result.title.toLowerCase();
    final subtitle = result.subtitle.toLowerCase();

    if (query.isEmpty) {
      score += 10;
    } else {
      if (title == query) score += 100;
      if (title.contains(query)) score += 50;
      if (subtitle.contains(query)) score += 30;
      if (result.id.toLowerCase().contains(query)) score += 10;
      if (query == 'land' && result.requiresLandContext) score += 40;
    }

    if (result.elderApproved) score += 5;
    if (result.authoritySource == 'elder') score += 3;
    if (result.primaryAudioId.isNotEmpty) score += 2;

    switch (result.contentType) {
      case SearchContentType.lexeme:
        score += 1;
      case SearchContentType.phrase:
        score += 2;
      case SearchContentType.lesson:
        score += 1;
    }

    if (mode == KuttiompMode.elder && result.requiresLandContext) score += 5;

    return score;
  }

  Widget adaptResultsForMode({
    required BuildContext context,
    required KuttiompMode mode,
    required Widget child,
  }) {
    return ContentRenderer.adaptForMode(
      context: context,
      mode: mode,
      contentContext: {
        'elderApproved': true,
        'speaker_id': 'system-search',
        'attribution_json': {'speaker_id': 'system-search'},
        'visible_to_tiers': mode.tierBitmask,
        'fontSize': mode.minimumFontSize,
        'hasSemanticsLabel': true,
      },
      child: child,
    );
  }

  Widget adaptResultForMode({
    required BuildContext context,
    required KuttiompMode mode,
    required SearchResultModel result,
    required Widget child,
  }) {
    return strategyFor(mode).wrap(context: context, result: result, child: child);
  }

  String voiceFirstPreview({
    required KuttiompMode mode,
    required SearchResultModel result,
  }) {
    return strategyFor(mode).voiceFirstPreview(result);
  }
}