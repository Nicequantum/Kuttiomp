import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/profile/domain/profile_providers.dart';
import 'package:kuttiomp_mobile/features/profile/elder_recording_providers.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/keeper_approval_panel.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';

/// Keeper dashboard – approval queue, corpus stats, contribution history (§13, Protocol 2).
class KeeperDashboardView extends ConsumerWidget {
  const KeeperDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ext = KuttiompThemeExtension.of(context);
    final stats = ref.watch(corpusStatsProvider);
    final approvedAsync = ref.watch(approvedRecordingsProvider);

    final gateContext = {
      'elderApproved': true,
      'speaker_id': 'keeper-dashboard',
      'attribution_json': {'speaker_id': 'keeper-dashboard', 'name': 'Keeper Dashboard'},
      'authority_source': 'elder',
      'schema_version': '2.2',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Keeper Dashboard', style: ext.elderTitle.copyWith(fontSize: 24)),
        const SizedBox(height: 12),
        _StatRow(label: 'Approved in corpus', value: '${stats.approvedContributions}', ext: ext),
        _StatRow(label: 'Pending review', value: '${stats.pendingContributions}', ext: ext),
        _StatRow(label: 'Audit log entries', value: '${stats.auditEntryCount}', ext: ext),
        const SizedBox(height: 16),
        AuthorityBadge(
          speakerMetadata: gateContext['attribution_json'] as Map<String, dynamic>,
          contentContext: gateContext,
        ),
        const SizedBox(height: 24),
        const KeeperApprovalPanel(),
        const SizedBox(height: 16),
        approvedAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (approved) {
            if (approved.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Contribution History', style: ext.elderTitle.copyWith(fontSize: 22)),
                const SizedBox(height: 8),
                ...approved.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '${r.word} — ${r.translation} (${r.contentType})',
                      style: ext.bodyLarge,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.ext,
  });

  final String label;
  final String value;
  final KuttiompThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: ext.bodyLarge.copyWith(fontWeight: FontWeight.w600))),
          Text(value, style: ext.bodyLarge.copyWith(color: ext.landAccent)),
        ],
      ),
    );
  }
}