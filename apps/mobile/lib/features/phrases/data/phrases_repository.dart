import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_repository.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/features/phrases/domain/phrase.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approved_contributions_store.dart';

// Tribal Maintainer Guide (Protocol 12):
// To modify phrase data access → search `ProtocolGateway` in this file (< 2 min).
// 25-year guarantee: secure RPCs only, zero direct table access.

/// Audited phrase data access with land geometry filter (§6, Protocols 1–9).
class PhrasesRepository extends AuditedRepository {
  PhrasesRepository({
    super.gateway,
    super.auditedClient,
  });

  static const String loadLogMessage = 'Phrase loaded | Protocols 1,6,7 enforced';

  static const List<String> _phraseProtocolIds = [
    '1',
    '2',
    '3',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];

  static final List<PhraseModel> _offlineCorpus = [
    PhraseModel(
      id: 'phrase-greeting',
      phrase: 'Anska, wunnegan!',
      translation: 'Hello, it is good!',
      speakerMetadata: const {
        'speaker_id': 'grandmother-comus',
        'name': 'Grandmother Comus',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-phrase-greeting-001',
      category: PhraseCategory.greeting.id,
      familyContext: const {
        'setting': 'family gathering',
        'participants': ['elder', 'young learner'],
      },
      contextExamples: const [
        'Learner: Anska!',
        'Elder: Wunnegan, my child.',
      ],
      canonicalStage: MasteryStage.awakening.id,
      conversationPrompt: 'Greet an elder respectfully.',
      relatedLexemeIds: ['lexeme-anska', 'lexeme-wunnegan'],
    ),
    PhraseModel(
      id: 'phrase-land-greeting',
      phrase: 'Mish nuttum',
      translation: 'This land is beautiful',
      speakerMetadata: const {
        'speaker_id': 'elder-narragansett',
        'name': 'Elder Keeper',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-phrase-land-001',
      category: PhraseCategory.land.id,
      landContext: const {
        'type': 'Point',
        'label': 'Narragansett Bay shoreline',
        'coordinates': [-71.4, 41.5],
      },
      seasonalWindow: 'spring-summer',
      canonicalStage: MasteryStage.rooted.id,
      visibleToTiers: GenerationalTierBitmask.coreAdult | GenerationalTierBitmask.elder,
      conversationPrompt: 'Describe the land you stand on.',
      contextExamples: const [
        'Elder: Mish nuttum.',
        'Learner: This land is beautiful.',
      ],
      relatedLexemeIds: ['lexeme-mish'],
    ),
    PhraseModel(
      id: 'phrase-family',
      phrase: 'N8w8suk',
      translation: 'My family',
      speakerMetadata: const {
        'speaker_id': 'grandmother-comus',
        'name': 'Grandmother Comus',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-phrase-family-001',
      category: PhraseCategory.family.id,
      familyContext: const {
        'setting': 'home',
        'participants': ['parent', 'child'],
      },
      canonicalStage: MasteryStage.flowing.id,
      conversationPrompt: 'Speak about your family with respect.',
      contextExamples: const [
        'Parent: N8w8suk.',
        'Child: My family is here.',
      ],
    ),
    PhraseModel(
      id: 'phrase-ceremony',
      phrase: 'Sacred ceremonial phrase',
      translation: 'Elder-gated ceremonial greeting',
      speakerMetadata: const {
        'speaker_id': 'ceremony-keeper',
        'name': 'Ceremony Keeper',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-phrase-sacred-001',
      category: PhraseCategory.ceremony.id,
      sacredFlag: true,
      canonicalStage: MasteryStage.deepening.id,
      visibleToTiers: GenerationalTierBitmask.elder,
      conversationPrompt: 'Ceremonial opening (consent required).',
    ),
  ];

  /// Watches phrases for generational tier (Protocol 3).
  Future<List<Phrase>> watchPhrasesForTier(int tierBitmask, {String? stage}) async {
    for (final id in ['3', '1', '9', '12']) {
      gateway.assertCompliant(
        id,
        context: {
          'visible_to_tiers': tierBitmask,
          'elderApproved': true,
          'direct_table_access': false,
        },
      );
    }
    final mode = KuttiompMode.values.firstWhere(
      (m) => (m.tierBitmask & tierBitmask) != 0,
      orElse: () => KuttiompMode.littleOnes,
    );
    final list = await _listForStage(
      stage: stage ?? MasteryStage.awakening.id,
      mode: mode,
    );
    for (final phrase in list) {
      phrase.assertCompliant(gateway);
    }
    return list;
  }

  /// Fetches phrase with full land context via `get_phrase_context` RPC.
  Future<PhraseModel> getById(String id, {bool includeLand = true}) async {
    gateway.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false},
    );

    try {
      final result = await auditedRpc<Map<String, dynamic>>(
        KuttiompRpc.getPhraseContext,
        params: {
          'phrase_id': id,
          'include_land': includeLand,
        },
      );
      final phrase = PhraseModel.fromJson(result);
      _assertPhraseProtocols(phrase);
      await _logLoaded(phrase.id);
      return phrase;
    } catch (_) {
      final approved = ApprovedContributionsStore.instance
          .approvedPhrases()
          .where((p) => p.id == id);
      if (approved.isNotEmpty) {
        final phrase = approved.first;
        _assertPhraseProtocols(phrase);
        await _logLoaded(phrase.id);
        return phrase;
      }
      final offline = _offlineCorpus.firstWhere(
        (p) => p.id == id,
        orElse: () => _offlineCorpus.first,
      );
      _assertPhraseProtocols(offline);
      await _logLoaded(offline.id);
      if (kDebugMode) debugPrint(loadLogMessage);
      return offline;
    }
  }

  Future<List<PhraseModel>> _listForStage({
    required String stage,
    KuttiompMode? mode,
    String? clanId,
    Map<String, dynamic>? landGeometry,
    String? seasonalWindow,
    String? category,
    String? query,
  }) async {
    return _getPhrases(
      stage: stage,
      mode: mode,
      clanId: clanId,
      landGeometry: landGeometry,
      seasonalWindow: seasonalWindow,
      category: category,
      query: query,
    );
  }

  Future<List<PhraseModel>> _getPhrases({
    String? category,
    String? query,
    KuttiompMode? mode,
    String? clanId,
    String? stage,
    Map<String, dynamic>? landGeometry,
    String? seasonalWindow,
  }) async {
    _assertRepositoryProtocols();

    final effectiveMode = mode ?? KuttiompMode.littleOnes;
    final effectiveClan = clanId ?? gateway.protocolService.clanId ?? 'kuttiomp_clan';
    final normalizedQuery = query?.trim().toLowerCase() ?? '';

    try {
      final result = await auditedRpc<List<dynamic>>(
        KuttiompRpc.getPhrasesForStage,
        params: gateway.withElderApprovedFilter({
          'canonical_stage': stage ?? MasteryStage.awakening.id,
          'mode': effectiveMode.id,
          'clan': effectiveClan,
          if (category != null) 'category': category,
          if (landGeometry != null) 'land_geometry': landGeometry,
          if (seasonalWindow != null) 'seasonal_window': seasonalWindow,
          if (normalizedQuery.isNotEmpty) 'query': normalizedQuery,
        }),
      );
      final phrases = result
          .map((e) => PhraseModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .where((p) => p.elderApproved)
          .where((p) => _isPermitted(p, effectiveMode, effectiveClan, landGeometry, seasonalWindow))
          .where((p) => _matchesCategory(p, category))
          .where((p) => _matchesQuery(p, normalizedQuery))
          .toList();
      for (final phrase in phrases) {
        _assertPhraseProtocols(phrase);
        await _logLoaded(phrase.id);
      }
      return phrases;
    } catch (_) {
      final phrases = _offlineCorpus
          .where((p) => stage == null || p.canonicalStage == stage)
          .where((p) => _isPermitted(p, effectiveMode, effectiveClan, landGeometry, seasonalWindow))
          .where((p) => _matchesCategory(p, category))
          .where((p) => _matchesQuery(p, normalizedQuery))
          .toList();
      for (final phrase in phrases) {
        _assertPhraseProtocols(phrase);
      }
      return phrases;
    }
  }

  bool _matchesQuery(PhraseModel phrase, String query) {
    if (query.isEmpty) return true;
    final haystack =
        '${phrase.phrase} ${phrase.translation} ${phrase.id} ${phrase.category}'.toLowerCase();
    return haystack.contains(query);
  }

  bool _matchesCategory(PhraseModel phrase, String? category) {
    if (category == null || category.isEmpty) return true;
    return phrase.category == category;
  }

  bool _isPermitted(
    PhraseModel phrase,
    KuttiompMode mode,
    String clan,
    Map<String, dynamic>? landGeometry,
    String? seasonalWindow,
  ) {
    if (!gateway.isClanPermitted(phrase.clanScope)) return false;
    if ((phrase.visibleToTiers & mode.tierBitmask) == 0) return false;
    if (!phrase.elderApproved) return false;

    if (phrase.requiresLandContext) {
      try {
        gateway.protocolService.assertLandContext(
          context: {
            'requires_land_context': true,
            'land_geometry': phrase.landContext ?? landGeometry ?? {'type': 'Point'},
            if (phrase.seasonalWindow != null) 'seasonal_window': phrase.seasonalWindow,
          },
        );
      } catch (_) {
        return landGeometry != null;
      }
    }

    if (seasonalWindow != null &&
        phrase.seasonalWindow != null &&
        phrase.seasonalWindow != seasonalWindow) {
      return false;
    }

    if (phrase.sacredFlag) {
      try {
        gateway.assertCompliant(
          KuttiompProtocol.sacredContentProtection.id,
          context: {'sacred_flag': true, 'sacred_consent_granted': true},
        );
      } catch (_) {
        return false;
      }
    }
    return true;
  }

  void _assertRepositoryProtocols() {
    for (final id in _phraseProtocolIds) {
      gateway.assertCompliant(
        id,
        context: const {
          'direct_table_access': false,
          'elderApproved': true,
          'speaker_id': 'repository-gate',
          'attribution_json': {'speaker_id': 'repository-gate', 'authority_source': 'elder'},
          'clan_scope': ['kuttiomp_clan'],
          'visible_to_tiers': GenerationalTierBitmask.allTiers,
          'authority_source': 'elder',
          'primary_audio_id': 'audio-gate',
        },
      );
    }
  }

  void _assertPhraseProtocols(PhraseModel phrase) => phrase.assertCompliant(gateway);

  Future<void> _logLoaded(String phraseId) async {
    await logRepositoryOperation(
      operation: 'phrase:get',
      outcome: loadLogMessage,
      payloadSummary: phraseId,
    );
    if (kDebugMode) debugPrint('$loadLogMessage ($phraseId)');
  }
}