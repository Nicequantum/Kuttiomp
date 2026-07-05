import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/protocol/tier_aware_page.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/profile/domain/elder_recording_model.dart';
import 'package:kuttiomp_mobile/features/profile/domain/recording_service.dart';
import 'package:kuttiomp_mobile/features/profile/elder_recording_providers.dart';
import 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/pending_approval_gate.dart';
import 'package:kuttiomp_mobile/shared/design_system/oral_first_player.dart';
import 'package:kuttiomp_mobile/shared/widgets/approved_content_gate.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';

/// Elder mode recording and submission page (Protocol 2 crown jewel).
class ElderRecordingPage extends ConsumerStatefulWidget {
  const ElderRecordingPage({super.key});

  @override
  ConsumerState<ElderRecordingPage> createState() => _ElderRecordingPageState();
}

class _ElderRecordingPageState extends ConsumerState<ElderRecordingPage> {
  final _wordController = TextEditingController();
  final _translationController = TextEditingController();
  ElderRecordingModel? _draft;
  ElderRecordingModel? _submitted;
  bool _recording = false;
  bool _submitting = false;

  @override
  void dispose() {
    _wordController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    setState(() => _recording = true);
    try {
      final service = ref.read(recordingServiceProvider);
      final profile = ref.read(userProfileProvider);
      final draft = await service.captureRecording(
        word: _wordController.text.trim(),
        translation: _translationController.text.trim(),
        speakerId: profile.userId,
        speakerName: 'Elder Contributor',
      );
      setState(() {
        _draft = draft;
        _submitted = null;
      });
    } finally {
      setState(() => _recording = false);
    }
  }

  Future<void> _submit() async {
    if (_draft == null) return;
    setState(() => _submitting = true);
    try {
      final service = ref.read(recordingServiceProvider);
      final pending = await service.submitForApproval(_draft!);
      setState(() => _submitted = pending);
      ref.invalidate(pendingRecordingsProvider);
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(modeControllerProvider).valueOrNull ?? KuttiompMode.elder;
    final ext = KuttiompThemeExtension.of(context);

    final gateContext = {
      'elderApproved': true,
      'speaker_id': 'system-elder-record',
      'attribution_json': {'speaker_id': 'system-elder-record'},
      'visible_to_tiers': GenerationalTierBitmask.elder,
      'fontSize': mode.minimumFontSize,
      'hasSemanticsLabel': true,
    };

    return _ElderRecordingTierShell(
      child: ApprovedContentGate(
        contentContext: gateContext,
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Contribute Voice', style: ext.elderTitle.copyWith(fontSize: 28)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Record oral tradition for elder review (Protocol 2)',
                    style: ext.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    key: const Key('word_field'),
                    controller: _wordController,
                    style: ext.bodyLarge,
                    decoration: InputDecoration(
                      labelText: 'Word or phrase',
                      labelStyle: ext.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('translation_field'),
                    controller: _translationController,
                    style: ext.bodyLarge,
                    decoration: InputDecoration(
                      labelText: 'Translation (secondary)',
                      labelStyle: ext.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    key: const Key('record_stub'),
                    onPressed: _recording ? null : _capture,
                    icon: const Icon(Icons.mic),
                    label: Text(
                      _recording ? 'Recording…' : 'Record Audio (Stub)',
                      style: ext.bodyLarge,
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, ext.minimumTouchTarget),
                    ),
                  ),
                  if (_draft != null) ...[
                    const SizedBox(height: 24),
                    Text('Preview', style: ext.elderTitle.copyWith(fontSize: 24)),
                    const SizedBox(height: 8),
                    OralFirstPlayer(
                      speakerMetadata: _draft!.speakerMetadata,
                      contentContext: _draft!.toContentContext(),
                      audioLabel: 'Hear ${_draft!.word}',
                      textContent: _draft!.translation,
                    ),
                    const SizedBox(height: 8),
                    AuthorityBadge(
                      speakerMetadata: _draft!.speakerMetadata,
                      contentContext: _draft!.toContentContext(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      key: const Key('submit_secure'),
                      onPressed: _submitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, ext.minimumTouchTarget),
                      ),
                      child: Text(
                        _submitting ? 'Submitting…' : 'Submit for Keeper Review',
                        style: ext.bodyLarge,
                      ),
                    ),
                  ],
                  if (_submitted != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      RecordingService.submitLogMessage,
                      style: ext.bodyLarge.copyWith(
                        color: ext.landAccent,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    PendingApprovalGate(
                      recording: _submitted!,
                      child: const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ElderRecordingTierShell extends TierAwarePage {
  const _ElderRecordingTierShell({required this.child})
      : super(requiredTier: GenerationalTierBitmask.elder);

  final Widget child;

  @override
  Widget buildTierContent(BuildContext context) => child;
}