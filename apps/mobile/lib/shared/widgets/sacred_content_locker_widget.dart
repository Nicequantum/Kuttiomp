import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/protocol/ceremonial_vault.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';

/// Protocol 4 – sacred content consent gate before render.
class SacredContentLockerWidget extends StatefulWidget {
  const SacredContentLockerWidget({
    required this.recordId,
    required this.isSacred,
    required this.contentContext,
    required this.child,
    super.key,
  });

  final String recordId;
  final bool isSacred;
  final Map<String, dynamic> contentContext;
  final Widget child;

  @override
  State<SacredContentLockerWidget> createState() => _SacredContentLockerWidgetState();
}

class _SacredContentLockerWidgetState extends State<SacredContentLockerWidget> {
  bool _consentGranted = false;
  final _vault = CeremonialVault();

  @override
  Widget build(BuildContext context) {
    if (!widget.isSacred || _consentGranted) {
      return widget.child;
    }

    final ext = KuttiompThemeExtension.of(context);
    return Semantics(
      label: 'Sacred content requires elder consent',
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sacred content requires elder consent',
              style: ext.elderTitle.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'This word carries ceremonial significance. Consent is required before viewing.',
              style: ext.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await _vault.store(
                  recordId: widget.recordId,
                  payload: widget.contentContext,
                  consentGranted: true,
                );
                setState(() => _consentGranted = true);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, ext.minimumTouchTarget),
              ),
              child: Text('Grant Sacred Consent', style: ext.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }
}