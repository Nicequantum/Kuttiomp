import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/profile/elder_recording_providers.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';

/// Keeper simulation panel – approves pending elder recordings (Protocol 2,8).
class KeeperApprovalPanel extends ConsumerWidget {
  const KeeperApprovalPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ext = KuttiompThemeExtension.of(context);
    final pendingAsync = ref.watch(pendingRecordingsProvider);
    final approvedAsync = ref.watch(approvedRecordingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Keeper Approval Queue', style: ext.elderTitle.copyWith(fontSize: 24)),
        const SizedBox(height: 12),
        pendingAsync.when(
          loading: () => Text('Loading pending recordings…', style: ext.bodyLarge),
          error: (_, __) => Text('Approval queue unavailable', style: ext.bodyLarge),
          data: (pending) {
            if (pending.isEmpty) {
              return Text('No pending recordings', style: ext.bodyLarge);
            }
            return Column(
              children: pending.map((recording) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(recording.word, style: ext.elderTitle.copyWith(fontSize: 22)),
                        Text(recording.translation, style: ext.bodyLarge),
                        const SizedBox(height: 8),
                        AuthorityBadge(
                          speakerMetadata: recording.speakerMetadata,
                          contentContext: recording.toContentContext(),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          key: const Key('keeper_approve'),
                          onPressed: () async {
                            await ref
                                .read(approvalSimulationProvider)
                                .approveRecording(
                                  recordingId: recording.id,
                                  keeperId: 'keeper-elder-sim',
                                );
                            ref.invalidate(pendingRecordingsProvider);
                            ref.invalidate(approvedRecordingsProvider);
                            ref.invalidate(approvedLexemeContributionsProvider);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, ext.minimumTouchTarget),
                          ),
                          child: Text('Approve Recording', style: ext.bodyLarge),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 16),
        approvedAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (approved) {
            if (approved.isEmpty) return const SizedBox.shrink();
            return Text(
              '${approved.length} approved contribution(s) in living corpus',
              style: ext.bodyLarge.copyWith(color: ext.landAccent),
              textAlign: TextAlign.center,
            );
          },
        ),
      ],
    );
  }
}