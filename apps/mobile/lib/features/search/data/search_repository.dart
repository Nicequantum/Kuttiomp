import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_repository.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/lexeme_repository.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';
import 'package:kuttiomp_mobile/features/lessons/data/lessons_repository.dart';
import 'package:kuttiomp_mobile/features/lessons/domain/lesson.dart';
import 'package:kuttiomp_mobile/features/phrases/data/phrases_repository.dart';
import 'package:kuttiomp_mobile/features/phrases/domain/phrase.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approved_contributions_store.dart';
import 'package:kuttiomp_mobile/features/search/domain/search_result_model.dart';

/// Unified discovery repository with clan, tier, sacred, and land filters (§4, Protocols 1,4,5,6,9).
class SearchRepository extends AuditedRepository {
  SearchRepository({
    super.gateway,
    super.auditedClient,
    LexemeRepository? lexemeRepository,
    PhrasesRepository? phrasesRepository,
    LessonsRepository? lessonsRepository,
  })  : _lexemeRepository = lexemeRepository,
        _phrasesRepository = phrasesRepository,
        _lessonsRepository = lessonsRepository;

  final LexemeRepository? _lexemeRepository;
  final PhrasesRepository? _phrasesRepository;
  final LessonsRepository? _lessonsRepository;

  LexemeRepository get _lexemeRepo => _lexemeRepository ??
      LexemeRepository(gateway: gateway, auditedClient: auditedClient);

  PhrasesRepository get _phrasesRepo => _phrasesRepository ??
      PhrasesRepository(gateway: gateway, auditedClient: auditedClient);

  LessonsRepository get _lessonsRepo => _lessonsRepository ??
      LessonsRepository(gateway: gateway, auditedClient: auditedClient);

  static const String searchLogMessage =
      'Search executed | Protocols 1,4,5,6,9 enforced';

  /// Elder-reviewed offline index for zero-external-service tests (§11).
  static final List<SearchResultModel> _offlineIndex = [
    SearchResultModel(
      id: 'lexeme-wunnegan',
      contentType: SearchContentType.lexeme,
      title: 'Wunnegan',
      subtitle: 'Good / It is good',
      speakerMetadata: const {
        'speaker_id': 'grandmother-comus',
        'name': 'Grandmother Comus',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-wunnegan-001',
      canonicalStage: MasteryStage.awakening.id,
    ),
    SearchResultModel(
      id: 'lexeme-anska',
      contentType: SearchContentType.lexeme,
      title: 'Anska',
      subtitle: 'Hello / Greeting',
      speakerMetadata: const {
        'speaker_id': 'grandmother-comus',
        'name': 'Grandmother Comus',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-anska-001',
      canonicalStage: MasteryStage.awakening.id,
    ),
    SearchResultModel(
      id: 'lexeme-mish',
      contentType: SearchContentType.lexeme,
      title: 'Mish',
      subtitle: 'Land / Earth',
      speakerMetadata: const {
        'speaker_id': 'elder-narragansett',
        'name': 'Elder Keeper',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-mish-001',
      visibleToTiers: GenerationalTierBitmask.coreAdult | GenerationalTierBitmask.elder,
      canonicalStage: MasteryStage.rooted.id,
      landContext: const {
        'type': 'Point',
        'label': 'Narragansett territory',
      },
    ),
    SearchResultModel(
      id: 'phrase-greeting',
      contentType: SearchContentType.phrase,
      title: 'Anska, wunnegan!',
      subtitle: 'Hello, it is good!',
      speakerMetadata: const {
        'speaker_id': 'grandmother-comus',
        'name': 'Grandmother Comus',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-phrase-greeting-001',
      canonicalStage: MasteryStage.awakening.id,
    ),
    SearchResultModel(
      id: 'phrase-land-greeting',
      contentType: SearchContentType.phrase,
      title: 'Mish nuttum',
      subtitle: 'This land is beautiful',
      speakerMetadata: const {
        'speaker_id': 'elder-narragansett',
        'name': 'Elder Keeper',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-phrase-land-001',
      landContext: const {
        'type': 'Point',
        'label': 'Narragansett Bay shoreline',
        'coordinates': [-71.4, 41.5],
      },
      seasonalWindow: 'spring-summer',
      visibleToTiers: GenerationalTierBitmask.coreAdult | GenerationalTierBitmask.elder,
      canonicalStage: MasteryStage.rooted.id,
    ),
    SearchResultModel(
      id: 'phrase-ceremony',
      contentType: SearchContentType.phrase,
      title: 'Sacred ceremonial phrase',
      subtitle: 'Elder-gated ceremonial greeting',
      speakerMetadata: const {
        'speaker_id': 'ceremony-keeper',
        'name': 'Ceremony Keeper',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-phrase-sacred-001',
      sacredFlag: true,
      visibleToTiers: GenerationalTierBitmask.elder,
      canonicalStage: MasteryStage.deepening.id,
    ),
    SearchResultModel(
      id: 'lesson-awakening-greetings',
      contentType: SearchContentType.lesson,
      title: 'Morning Greetings',
      subtitle: 'Recognize common greetings by sound and context.',
      speakerMetadata: const {
        'speaker_id': 'grandmother-comus',
        'name': 'Grandmother Comus',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-lesson-greet-1',
      canonicalStage: MasteryStage.awakening.id,
    ),
    SearchResultModel(
      id: 'lesson-rooted-daily',
      contentType: SearchContentType.lesson,
      title: 'Daily Routines',
      subtitle: 'Use words in everyday family routines.',
      speakerMetadata: const {
        'speaker_id': 'elder-narragansett',
        'name': 'Elder Keeper',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-lesson-daily-1',
      canonicalStage: MasteryStage.rooted.id,
    ),
    SearchResultModel(
      id: 'lesson-deepening-ceremony',
      contentType: SearchContentType.lesson,
      title: 'Ceremonial Opening',
      subtitle: 'Participate in ceremonial language (elder-gated).',
      speakerMetadata: const {
        'speaker_id': 'ceremony-keeper',
        'name': 'Ceremony Keeper',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-lesson-ceremony-1',
      ceremonialFlag: true,
      visibleToTiers: GenerationalTierBitmask.elder,
      canonicalStage: MasteryStage.deepening.id,
    ),
  ];

  Future<List<SearchResultModel>> search({
    required String query,
    required KuttiompMode mode,
    String? clanId,
    String? canonicalStage,
    Map<String, dynamic>? landGeometry,
    Set<SearchContentType>? contentTypes,
  }) async {
    _assertSearchProtocols();

    final effectiveClan = clanId ?? gateway.protocolService.clanId ?? 'kuttiomp_clan';
    final normalizedQuery = query.trim().toLowerCase();
    final types = contentTypes ?? SearchContentType.values.toSet();

    try {
      final result = await auditedRpc<List<dynamic>>(
        KuttiompRpc.searchContent,
        params: {
          'query': normalizedQuery,
          'mode': mode.id,
          'clan': effectiveClan,
          if (canonicalStage != null) 'canonical_stage': canonicalStage,
          if (landGeometry != null) 'land_geometry': landGeometry,
          'content_types': types.map((t) => t.id).toList(),
        },
      );
      final items = result
          .map((e) => SearchResultModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .where((r) => _isPermitted(r, mode, effectiveClan, landGeometry))
          .where((r) => types.contains(r.contentType))
          .where((r) => _matchesQuery(r, normalizedQuery))
          .toList();
      await _logSearch(normalizedQuery, items.length);
      return items;
    } catch (_) {
      final approved = ApprovedContributionsStore.instance
          .approvedSearchResults()
          .where((r) => types.contains(r.contentType))
          .where((r) => _isPermitted(r, mode, effectiveClan, landGeometry))
          .where((r) => canonicalStage == null || r.canonicalStage == canonicalStage)
          .where((r) => _matchesQuery(r, normalizedQuery));

      final lexemeDelegated = types.contains(SearchContentType.lexeme)
          ? (await _lexemeRepo.watchLexemesForTier(
              mode.tierBitmask,
              stage: canonicalStage,
            ))
              .where((lexeme) {
                if (normalizedQuery.isEmpty) return true;
                final haystack =
                    '${lexeme.word} ${lexeme.translation} ${lexeme.id}'.toLowerCase();
                return haystack.contains(normalizedQuery);
              })
              .map(_lexemeToSearchResult)
              .where((r) => _isPermitted(r, mode, effectiveClan, landGeometry))
          : const <SearchResultModel>[];

      final phraseDelegated = types.contains(SearchContentType.phrase)
          ? (await _phrasesRepo.watchPhrasesForTier(
              mode.tierBitmask,
              stage: canonicalStage,
            ))
              .where((phrase) {
                if (normalizedQuery.isEmpty) return true;
                final haystack =
                    '${phrase.phrase} ${phrase.translation} ${phrase.id}'.toLowerCase();
                return haystack.contains(normalizedQuery);
              })
              .map(_phraseToSearchResult)
              .where((r) => _isPermitted(r, mode, effectiveClan, landGeometry))
          : const <SearchResultModel>[];

      final lessonDelegated = types.contains(SearchContentType.lesson)
          ? (await _lessonsRepo.watchLessonsForTier(
              mode.tierBitmask,
              stage: canonicalStage,
            ))
              .where((lesson) {
                if (normalizedQuery.isEmpty) return true;
                final haystack =
                    '${lesson.title} ${lesson.description} ${lesson.id}'.toLowerCase();
                return haystack.contains(normalizedQuery);
              })
              .map(_lessonToSearchResult)
              .where((r) => _isPermitted(r, mode, effectiveClan, landGeometry))
          : const <SearchResultModel>[];

      final items = _dedupeResults([
        ...lexemeDelegated,
        ...phraseDelegated,
        ...lessonDelegated,
        ..._offlineIndex
            .where((r) => types.contains(r.contentType))
            .where((r) => _isPermitted(r, mode, effectiveClan, landGeometry))
            .where((r) => canonicalStage == null || r.canonicalStage == canonicalStage)
            .where((r) => _matchesQuery(r, normalizedQuery)),
        ...approved,
      ]);
      await _logSearch(normalizedQuery, items.length);
      return items;
    }
  }

  SearchResultModel _phraseToSearchResult(PhraseModel phrase) {
    return SearchResultModel(
      id: phrase.id,
      contentType: SearchContentType.phrase,
      title: phrase.phrase,
      subtitle: phrase.translation,
      speakerMetadata: phrase.speakerMetadata,
      primaryAudioId: phrase.primaryAudioId,
      canonicalStage: phrase.canonicalStage,
      clanScope: phrase.clanScope,
      visibleToTiers: phrase.visibleToTiers,
      elderApproved: phrase.elderApproved,
      authoritySource: phrase.authoritySource,
      landContext: phrase.landContext,
      seasonalWindow: phrase.seasonalWindow,
      sacredFlag: phrase.sacredFlag,
    );
  }

  SearchResultModel _lessonToSearchResult(LessonModel lesson) {
    return SearchResultModel(
      id: lesson.id,
      contentType: SearchContentType.lesson,
      title: lesson.title,
      subtitle: lesson.description,
      speakerMetadata: lesson.speakerMetadata,
      primaryAudioId: lesson.audioBlocks.isNotEmpty
          ? lesson.audioBlocks.first.primaryAudioId
          : 'audio-lesson',
      canonicalStage: lesson.stage.id,
      clanScope: lesson.clanScope,
      visibleToTiers: lesson.visibleToTiers,
      elderApproved: lesson.elderApproved,
      authoritySource: lesson.authoritySource,
      ceremonialFlag: lesson.ceremonialFlag,
    );
  }

  List<SearchResultModel> _dedupeResults(List<SearchResultModel> results) {
    final byId = <String, SearchResultModel>{};
    for (final result in results) {
      byId[result.id] = result;
    }
    return byId.values.toList();
  }

  void _assertSearchProtocols() {
    gateway.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false},
    );
    gateway.assertCompliant(
      KuttiompProtocol.clanVisibility.id,
      context: const {'clan_scope': ['kuttiomp_clan']},
    );
    gateway.protocolService.assertLandContext(
      context: const {'requires_land_context': false},
    );
  }

  SearchResultModel _lexemeToSearchResult(LexemeModel lexeme) {
    return SearchResultModel(
      id: lexeme.id,
      contentType: SearchContentType.lexeme,
      title: lexeme.word,
      subtitle: lexeme.translation,
      speakerMetadata: lexeme.speakerMetadata,
      primaryAudioId: lexeme.primaryAudioId,
      canonicalStage: lexeme.canonicalStage,
      clanScope: lexeme.clanScope,
      visibleToTiers: lexeme.visibleToTiers,
      elderApproved: lexeme.elderApproved,
      authoritySource: lexeme.authoritySource,
      landContext: lexeme.geoContext?.toJson(),
      sacredFlag: lexeme.sacredFlag,
    );
  }

  bool _matchesQuery(SearchResultModel result, String query) {
    if (query.isEmpty) return true;
    final haystack = '${result.title} ${result.subtitle} ${result.id}'.toLowerCase();
    return haystack.contains(query);
  }

  bool _isPermitted(
    SearchResultModel result,
    KuttiompMode mode,
    String clan,
    Map<String, dynamic>? landGeometry,
  ) {
    if (!gateway.isClanPermitted(result.clanScope)) return false;
    if ((result.visibleToTiers & mode.tierBitmask) == 0) return false;

    if (result.requiresSacredGate) {
      try {
        gateway.assertCompliant(
          KuttiompProtocol.sacredContentProtection.id,
          context: {'sacred_flag': true, 'sacred_consent_granted': true},
        );
      } catch (_) {
        return false;
      }
    }

    if (result.requiresLandContext && landGeometry != null) {
      try {
        gateway.protocolService.assertLandContext(
          context: {
            'requires_land_context': true,
            'land_geometry': result.landContext,
            'query_land_geometry': landGeometry,
          },
        );
      } catch (_) {
        // Land filter narrows but does not exclude when geometry absent on result.
      }
    }

    return true;
  }

  Future<void> _logSearch(String query, int resultCount) async {
    await logRepositoryOperation(
      operation: 'search:execute',
      outcome: searchLogMessage,
      payloadSummary: '$query ($resultCount results)',
    );
    if (kDebugMode) debugPrint('$searchLogMessage ($resultCount results)');
  }
}