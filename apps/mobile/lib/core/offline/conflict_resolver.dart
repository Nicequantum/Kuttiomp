import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/offline/isar_sync_metadata.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';

/// Outcome of a local/remote sync conflict (backend source of truth, §7).
enum ConflictResolution {
  acceptRemote,
  keepLocalPending,
  blockedSacredConsent,
  blockedClanReauth,
}

/// Callback invoked when sacred or clan-gated records require elder consent.
typedef SacredConsentCallback = Future<bool> Function({
  required String recordId,
  required String contentType,
  required bool sacredFlag,
});

/// Resolves Isar ↔ Supabase conflicts with sacred/clan re-auth gates (Protocols 4,5).
class ConflictResolver {
  ConflictResolver({
    ProtocolGateway? gateway,
    KuttiompProtocolService? protocolService,
  })  : _gateway = gateway ?? ProtocolGateway(),
        _protocolService = protocolService ?? KuttiompProtocolService.instance;

  final ProtocolGateway _gateway;
  final KuttiompProtocolService _protocolService;

  /// Compares local and remote metadata; backend wins unless consent/clan blocks.
  Future<ConflictResolution> resolve({
    required IsarSyncMetadata local,
    required IsarSyncMetadata remote,
    required bool clanReauthenticated,
    SacredConsentCallback? onSacredConsentRequired,
  }) async {
    if (!_gateway.isClanPermitted(remote.clanScope)) {
      if (kDebugMode) {
        debugPrint('ConflictResolver: clan re-auth required for ${remote.compositeKey}');
      }
      return ConflictResolution.blockedClanReauth;
    }

    if (!clanReauthenticated && !_clanScopesMatch(local.clanScope, remote.clanScope)) {
      return ConflictResolution.blockedClanReauth;
    }

    if (remote.sacredFlag || remote.requiresSacredConsent) {
      if (onSacredConsentRequired == null) {
        return ConflictResolution.blockedSacredConsent;
      }

      final granted = await onSacredConsentRequired(
        recordId: remote.recordId,
        contentType: remote.contentType,
        sacredFlag: remote.sacredFlag,
      );
      if (!granted) {
        return ConflictResolution.blockedSacredConsent;
      }

      _protocolService.assertSacredProtected(
        context: {
          'sacred_flag': true,
          'sacred_consent_granted': true,
        },
      );
    }

    if (local.localChecksum == remote.localChecksum &&
        local.syncStatus == SyncStatus.synced) {
      return ConflictResolution.acceptRemote;
    }

    // Backend source of truth per §7.
    return ConflictResolution.acceptRemote;
  }

  /// Applies resolution to produce the metadata row that should be mirrored.
  IsarSyncMetadata applyResolution({
    required IsarSyncMetadata local,
    required IsarSyncMetadata remote,
    required ConflictResolution resolution,
  }) {
    switch (resolution) {
      case ConflictResolution.acceptRemote:
        return remote.copyWith(
          syncStatus: SyncStatus.synced,
          lastSyncedAt: DateTime.now().toUtc(),
          requiresSacredConsent: false,
        );
      case ConflictResolution.keepLocalPending:
        return local.copyWith(syncStatus: SyncStatus.conflict);
      case ConflictResolution.blockedSacredConsent:
        return local.copyWith(
          syncStatus: SyncStatus.blocked,
          requiresSacredConsent: true,
        );
      case ConflictResolution.blockedClanReauth:
        return local.copyWith(syncStatus: SyncStatus.blocked);
    }
  }

  bool _clanScopesMatch(List<String> a, List<String> b) {
    if (a.isEmpty || b.isEmpty) return true;
    return a.toSet().intersection(b.toSet()).isNotEmpty;
  }
}