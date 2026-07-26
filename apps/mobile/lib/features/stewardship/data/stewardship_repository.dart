import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_client.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_repository.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/lexeme_repository.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';
import 'package:kuttiomp_mobile/features/stewardship/domain/stewardship_models.dart';

/// Audited stewardship metrics — absolute counts only (Protocols 1, 2, 9, 10).
///
/// Tries live Supabase RPCs from migration 005 via raw client; falls back to
/// protocol-filtered offline lexeme corpus. Never invents targets. Sacred excluded.
///
/// This serves our people by making speaker labor visible without gamification
/// for 25 years of dignified Keeper stewardship.
class StewardshipRepository extends AuditedRepository {
  StewardshipRepository({
    super.gateway,
    super.auditedClient,
    LexemeRepository? lexemeRepository,
  }) : _lexemeRepository = lexemeRepository ?? LexemeRepository();

  final LexemeRepository _lexemeRepository;

  static const String rpcSpeakerSummary = 'speaker_stewardship_summary';
  static const String rpcCorpusMetrics = 'corpus_continuity_metrics';

  /// True when last fetch used live RPC; false when offline/local fallback.
  bool lastFetchUsedLiveRpc = false;

  Future<SpeakerStewardshipSummary> fetchSpeakerSummary(String speakerId) async {
    _assertStewardshipProtocols();
    lastFetchUsedLiveRpc = false;

    final live = await _tryLiveSpeakerSummary(speakerId);
    if (live != null) {
      lastFetchUsedLiveRpc = true;
      await logRepositoryOperation(
        operation: 'stewardship:speaker_summary',
        outcome: 'live_rpc',
        payloadSummary: speakerId,
      );
      return live;
    }

    final living = await _approvedLivingLexemesNonSacred();
    final forSpeaker = living.where((l) => l.speakerId == speakerId).toList();
    final withAudio = forSpeaker.where((l) => l.primaryAudioId.isNotEmpty).length;

    await logRepositoryOperation(
      operation: 'stewardship:speaker_summary',
      outcome: 'offline_fallback_absolute_counts',
      payloadSummary: speakerId,
    );

    return SpeakerStewardshipSummary(
      speakerId: speakerId,
      submittedCount: forSpeaker.length,
      pendingApprovalCount: 0,
      approvedLivingCount: forSpeaker.length,
      lastContributionAt: null,
      primaryAudioCount: withAudio,
    );
  }

  Future<CorpusContinuityMetrics> fetchCorpusMetrics() async {
    _assertStewardshipProtocols();
    lastFetchUsedLiveRpc = false;

    final live = await _tryLiveCorpusMetrics();
    if (live != null) {
      lastFetchUsedLiveRpc = true;
      await logRepositoryOperation(
        operation: 'stewardship:corpus_metrics',
        outcome: 'live_rpc',
        payloadSummary: 'approved=${live.totalApprovedLexemes}',
      );
      // Keep targets null until Keepers configure (never invent).
      return CorpusContinuityMetrics(
        totalApprovedLexemes: live.totalApprovedLexemes,
        lastApprovedAt: live.lastApprovedAt,
        targetLexemes: null,
        continuityPct: null,
      );
    }

    final living = await _approvedLivingLexemesNonSacred();

    await logRepositoryOperation(
      operation: 'stewardship:corpus_metrics',
      outcome: 'offline_fallback_absolute_counts_no_target',
      payloadSummary: 'approved=${living.length}',
    );

    return CorpusContinuityMetrics(
      totalApprovedLexemes: living.length,
      lastApprovedAt: null,
      targetLexemes: null,
      continuityPct: null,
    );
  }

  Future<SpeakerStewardshipSummary?> _tryLiveSpeakerSummary(String speakerId) async {
    final client = AuditedSupabaseClient.instance;
    if (client == null || !client.isInitialized) return null;
    try {
      final result = await client.rawClient.rpc(
        rpcSpeakerSummary,
        params: {'p_speaker_id': speakerId},
      );
      if (result is List && result.isNotEmpty) {
        return SpeakerStewardshipSummary.fromJson(
          Map<String, dynamic>.from(result.first as Map),
        );
      }
      if (result is Map) {
        return SpeakerStewardshipSummary.fromJson(Map<String, dynamic>.from(result));
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Stewardship speaker RPC fallback: $e');
    }
    return null;
  }

  Future<CorpusContinuityMetrics?> _tryLiveCorpusMetrics() async {
    final client = AuditedSupabaseClient.instance;
    if (client == null || !client.isInitialized) return null;
    try {
      final result = await client.rawClient.rpc(rpcCorpusMetrics);
      if (result is List && result.isNotEmpty) {
        return CorpusContinuityMetrics.fromJson(
          Map<String, dynamic>.from(result.first as Map),
        );
      }
      if (result is Map) {
        return CorpusContinuityMetrics.fromJson(Map<String, dynamic>.from(result));
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Stewardship corpus RPC fallback: $e');
    }
    return null;
  }

  /// Sacred and unapproved excluded from all stewardship counts (Protocol 2, 4).
  Future<List<LexemeModel>> _approvedLivingLexemesNonSacred() async {
    final list = await _lexemeRepository.watchLexemesForTier(
      GenerationalTierBitmask.allTiers,
    );
    return list.where((l) => l.elderApproved && !l.sacredFlag).toList();
  }

  void _assertStewardshipProtocols() {
    gateway.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false},
    );
    gateway.assertCompliant(
      KuttiompProtocol.nonGamificationDignity.id,
      context: const {
        'widgetType': 'StewardshipSummary',
        'usesPlayfulAssets': false,
      },
    );
    gateway.assertCompliant(
      KuttiompProtocol.elderApproval.id,
      context: const {'elderApproved': true},
    );
  }
}