import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/profile/domain/elder_recording_model.dart';

/// Protocol 2 – blocks unapproved elder content with respectful pending message.
class PendingApprovalGate extends StatelessWidget {
  const PendingApprovalGate({
    required this.recording,
    required this.child,
    super.key,
  });

  final ElderRecordingModel recording;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ext = KuttiompThemeExtension.of(context);

    if (recording.isApproved && recording.elderApproved) {
      return child;
    }

    return Semantics(
      label: 'Content pending elder review',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ext.surfaceMist,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ext.barkPrimary.withOpacity(0.4)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hourglass_top, color: ext.barkPrimary, size: 40),
            const SizedBox(height: 12),
            Text(
              'Content pending elder review',
              style: ext.elderTitle.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your recording "${recording.word}" awaits Keeper approval '
              'before it can join the living corpus.',
              style: ext.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}