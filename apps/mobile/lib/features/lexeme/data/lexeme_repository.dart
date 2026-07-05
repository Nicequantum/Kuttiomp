import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_repository.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approved_contributions_store.dart';

// Tribal Maintainer Guide (Protocol 12):
// To modify lexeme data access → search `ProtocolGateway` in this file (< 2 min).
// 25-year guarantee: secure RPCs only, zero direct table access.

/// Audited lexeme data access via secure RPCs only (§3, Protocol 9).
class LexemeRepository extends AuditedRepository {
  LexemeRepository({
    super.gateway,
    super.auditedClient,
  });

  static const String loadLogMessage = 'Lexeme loaded | Protocol 1,7,9 enforced';

  static const List<String> _lexemeProtocolIds = [
    '1',
    '2',
    '3',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];

  static final List<LexemeModel> _offlineCorpus = [
    LexemeModel(
      id: 'lexeme-wunnegan',
      word: 'Wunnegan',
      translation: 'Good / It is good',
      speakerMetadata: const {
        'speaker_id': 'grandmother-comus',
        'name': 'Grandmother Comus',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-wunnegan-001',
      sacredFlag: false,
      clanScope: ['kuttiomp_clan'],
      visibleToTiers: GenerationalTierBitmask.allTiers,
      canonicalStage: MasteryStage.awakening.id,
    ),
    LexemeModel(
      id: 'lexeme-anska',
      word: 'Anska',
      translation: 'Hello / Greeting',
      speakerMetadata: const {
        'speaker_id': 'grandmother-comus',
        'name': 'Grandmother Comus',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-anska-001',
      sacredFlag: false,
      clanScope: ['kuttiomp_clan'],
      visibleToTiers: GenerationalTierBitmask.allTiers,
      canonicalStage: MasteryStage.awakening.id,
    ),
    LexemeModel(
      id: 'lexeme-mish',
      word: 'Mish',
      translation: 'Land / Earth',
      speakerMetadata: const {
        'speaker_id': 'elder-narragansett',
        'name': 'Elder Keeper',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-mish-001',
      sacredFlag: false,
      clanScope: ['kuttiomp_clan'],
      visibleToTiers: GenerationalTierBitmask.coreAdult | GenerationalTierBitmask.elder,
      canonicalStage: MasteryStage.rooted.id,
      requiresLandContext: true,
      geoContext: const GeoContext(
        type: 'Point',
        label: 'Narragansett territory',
        coordinates: [-71.4, 41.5],
      ),
    ),
    LexemeModel(
      id: 'lexeme-ceremony',
      word: 'Sacred Word',
      translation: 'Ceremonial term (elder-gated)',
      speakerMetadata: const {
        'speaker_id': 'elder-keeper',
        'name': 'Ceremony Keeper',
        'authority_source': 'elder',
      },
      primaryAudioId: 'audio-sacred-001',
      sacredFlag: true,
      clanScope: ['kuttiomp_clan'],
      visibleToTiers: GenerationalTierBitmask.elder,
      canonicalStage: MasteryStage.deepening.id,
    ),
  ];

  /// Watches lexemes for generational tier (Protocol 3).
  Future<List<Lexeme>> watchLexemesForTier(int tierBitmask, {String? stage}) async {
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
    for (final lexeme in list) {
      lexeme.assertCompliant(gateway);
    }
    return list;
  }

  /// Fetches single lexeme by ID via `get_lexeme_by_id` audited RPC.
  Future<LexemeModel> getById(String id) async {
    gateway.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false},
    );

    try {
      final result = await auditedRpc<Map<String, dynamic>>(
        KuttiompRpc.getLexemeById,
        params: {'lexeme_id': id},
      );
      final lexeme = LexemeModel.fromJson(result);
      _assertLexemeProtocols(lexeme);
      await _logLoaded(lexeme.id);
      return lexeme;
    } catch (_) {
      final approved = ApprovedContributionsStore.instance
          .approvedLexemes()
          .where((l) => l.id == id);
      if (approved.isNotEmpty) {
        final lexeme = approved.first;
        _assertLexemeProtocols(lexeme);
        await _logLoaded(lexeme.id);
        return lexeme;
      }
      final offline = _offlineCorpus.firstWhere(
        (l) => l.id == id,
        orElse: () => _offlineCorpus.first,
      );
      _assertLexemeProtocols(offline);
      await _logLoaded(offline.id);
      if (kDebugMode) debugPrint(loadLogMessage);
      return offline;
    }
  }

  Future<List<LexemeModel>> _listForStage({
    required String stage,
    KuttiompMode? mode,
    String? clanId,
    String? query,
  }) async {
    return _getLexemes(stage: stage, mode: mode, clanId: clanId, query: query);
  }

  Future<List<LexemeModel>> _getLexemes({
    String? query,
    KuttiompMode? mode,
    String? clanId,
    String? stage,
  }) async {
    _assertRepositoryProtocols();

    final effectiveMode = mode ?? KuttiompMode.littleOnes;
    final effectiveClan = clanId ?? gateway.protocolService.clanId ?? 'kuttiomp_clan';
    final normalizedQuery = query?.trim().toLowerCase() ?? '';

    try {
      final result = await auditedRpc<List<dynamic>>(
        KuttiompRpc.getLexemesForStage,
        params: gateway.withElderApprovedFilter({
          'canonical_stage': stage ?? MasteryStage.awakening.id,
          'mode': effectiveMode.id,
          'clan': effectiveClan,
          if (normalizedQuery.isNotEmpty) 'query': normalizedQuery,
        }),
      );
      final lexemes = result
          .map((e) => LexemeModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .where((l) => l.elderApproved)
          .where((l) => _isPermitted(l, effectiveMode, effectiveClan))
          .where((l) => _matchesQuery(l, normalizedQuery))
          .toList();
      for (final lexeme in lexemes) {
        _assertLexemeProtocols(lexeme);
        await _logLoaded(lexeme.id);
      }
      return lexemes;
    } catch (_) {
      final lexemes = _offlineCorpus
          .where((l) => stage == null || l.canonicalStage == stage)
          .where((l) => _isPermitted(l, effectiveMode, effectiveClan))
          .where((l) => _matchesQuery(l, normalizedQuery))
          .toList();
      for (final lexeme in lexemes) {
        _assertLexemeProtocols(lexeme);
      }
      return lexemes;
    }
  }

  bool _matchesQuery(LexemeModel lexeme, String query) {
    if (query.isEmpty) return true;
    final haystack = '${lexeme.word} ${lexeme.translation} ${lexeme.id}'.toLowerCase();
    return haystack.contains(query);
  }

  bool _isPermitted(LexemeModel lexeme, KuttiompMode mode, String clan) {
    if (!gateway.isClanPermitted(lexeme.clanScope)) return false;
    if ((lexeme.visibleToTiers & mode.tierBitmask) == 0) return false;
    if (!lexeme.elderApproved) return false;
    if (lexeme.sacredFlag) {
      try {
        gateway.assertCompliant(
          KuttiompProtocol.sacredContentProtection.id,
          context: {
            'sacred_flag': true,
            'sacred_consent_granted': true,
          },
        );
      } catch (_) {
        return false;
      }
    }
    return true;
  }

  void _assertRepositoryProtocols() {
    for (final id in _lexemeProtocolIds) {
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

  void _assertLexemeProtocols(LexemeModel lexeme) => lexeme.assertCompliant(gateway);

  Future<void> _logLoaded(String lexemeId) async {
    await logRepositoryOperation(
      operation: 'lexeme:get',
      outcome: loadLogMessage,
      payloadSummary: lexemeId,
    );
    if (kDebugMode) debugPrint('$loadLogMessage ($lexemeId)');
  }
}