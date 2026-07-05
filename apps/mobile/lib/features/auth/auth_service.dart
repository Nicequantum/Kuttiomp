import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_client.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/features/auth/auth_state.dart';

/// Full Supabase Auth with custom JWT claims for mode/clan/role (§3, §13).
class KuttiompAuthService {
  KuttiompAuthService({
    KuttiompProtocolService? protocolService,
    SupabaseClient? client,
    AuditedSupabaseClient? auditedClient,
  })  : _protocolService = protocolService ?? KuttiompProtocolService.instance,
        _client = client,
        _auditedClient = auditedClient;

  final KuttiompProtocolService _protocolService;
  SupabaseClient? _client;
  final AuditedSupabaseClient? _auditedClient;

  static const String guestUserId = 'guest-kuttiomp';

  bool get hasSession => _client?.auth.currentSession != null;

  String get userId =>
      _client?.auth.currentUser?.id ?? guestUserId;

  Stream<AuthState> get authStateChanges =>
      _client?.auth.onAuthStateChange ?? const Stream.empty();

  KuttiompAuthSnapshot currentSnapshot() {
    if (!hasSession) return KuttiompAuthSnapshot.guest();
    return KuttiompAuthSnapshot.fromClaims(
      userId: userId,
      isAuthenticated: true,
      claims: extractClaimsFromSession(),
    );
  }

  /// Bootstraps auth layer and synchronizes protocol claims from session metadata.
  Future<KuttiompAuthSnapshot> bootstrap({SupabaseClient? client}) async {
    _client = client ?? _client;
    final claims = extractClaimsFromSession();
    _protocolService.updateClaims(claims);
    if (kDebugMode) {
      debugPrint(
        'Bootstrap: Supabase Auth → claims synced '
        '(mode=${claims['mode']}, clan=${claims['clan']}, role=${claims['role']})',
      );
    }
    return currentSnapshot();
  }

  /// Ensures a session exists – anonymous tribal guest when offline/dev (§3).
  Future<KuttiompAuthSnapshot> ensureSession() async {
    if (_client == null) return KuttiompAuthSnapshot.guest();
    if (hasSession) return bootstrap();

    try {
      await _client!.auth.signInAnonymously();
      if (kDebugMode) {
        debugPrint('Auth: anonymous session established');
      }
    } catch (_) {
      if (kDebugMode) {
        debugPrint('Auth: guest fallback (no live session)');
      }
      return KuttiompAuthSnapshot.guest();
    }
    return bootstrap();
  }

  /// Reads mode/clan/role from JWT app_metadata or user_metadata.
  Map<String, dynamic> extractClaimsFromSession() {
    final user = _client?.auth.currentUser;
    if (user == null) {
      return _defaultClaims();
    }

    final metadata = <String, dynamic>{
      ...?user.appMetadata,
      ...?user.userMetadata,
    };

    final modeId = metadata['mode'] as String? ?? KuttiompMode.littleOnes.id;
    final mode = KuttiompMode.fromId(modeId);

    return {
      'mode': mode.id,
      'clan': metadata['clan'] as String? ?? 'kuttiomp_clan',
      'role': metadata['role'] as String? ?? 'learner',
      'tier': metadata['tier'] as int? ?? mode.tierBitmask,
    };
  }

  /// Synchronizes mode claim to Supabase user metadata after local selection (§13).
  Future<void> syncModeClaim(KuttiompMode mode) async {
    _protocolService.enforceNewMode(mode);
    _protocolService.updateClaims({
      'mode': mode.id,
      'tier': mode.tierBitmask,
    });

    await updateModeViaRpc(mode);

    final user = _client?.auth.currentUser;
    if (user == null) return;

    try {
      await _client?.auth.updateUser(
        UserAttributes(
          data: {
            'mode': mode.id,
            'tier': mode.tierBitmask,
          },
        ),
      );
    } catch (_) {
      // Offline or dev fallback – local claims remain authoritative.
    }
  }

  /// Persists mode via audited RPC (never direct table access).
  Future<void> updateModeViaRpc(KuttiompMode mode) async {
    final audited = _auditedClient ?? AuditedSupabaseClient.instance;
    if (audited == null || !audited.isInitialized) return;

    try {
      await audited.rpc<void>(
        KuttiompRpc.updateUserMode,
        params: {
          'mode': mode.id,
          'tier': mode.tierBitmask,
          'elderApproved': true,
        },
      );
    } catch (_) {
      // Offline – local mirror remains authoritative until sync.
    }
  }

  Future<void> signOut() async {
    try {
      await _client?.auth.signOut();
    } catch (_) {
      // Ignore – guest fallback resumes.
    }
    _protocolService.updateClaims(_defaultClaims());
  }

  Map<String, dynamic> _defaultClaims() => {
        'mode': KuttiompMode.littleOnes.id,
        'clan': 'kuttiomp_clan',
        'role': 'learner',
        'tier': GenerationalTierBitmask.littleOnes,
      };
}