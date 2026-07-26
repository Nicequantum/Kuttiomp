import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/di/mode_redirect_middleware.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/routing/auth_redirect_guard.dart';
import 'package:kuttiomp_mobile/features/auth/auth_state.dart';
import 'package:kuttiomp_mobile/features/dashboard/presentation/content_list_screens.dart';
import 'package:kuttiomp_mobile/features/dashboard/presentation/detail_screens.dart';
import 'package:kuttiomp_mobile/features/lexeme/presentation/lexeme_detail_screen.dart';
import 'package:kuttiomp_mobile/features/lexeme/presentation/lexeme_list_screen.dart';
import 'package:kuttiomp_mobile/features/dashboard/presentation/dashboard_screen.dart';
import 'package:kuttiomp_mobile/features/search/presentation/search_page.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/elder_recording_page.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/first_launch_onboarding.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/profile_page.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';
import 'package:kuttiomp_mobile/modes/mode_persistence.dart';
import 'package:kuttiomp_mobile/modes/mode_shell_scaffold.dart';
import 'package:kuttiomp_mobile/shared/widgets/approved_content_gate.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
final pageStorageBucket = PageStorageBucket();

/// Creates governed GoRouter with StatefulShellRoute and full gate wrappers (§5).
///
/// This serves our people by preserving scroll and form state across mode switches
/// via PageStorageBucket while enforcing tier gates on every route for 25 years.
GoRouter createAppRouter({
  required ModePersistence persistence,
  required String bootstrapStatus,
  required Listenable refreshListenable,
  UserMasterySummary? mastery,
  KuttiompAuthSnapshot? authSnapshot,
}) {
  final modeMiddleware = ModeRedirectMiddleware(persistence: persistence);
  final authGuard = AuthRedirectGuard(
    authSnapshot: authSnapshot ?? KuttiompAuthSnapshot.guest(),
  );

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: persistence.isFirstLaunchComplete ? '/dashboard' : '/first-launch',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final authRedirect = authGuard.redirect(context, state);
      if (authRedirect != null) return authRedirect;
      return modeMiddleware.redirect(context, state);
    },
    routes: [
      GoRoute(
        path: '/first-launch',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _gatedPage(
          state: state,
          requiredTier: GenerationalTierBitmask.allTiers,
          child: const FirstLaunchOnboarding(),
        ),
      ),
      GoRoute(
        path: '/contribute',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _gatedPage(
          state: state,
          requiredTier: GenerationalTierBitmask.elder,
          child: const ElderRecordingPage(),
        ),
      ),
      GoRoute(
        path: '/lexemes',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _gatedPage(
          state: state,
          requiredTier: GenerationalTierBitmask.allTiers,
          child: const LexemeListScreen(),
        ),
      ),
      GoRoute(
        path: '/phrases',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _gatedPage(
          state: state,
          requiredTier: GenerationalTierBitmask.allTiers,
          child: const PhrasesScreen(),
        ),
      ),
      GoRoute(
        path: '/lessons',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _gatedPage(
          state: state,
          requiredTier: GenerationalTierBitmask.allTiers,
          child: const LessonsScreen(),
        ),
      ),
      GoRoute(
        path: '/lexeme/:id',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return _gatedPage(
            state: state,
            requiredTier: GenerationalTierBitmask.allTiers,
            child: LexemeDetailScreen(lexemeId: id),
          );
        },
      ),
      GoRoute(
        path: '/phrase/:id',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return _gatedPage(
            state: state,
            requiredTier: GenerationalTierBitmask.allTiers,
            child: PhraseDetailScreen(phraseId: id),
          );
        },
      ),
      GoRoute(
        path: '/lesson/:id',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return _gatedPage(
            state: state,
            requiredTier: GenerationalTierBitmask.allTiers,
            child: LessonDetailScreen(lessonId: id),
          );
        },
      ),
      GoRoute(
        path: '/search',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _gatedPage(
          state: state,
          requiredTier: GenerationalTierBitmask.allTiers,
          child: const SearchPage(),
        ),
      ),
      GoRoute(
        path: '/profile',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) => _gatedPage(
          state: state,
          requiredTier: GenerationalTierBitmask.allTiers,
          child: const ProfilePage(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return PageStorage(
            bucket: pageStorageBucket,
            child: ModeShellScaffold(
              navigationShell: navigationShell,
              bootstrapStatus: bootstrapStatus,
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: shellNavigatorKey,
            routes: [
              GoRoute(
                path: '/dashboard',
                pageBuilder: (context, state) => _gatedPage(
                  state: state,
                  requiredTier: KuttiompProtocolService.instance.currentMode.tierBitmask,
                  child: const DashboardScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

CustomTransitionPage<void> _gatedPage({
  required GoRouterState state,
  required int requiredTier,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeScaleTransition(animation: animation, child: child);
    },
    child: _TierGatedShell(requiredTier: requiredTier, child: child),
  );
}

/// Wraps every routed page with TierAware enforcement + ApprovedContentGate (§5).
class _TierGatedShell extends StatelessWidget {
  const _TierGatedShell({
    required this.requiredTier,
    required this.child,
  });

  final int requiredTier;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final contentContext = {
      'elderApproved': true,
      'visible_to_tiers': requiredTier,
      'speaker_id': 'system-router',
      'attribution_json': {'speaker_id': 'system-router'},
      'authority_source': 'kuttiomp_architect',
      'schema_version': '2.0',
    };

    try {
      KuttiompProtocolService.instance.assertTierAccess(
        context: {'visible_to_tiers': requiredTier},
      );
    } catch (_) {
      return const Scaffold(
        body: Center(
          child: Text('This content is not available in your current learning path.'),
        ),
      );
    }

    return ApprovedContentGate(
      contentContext: contentContext,
      builder: (_) => child,
    );
  }
}