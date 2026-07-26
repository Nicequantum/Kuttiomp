import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/routing/app_router.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/features/auth/auth_state.dart';
import 'package:kuttiomp_mobile/features/profile/domain/user_profile.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';
import 'package:kuttiomp_mobile/modes/mode_persistence.dart';
import 'package:kuttiomp_mobile/shared/design_system/kuttiomp_design_system.dart';

/// Root mode-aware application with GoRouter + KuttiompThemeExtension (§4, §5).
///
/// This serves our people by registering mode-specific typography and contrast
/// in MaterialApp.theme so every generation receives respectful presentation.
class ModeAwareMaterialApp extends ConsumerStatefulWidget {
  const ModeAwareMaterialApp({
    required this.bootstrapStatus,
    required this.persistence,
    this.mastery = UserMasterySummary.empty,
    this.profilePersisted = false,
    required this.authSnapshot,
    this.userProfile = UserProfile.guest,
    super.key,
  });

  final String bootstrapStatus;
  final ModePersistence persistence;
  final UserMasterySummary mastery;
  final bool profilePersisted;
  final KuttiompAuthSnapshot authSnapshot;
  final UserProfile userProfile;

  @override
  ConsumerState<ModeAwareMaterialApp> createState() => _ModeAwareMaterialAppState();
}

class _ModeAwareMaterialAppState extends ConsumerState<ModeAwareMaterialApp> {
  late final GoRouter _router;
  late final _RouterRefresh _refresh;

  @override
  void initState() {
    super.initState();
    KuttiompDesignSystem.assertDignity();
    _refresh = _RouterRefresh(ref);
    _router = createAppRouter(
      persistence: widget.persistence,
      bootstrapStatus: widget.bootstrapStatus,
      refreshListenable: _refresh,
      mastery: widget.mastery,
      authSnapshot: widget.authSnapshot,
    );
  }

  @override
  void dispose() {
    _refresh.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(modeControllerProvider).valueOrNull ?? KuttiompMode.littleOnes;
    final theme = KuttiompTheme.forMode(mode);

    return MaterialApp.router(
      title: 'Kuttiomp',
      debugShowCheckedModeBanner: false,
      theme: KuttiompTheme.light.copyWith(
        colorScheme: theme.colorScheme,
        scaffoldBackgroundColor: theme.scaffoldBackgroundColor,
        textTheme: theme.textTheme,
        extensions: [KuttiompThemeExtension.forMode(mode)],
      ),
      routerConfig: _router,
    );
  }
}

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(this.ref) {
    ref.listen(modeControllerProvider, (_, __) => notifyListeners());
  }

  final WidgetRef ref;

  @override
  void dispose() {
    super.dispose();
  }
}