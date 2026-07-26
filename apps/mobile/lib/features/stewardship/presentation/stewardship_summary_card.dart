import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/di/injection.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/stewardship/data/stewardship_repository.dart';
import 'package:kuttiomp_mobile/features/stewardship/domain/stewardship_models.dart';
import 'package:kuttiomp_mobile/shared/design_system/kuttiomp_content_widget.dart';

final stewardshipRepositoryProvider = Provider<StewardshipRepository>((ref) {
  return StewardshipRepository(
    gateway: ref.watch(protocolGatewayProvider),
    auditedClient: ref.watch(auditedClientProvider),
  );
});

final corpusContinuityProvider = FutureProvider<CorpusContinuityMetrics>((ref) {
  return ref.watch(stewardshipRepositoryProvider).fetchCorpusMetrics();
});

final speakerStewardshipProvider =
    FutureProvider.family<SpeakerStewardshipSummary, String>((ref, speakerId) {
  return ref.watch(stewardshipRepositoryProvider).fetchSpeakerSummary(speakerId);
});

/// Read-only stewardship summary — Core Adult / Elder modes only (Protocol 10).
///
/// This serves our people by showing absolute contribution counts as service to
/// the living language, never as competitive score, through 2050.
class StewardshipSummaryCard extends KuttiompContentWidget {
  StewardshipSummaryCard({
    required this.summary,
    required this.corpus,
    required super.speakerMetadata,
    double fontSize = 32,
    super.key,
  }) : super(
          elderApproved: true,
          clanScope: const ['kuttiomp_clan'],
          contentContext: {
            'elderApproved': true,
            'clan_scope': ['kuttiomp_clan'],
            'authority_source': 'elder',
            'speaker_id': speakerMetadata['speaker_id'] ?? 'stewardship',
            'attribution_json': speakerMetadata,
            // Protocol 11 – elder-centric minimum (32pt) when shown in Elder mode.
            'fontSize': fontSize,
          },
        );

  final SpeakerStewardshipSummary summary;
  final CorpusContinuityMetrics corpus;

  @override
  Widget buildProtocolContent(BuildContext context) {
    final ext = KuttiompThemeExtension.of(context);
    final speakerName = speakerMetadata['name']?.toString() ?? 'Attributed speaker';

    return Semantics(
      label:
          'Stewardship summary for $speakerName. '
          '${summary.approvedLivingCount} approved living contributions. '
          'Corpus has ${corpus.totalApprovedLexemes} approved lexemes.',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: ext.landAccent, width: 1.5),
          borderRadius: BorderRadius.circular(8),
          color: ext.surfaceMist,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Corpus Stewardship', style: ext.elderTitle),
            const SizedBox(height: 8),
            Text(
              'Your attributed contributions strengthen the living language for the generations.',
              style: ext.bodyLarge,
            ),
            const SizedBox(height: 12),
            Text('Speaker: $speakerName', style: ext.bodyLarge),
            Text(
              'Approval status: living corpus counts include elder-approved entries only.',
              style: ext.bodyLarge,
            ),
            const SizedBox(height: 12),
            _CountRow(label: 'Submitted', value: summary.submittedCount, style: ext.bodyLarge),
            _CountRow(
              label: 'Pending elder review',
              value: summary.pendingApprovalCount,
              style: ext.bodyLarge,
            ),
            _CountRow(
              label: 'Approved living',
              value: summary.approvedLivingCount,
              style: ext.bodyLarge,
            ),
            _CountRow(
              label: 'Primary audio attributions',
              value: summary.primaryAudioCount,
              style: ext.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text('Living corpus (absolute)', style: ext.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
            _CountRow(
              label: 'Approved lexemes',
              value: corpus.totalApprovedLexemes,
              style: ext.bodyLarge,
            ),
            if (corpus.hasKeeperTarget) ...[
              const SizedBox(height: 8),
              // Linear path only — no playful animation (Protocol 10).
              LinearProgressIndicator(
                value: (corpus.continuityPct ?? 0).clamp(0.0, 1.0),
                minHeight: 12,
                backgroundColor: ext.landAccent.withValues(alpha: 0.2),
                color: ext.landAccent,
              ),
              Text(
                'Toward Keeper-defined target: ${corpus.targetLexemes}',
                style: ext.bodyLarge,
              ),
            ] else
              Text(
                'No Keeper-defined lexicon target is configured. Absolute counts only.',
                style: ext.bodyLarge,
              ),
          ],
        ),
      ),
    );
  }
}

class _CountRow extends StatelessWidget {
  const _CountRow({required this.label, required this.value, required this.style});

  final String label;
  final int value;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: style)),
          Text('$value', style: style.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

/// Mode-gated shell: only Core Adult and Elder see stewardship (Stream D).
class StewardshipModeGatedCard extends ConsumerWidget {
  const StewardshipModeGatedCard({
    this.speakerId = 'grandmother-comus',
    super.key,
  });

  final String speakerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(modeControllerProvider).valueOrNull ?? KuttiompMode.littleOnes;
    if (mode != KuttiompMode.coreAdult && mode != KuttiompMode.elder) {
      return const SizedBox.shrink();
    }

    final summaryAsync = ref.watch(speakerStewardshipProvider(speakerId));
    final corpusAsync = ref.watch(corpusContinuityProvider);

    // Do not wrap with ContentRenderer/ElderModeOverlay here — this card lives
    // inside the dashboard ListView (unbounded height). Parent ModeAwareShell
    // already applies mode presentation.
    return summaryAsync.when(
      data: (summary) => corpusAsync.when(
        data: (corpus) => StewardshipSummaryCard(
          summary: summary,
          corpus: corpus,
          fontSize: mode.minimumFontSize,
          speakerMetadata: {
            'speaker_id': summary.speakerId,
            'name': 'Attributed speaker',
            'authority_source': 'elder',
          },
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Text('Stewardship unavailable: $e'),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('Stewardship unavailable: $e'),
    );
  }
}