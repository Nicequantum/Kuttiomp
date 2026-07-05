import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/bootstrap/first_launch_service.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/profile/domain/profile_model.dart';
import 'package:kuttiomp_mobile/features/profile/domain/profile_providers.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/mode_selection_bottom_sheet.dart';
import 'package:kuttiomp_mobile/modes/content_renderer.dart';

/// Audio-guided first-launch onboarding with consent and guided tour (§13).
class FirstLaunchOnboarding extends ConsumerStatefulWidget {
  const FirstLaunchOnboarding({super.key});

  @override
  ConsumerState<FirstLaunchOnboarding> createState() => _FirstLaunchOnboardingState();
}

class _FirstLaunchOnboardingState extends ConsumerState<FirstLaunchOnboarding> {
  int _tourStep = 0;
  KuttiompMode _selected = KuttiompMode.littleOnes;
  bool _consentGiven = false;
  bool _narrationStarted = false;

  static const _tourSteps = [
    'Welcome to Kuttiomp — the sovereign home of the Narragansett language.',
    'Every word, phrase, and lesson is elder-governed and protected by twelve cultural protocols.',
    'Select the learning path that honors your journey. Little Ones is recommended for our youngest learners.',
    'Your choice persists across restarts and syncs respectfully with tribal records.',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startNarration());
  }

  Future<void> _startNarration() async {
    if (_narrationStarted) return;
    _narrationStarted = true;
    final service = FirstLaunchService(
      modePersistenceService: ref.read(modePersistenceServiceProvider),
    );
    await service.playWelcomeNarration();
  }

  Future<void> _completeOnboarding(GoRouter router) async {
    final service = FirstLaunchService(
      modePersistenceService: ref.read(modePersistenceServiceProvider),
    );

    final profile = await service.completeOnboarding(
      mode: _selected,
      router: router,
      preferences: const ProfilePreferences(audioNarrationEnabled: true),
    );

    ref.read(profileModelProvider.notifier).state = profile;
    ref.read(userProfileProvider.notifier).state = profile.toUserProfile();
    ref.read(userMasteryProvider.notifier).state = UserMasterySummary(
      canonicalStage: profile.canonicalStage,
      wordCount: profile.wordCount,
      modeProgress: profile.modeProgress,
    );

    if (mounted) context.go('/dashboard');
  }

  void _nextStep() {
    if (_tourStep < _tourSteps.length - 1) {
      setState(() => _tourStep++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ext = KuttiompThemeExtension.forMode(_selected);
    final router = GoRouter.of(context);
    final onLastStep = _tourStep == _tourSteps.length - 1;

    return ModeSelectionTierShell(
      child: Theme(
        data: Theme.of(context).copyWith(extensions: [ext]),
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Begin Your Journey', style: ext.elderTitle, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Semantics(
                    label: _tourSteps[_tourStep],
                    child: Text(
                      _tourSteps[_tourStep],
                      style: ext.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Step ${_tourStep + 1} of ${_tourSteps.length}',
                    style: ext.bodyLarge.copyWith(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  if (onLastStep) ...[
                    ...KuttiompMode.values.map((mode) {
                      return Semantics(
                        label: ContentRenderer.longPressDescriptionFor(mode),
                        child: RadioListTile<KuttiompMode>(
                          title: Text(mode.label, style: ext.bodyLarge),
                          subtitle: Text(
                            ContentRenderer.longPressDescriptionFor(mode),
                            style: ext.bodyLarge.copyWith(fontSize: 20),
                          ),
                          value: mode,
                          groupValue: _selected,
                          onChanged: (value) {
                            if (value != null) setState(() => _selected = value);
                          },
                        ),
                      );
                    }),
                    CheckboxListTile(
                      value: _consentGiven,
                      onChanged: (v) => setState(() => _consentGiven = v ?? false),
                      title: Text(
                        'I understand that my learning path will be saved respectfully.',
                        style: ext.bodyLarge,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                  const Spacer(),
                  if (!onLastStep)
                    ElevatedButton(
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, ext.minimumTouchTarget),
                      ),
                      child: Text('Continue', style: ext.bodyLarge),
                    )
                  else
                    ElevatedButton(
                      onPressed: _consentGiven ? () => _completeOnboarding(router) : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, ext.minimumTouchTarget),
                      ),
                      child: Text('Begin with ${_selected.label}', style: ext.bodyLarge),
                    ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => ModeSelectionBottomSheet.show(
                      context,
                      withAudioNarration: true,
                      initialMode: _selected,
                      onSelect: (mode) async {
                        setState(() => _selected = mode);
                      },
                    ),
                    child: Text('Open mode selector', style: ext.bodyLarge),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Backward-compatible alias.
typedef FirstLaunchModeSelection = FirstLaunchOnboarding;