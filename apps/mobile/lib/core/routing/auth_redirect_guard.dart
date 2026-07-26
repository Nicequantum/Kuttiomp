import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/features/auth/auth_state.dart';

/// Auth-aware redirect – guest sessions permitted for offline tribal use (§3).
class AuthRedirectGuard {
  const AuthRedirectGuard({required this.authSnapshot});

  final KuttiompAuthSnapshot authSnapshot;

  static const Set<String> publicPaths = {'/first-launch'};

  String? redirect(BuildContext context, GoRouterState state) {
    final path = state.uri.path;
    if (publicPaths.contains(path)) return null;

    // Guest and authenticated users may access shell routes.
    // Future: restrict sacred routes when !authSnapshot.isAuthenticated.
    if (!authSnapshot.isAuthenticated && !authSnapshot.isGuest) {
      return '/first-launch';
    }

    return null;
  }
}