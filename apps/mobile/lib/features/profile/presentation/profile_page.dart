import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/protocol/tier_aware_page.dart';
import 'package:kuttiomp_mobile/features/profile/data/profile_repository.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/auth/auth_state_provider.dart';
import 'package:kuttiomp_mobile/features/dashboard/widgets/mastery_stage_indicator.dart';
import 'package:kuttiomp_mobile/features/profile/domain/profile_model.dart';
import 'package:kuttiomp_mobile/features/profile/domain/profile_providers.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/keeper_dashboard_view.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/mode_selection_bottom_sheet.dart';
import 'package:kuttiomp_mobile/shared/widgets/approved_content_gate.dart';
import 'package:kuttiomp_mobile/shared/widgets/authority_badge.dart';

/// Full profile settings – sync, mode selector, accessibility, Keeper panel (§13).
class ProfilePage extends TierAwarePage {
  const ProfilePage({super.key}) : super(requiredTier: GenerationalTierBitmask.allTiers);

  @override
  Widget buildTierContent(BuildContext context) {
    return const _ProfilePageBody();
  }
}

class _ProfilePageBody extends ConsumerStatefulWidget {
  const _ProfilePageBody();

  @override
  ConsumerState<_ProfilePageBody> createState() => _ProfilePageBodyState();
}

class _ProfilePageBodyState extends ConsumerState<_ProfilePageBody> {
  bool _syncing = false;
  String? _statusMessage;

  static Map<String, dynamic> pageContext(KuttiompMode mode) => {
        'elderApproved': true,
        'speaker_id': 'system-profile',
        'attribution_json': {'speaker_id': 'system-profile', 'name': 'Kuttiomp Profile'},
        'speakerMetadata': {'speaker_id': 'system-profile', 'name': 'Kuttiomp Profile'},
        'authority_source': 'kuttiomp_architect',
        'schema_version': '2.2',
        'visible_to_tiers': GenerationalTierBitmask.allTiers,
        'fontSize': mode.minimumFontSize,
        'hasSemanticsLabel': true,
      };

  Future<void> _syncProfile() async {
    setState(() {
      _syncing = true;
      _statusMessage = null;
    });
    try {
      final model = await ref.read(profileRepositoryProvider).syncProfile();
      ref.read(profileModelProvider.notifier).state = model;
      ref.read(userProfileProvider.notifier).state = model.toUserProfile();
      ref.read(userMasteryProvider.notifier).state = UserMasterySummary(
        canonicalStage: model.canonicalStage,
        wordCount: model.wordCount,
        modeProgress: model.modeProgress,
      );
      setState(() => _statusMessage = ProfileRepository.syncLogMessage);
    } catch (_) {
      setState(() => _statusMessage = 'Sync deferred – local mirror active');
    } finally {
      setState(() => _syncing = false);
    }
  }

  Future<void> _simulateElderOverride() async {
    final service = ref.read(modePersistenceServiceProvider);
    final model = await service.applyElderOverride(
      mode: KuttiompMode.elder,
      elderId: 'elder-keeper-dev',
    );
    ref.read(profileModelProvider.notifier).state = model;
    ref.read(userProfileProvider.notifier).state = model.toUserProfile();
    if (mounted) {
      setState(() => _statusMessage = ProfileRepository.overrideLogMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(modeControllerProvider).valueOrNull ?? KuttiompMode.littleOnes;
    final ext = KuttiompThemeExtension.of(context);
    final profile = ref.watch(userProfileProvider);
    final preferences = ref.watch(profilePreferencesProvider);
    final auth = ref.watch(authSnapshotProvider);
    final auditLog = ref.watch(profileAuditLogProvider);
    final ctx = pageContext(mode);
    final speaker = ctx['speakerMetadata'] as Map<String, dynamic>;
    final stage = MasteryStage.fromId(profile.canonicalStage);

    return ApprovedContentGate(
      contentContext: ctx,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text('Your Profile', style: ext.elderTitle.copyWith(fontSize: 28)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              tooltip: 'Quick links',
              icon: const Icon(Icons.explore_outlined),
              onPressed: () => context.push('/search'),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthorityBadge(speakerMetadata: speaker, contentContext: ctx),
                const SizedBox(height: 16),
                _ProfileField(label: 'User ID', value: profile.userId, ext: ext),
                _ProfileField(label: 'Learning Path', value: profile.kuttiompMode.label, ext: ext),
                _ProfileField(label: 'Clan', value: profile.clan, ext: ext),
                _ProfileField(label: 'Role', value: profile.role, ext: ext),
                _ProfileField(
                  label: 'Session',
                  value: auth.isAuthenticated ? 'Authenticated' : 'Guest (offline)',
                  ext: ext,
                ),
                if (profile.elderOverride)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Elder override active',
                      style: ext.bodyLarge.copyWith(
                        color: ext.landAccent,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 16),
                Semantics(
                  button: true,
                  label: 'Change learning path',
                  child: OutlinedButton.icon(
                    onPressed: () => ModeSelectionBottomSheet.show(context, initialMode: mode),
                    icon: const Icon(Icons.swap_horiz),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, ext.minimumTouchTarget),
                    ),
                    child: Text('Change Learning Path', style: ext.bodyLarge),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Accessibility', style: ext.elderTitle.copyWith(fontSize: 22)),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: Text('High contrast', style: ext.bodyLarge),
                  value: preferences.highContrastEnabled,
                  onChanged: (v) {
                    ref.read(profilePreferencesProvider.notifier).state =
                        preferences.copyWith(highContrastEnabled: v);
                  },
                ),
                SwitchListTile(
                  title: Text('Elder accessibility overlay', style: ext.bodyLarge),
                  value: preferences.elderAccessibilityOverlay,
                  onChanged: (v) {
                    ref.read(profilePreferencesProvider.notifier).state =
                        preferences.copyWith(elderAccessibilityOverlay: v);
                  },
                ),
                SwitchListTile(
                  title: Text('Audio narration', style: ext.bodyLarge),
                  value: preferences.audioNarrationEnabled,
                  onChanged: (v) {
                    ref.read(profilePreferencesProvider.notifier).state =
                        preferences.copyWith(audioNarrationEnabled: v);
                  },
                ),
                const SizedBox(height: 24),
                MasteryStageIndicator(currentStage: stage),
                const SizedBox(height: 12),
                _QuickLinks(ext: ext),
                const SizedBox(height: 24),
                if (_statusMessage != null)
                  Text(_statusMessage!, style: ext.bodyLarge, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Semantics(
                  button: true,
                  label: 'Sync profile with Supabase',
                  child: ElevatedButton(
                    onPressed: _syncing ? null : _syncProfile,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, ext.minimumTouchTarget),
                    ),
                    child: Text(_syncing ? 'Syncing…' : 'Sync Profile', style: ext.bodyLarge),
                  ),
                ),
                if (mode == KuttiompMode.elder) ...[
                  const SizedBox(height: 12),
                  Semantics(
                    button: true,
                    label: 'Open elder recording contribution page',
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/contribute'),
                      icon: const Icon(Icons.mic),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, ext.minimumTouchTarget),
                        backgroundColor: ext.landAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Contribute Recording', style: ext.bodyLarge),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                const KeeperDashboardView(),
                const SizedBox(height: 24),
                Text('Audit Log', style: ext.elderTitle.copyWith(fontSize: 22)),
                const SizedBox(height: 8),
                if (auditLog.isEmpty)
                  Text('No audit entries yet', style: ext.bodyLarge)
                else
                  ...auditLog.reversed.take(5).map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            '${entry.operation}: ${entry.outcome}',
                            style: ext.bodyLarge.copyWith(fontSize: 18),
                          ),
                        ),
                      ),
                if (kDebugMode) ...[
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _simulateElderOverride,
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, ext.minimumTouchTarget),
                    ),
                    child: Text('Simulate Elder Override', style: ext.bodyLarge),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks({required this.ext});

  final KuttiompThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Explore the Corpus', style: ext.elderTitle.copyWith(fontSize: 22)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              label: Text('Dashboard', style: ext.bodyLarge.copyWith(fontSize: 18)),
              onPressed: () => context.go('/dashboard'),
            ),
            ActionChip(
              label: Text('Search', style: ext.bodyLarge.copyWith(fontSize: 18)),
              onPressed: () => context.push('/search'),
            ),
            ActionChip(
              label: Text('Words', style: ext.bodyLarge.copyWith(fontSize: 18)),
              onPressed: () => context.push('/dashboard'),
            ),
            ActionChip(
              label: Text('Phrases', style: ext.bodyLarge.copyWith(fontSize: 18)),
              onPressed: () => context.push('/dashboard'),
            ),
            ActionChip(
              label: Text('Lessons', style: ext.bodyLarge.copyWith(fontSize: 18)),
              onPressed: () => context.push('/dashboard'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text('$label:', style: ext.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value, style: ext.bodyLarge)),
        ],
      ),
    );
  }
}