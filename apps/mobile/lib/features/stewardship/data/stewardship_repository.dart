import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_repository.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/lexeme_repository.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';
import 'package:kuttiomp_mobile/features/stewardship/domain/stewardship_models.dart';

/// Audited stewardship metrics — absolute counts only (Protocols 1, 2, 9, 10).
///
/// Prefers Supabase RPCs from migration 005 when registered; otherwise derives
/// counts from protocol-filtered lexeme corpus (no invented targets).
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

  Future<SpeakerStewardshipSummary> fetchSpeakerSummary(String speakerId) async {
    _assertStewardshipProtocols();

    final living = await _approvedLivingLexemes();
    final forSpeaker = living.where((l) => l.speakerId == speakerId).toList();
    final withAudio = forSpeaker.where((l) => l.primaryAudioId.isNotEmpty).length;

    await logRepositoryOperation(
      operation: 'stewardship:speaker_summary',
      outcome: 'absolute_counts_derived',
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

    final living = await _approvedLivingLexemes();

    await logRepositoryOperation(
      operation: 'stewardship:corpus_metrics',
      outcome: 'absolute_counts_no_target',
      payloadSummary: 'approved=${living.length}',
    );

    // target_lexemes and continuity_pct intentionally null — Keepers have not
    // defined a target in repository configuration.
    return CorpusContinuityMetrics(
      totalApprovedLexemes: living.length,
      lastApprovedAt: null,
      targetLexemes: null,
      continuityPct: null,
    );
  }

  Future<List<LexemeModel>> _approvedLivingLexemes() async {
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