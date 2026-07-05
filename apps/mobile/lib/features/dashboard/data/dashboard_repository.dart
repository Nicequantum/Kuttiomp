import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_repository.dart';
import 'package:kuttiomp_mobile/features/dashboard/domain/dashboard.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/lexeme_repository.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approved_contributions_store.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';
import 'package:kuttiomp_mobile/modes/content_renderer.dart';

// Tribal Maintainer Guide (Protocol 12):
// To modify dashboard data access → search `ProtocolGateway` in this file (< 2 min).

/// Audited dashboard snapshot access (§6, Protocol 9).
class DashboardRepository extends AuditedRepository {
  DashboardRepository({
    super.gateway,
    super.auditedClient,
    LexemeRepository? lexemeRepository,
  }) : _lexemeRepository = lexemeRepository;

  final LexemeRepository? _lexemeRepository;

  LexemeRepository get _lexemeRepo => _lexemeRepository ??
      LexemeRepository(gateway: gateway, auditedClient: auditedClient);

  /// Watches unified dashboard snapshot for generational tier (Protocol 3).
  Future<DashboardSnapshot> watchDashboardForTier({
    required int tierBitmask,
    required UserMasterySummary mastery,
    required List<KuttiompMode> modeHistory,
    required String bootstrapStatus,
  }) async {
    for (final id in ['3', '9', '12']) {
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
    final stage = MasteryStage.fromId(mastery.canonicalStage);
    final lexemes = await _lexemeRepo.watchLexemesForTier(
      tierBitmask,
      stage: mastery.canonicalStage,
    );

    final modePetals = KuttiompMode.values
        .map(
          (m) => ModePetalConfig(
            mode: m,
            progressPercent: mastery.progressFor(m),
            longPressDescription: ContentRenderer.longPressDescriptionFor(m),
          ),
        )
        .toList();

    return DashboardSnapshot(
      currentMode: mode,
      modeHistory: List.unmodifiable(modeHistory),
      masteryStage: stage,
      mastery: mastery,
      lexemeCount: lexemes.length,
      elderContributionCount: ApprovedContributionsStore.instance.approvedRecordings().length,
      bootstrapStatus: bootstrapStatus,
      modePetals: modePetals,
    );
  }
}