import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/di/dashboard_providers.dart';
import 'package:kuttiomp_mobile/core/di/lexeme_providers.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/di/phrase_providers.dart';
import 'package:kuttiomp_mobile/core/protocol/tier_aware_page.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/dashboard/domain/dashboard.dart';
import 'package:kuttiomp_mobile/features/lexeme/presentation/lexeme_card.dart';
import 'package:kuttiomp_mobile/features/phrases/presentation/phrase_card.dart';
import 'package:kuttiomp_mobile/features/profile/domain/user_profile.dart';
import 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';
import 'package:kuttiomp_mobile/modes/content_renderer.dart';
import 'package:kuttiomp_mobile/shared/widgets/approved_content_gate.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';

/// Unified dashboard – cultural hearth with governed content previews (§5, §6).
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({
    required this.bootstrapStatus,
    this.mastery = UserMasterySummary.empty,
    super.key,
  });

  final String bootstrapStatus;
  final UserMasterySummary mastery;

  static const String themeStatusLog =
      'Kuttiomp Theme Active | Protocol 10 Dignity Enforced | '
      'Accessibility Engine | All shared widgets gated';

  static Map<String, dynamic> shellContext(KuttiompMode mode) => {
        'elderApproved': true,
        'speaker_id': 'system-shell',
        'attribution_json': {'speaker_id': 'system-shell', 'name': 'Kuttiomp'},
        'speakerMetadata': {'speaker_id': 'system-shell', 'name': 'Kuttiomp'},
        'authority_source': 'kuttiomp_architect',
        'schema_version': '2.0',
        'visible_to_tiers': GenerationalTierBitmask.allTiers,
        'fontSize': mode.minimumFontSize,
        'hasSemanticsLabel': true,
      };

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(modeControllerProvider).valueOrNull ?? KuttiompMode.littleOnes;
    final snapshotAsync = ref.watch(dashboardSnapshotProvider(widget.bootstrapStatus));

    return _DashboardTierShell(
      requiredTier: mode.tierBitmask,
      child: snapshotAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _DashboardBody(
          bootstrapStatus: widget.bootstrapStatus,
          mastery: widget.mastery,
          mode: mode,
          lexemeCount: 0,
          elderContributionCount: 0,
          scrollController: _scrollController,
        ),
        data: (snapshot) => _DashboardBody(
          bootstrapStatus: widget.bootstrapStatus,
          mastery: snapshot.mastery.modeProgress.isNotEmpty
              ? snapshot.mastery
              : widget.mastery,
          mode: snapshot.currentMode,
          lexemeCount: snapshot.lexemeCount,
          elderContributionCount: snapshot.elderContributionCount,
          scrollController: _scrollController,
          snapshot: snapshot,
        ),
      ),
    );
  }
}

class _DashboardTierShell extends TierAwarePage {
  const _DashboardTierShell({
    required super.requiredTier,
    required this.child,
  });

  final Widget child;

  @override
  Widget buildTierContent(BuildContext context) => child;
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody({
    required this.bootstrapStatus,
    required this.mastery,
    required this.mode,
    required this.lexemeCount,
    required this.elderContributionCount,
    required this.scrollController,
    this.snapshot,
  });

  final String bootstrapStatus;
  final UserMasterySummary mastery;
  final KuttiompMode mode;
  final int lexemeCount;
  final int elderContributionCount;
  final ScrollController scrollController;
  final DashboardSnapshot? snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ext = KuttiompThemeExtension.of(context);
    final ctx = DashboardPage.shellContext(mode);
    final speaker = ctx['speakerMetadata'] as Map<String, dynamic>;
    final switchLog = ref.read(modeControllerProvider.notifier).lastSwitchResult?.logMessage;
    final profile = ref.watch(userProfileProvider);
    final lexemesAsync = ref.watch(lexemeListProvider);
    final phrasesAsync = ref.watch(phraseListProvider);

    final effectiveProfile = profile.userId != UserProfile.guest.userId
        ? profile
        : UserProfile(
            userId: profile.userId,
            mode: mode.id,
            clan: profile.clan,
            role: profile.role,
            tier: mode.tierBitmask,
            canonicalStage: mastery.canonicalStage,
            wordCount: mastery.wordCount,
            modeProgress: mastery.modeProgress,
          );

    final coreContent = Column(
      key: PageStorageKey<String>('dashboard-scroll-${mode.id}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Kuttiomp — Protocol Firewall Active',
          style: ext.elderTitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text('Welcome, ${effectiveProfile.clan}', style: ext.bodyLarge, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        AuthorityBadge(speakerMetadata: speaker, contentContext: ctx),
        const SizedBox(height: 16),
        Text(bootstrapStatus, style: ext.bodyLarge, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          DashboardPage.themeStatusLog,
          style: ext.bodyLarge.copyWith(fontWeight: FontWeight.w600, color: ext.landAccent),
          textAlign: TextAlign.center,
        ),
        if (switchLog != null) ...[
          const SizedBox(height: 8),
          Text(switchLog, style: ext.bodyLarge, textAlign: TextAlign.center),
        ],
        const SizedBox(height: 8),
        Text('Mode: ${mode.label}', style: ext.bodyLarge, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(
          'Mastery: ${mastery.canonicalStage} · ${mastery.wordCount} words · '
          '$lexemeCount lexemes · $elderContributionCount elder contributions',
          style: ext.bodyLarge,
          textAlign: TextAlign.center,
        ),
        if (snapshot != null) ...[
          const SizedBox(height: 8),
          Text(
            'Stage progress: ${(snapshot!.stageProgress * 100).round()}%',
            style: ext.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            for (final petal in DashboardFeaturePetal.values)
              Semantics(
                button: true,
                label: petal.label,
                child: OutlinedButton(
                  onPressed: () => context.push(petal.route),
                  child: Text(petal.label, style: ext.bodyLarge),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Learn — preview', style: ext.elderTitle.copyWith(fontSize: 22)),
        const SizedBox(height: 12),
        lexemesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Text('Lexemes unavailable', style: ext.bodyLarge),
          data: (lexemes) => Column(
            children: lexemes
                .take(3)
                .map((lexeme) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: LexemeCard.fromLexeme(lexeme: lexeme),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 24),
        Text('Conversation Starter — preview', style: ext.elderTitle.copyWith(fontSize: 22)),
        const SizedBox(height: 12),
        phrasesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Text('Phrases unavailable', style: ext.bodyLarge),
          data: (phrases) => Column(
            children: phrases
                .take(3)
                .map((phrase) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: PhraseCard.fromPhrase(phrase: phrase),
                    ))
                .toList(),
          ),
        ),
      ],
    );

    return ApprovedContentGate(
      contentContext: ctx,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Semantics(
            label: '${DashboardPage.themeStatusLog}. $bootstrapStatus',
            child: SingleChildScrollView(
              controller: scrollController,
              child: ContentRenderer.adaptForMode(
                context: context,
                mode: mode,
                contentContext: ctx,
                child: coreContent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}