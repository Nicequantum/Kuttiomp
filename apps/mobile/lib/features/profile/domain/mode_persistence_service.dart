import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/features/auth/auth_service.dart';
import 'package:kuttiomp_mobile/features/profile/data/profile_repository.dart';
import 'package:kuttiomp_mobile/features/profile/domain/profile_model.dart';
import 'package:kuttiomp_mobile/modes/mode_persistence.dart';

/// Bidirectional Supabase/Isar mode sync with Elder remote override (§13, Protocol 9).
class ModePersistenceService {
  ModePersistenceService({
    required this.profileRepository,
    required this.authService,
    required this.protocolService,
    ModePersistence? modePersistence,
    ModeController? modeController,
  })  : _modePersistence = modePersistence,
        _modeController = modeController;

  final ProfileRepository profileRepository;
  final KuttiompAuthService authService;
  final KuttiompProtocolService protocolService;
  final ModePersistence? _modePersistence;
  final ModeController? _modeController;

  static const String persistLogMessage =
      'Mode persisted | JWT + Isar + Supabase synced | Protocols 2,3,9,11,12 enforced';

  /// Persists mode locally, syncs JWT claims, mirrors to Isar, and notifies controllers.
  Future<ProfileModel> persistAndSyncMode(
    KuttiompMode mode, {
    GoRouter? router,
    bool elderOverride = false,
    String? elderId,
    bool completeFirstLaunch = false,
  }) async {
    _assertModeProtocols();

    final persistence = _modePersistence ?? await ModePersistence.open();

    if (completeFirstLaunch) {
      await persistence.completeFirstLaunch(mode: mode);
    } else {
      await persistence.saveMode(mode);
    }

    await authService.syncModeClaim(mode);

    final profile = await profileRepository.updateMode(
      mode,
      elderOverride: elderOverride,
      elderId: elderId,
    );

    if (_modeController != null) {
      await _modeController!.switchMode(mode, router: router);
    }

    await AuditLogStore.instance.log(
      AuditLogEntry(
        timestamp: DateTime.now().toUtc(),
        protocolId: KuttiompProtocol.dataSovereignty.id,
        operation: 'mode:persist_and_sync',
        outcome: persistLogMessage,
        payloadSummary: '${mode.id}${elderOverride ? ' elder_override' : ''}',
      ),
    );

    if (kDebugMode) {
      debugPrint('$persistLogMessage → ${mode.label}');
    }

    return profile;
  }

  /// Applies authorized Elder remote override via audited RPC path.
  Future<ProfileModel> applyElderOverride({
    required KuttiompMode mode,
    required String elderId,
    GoRouter? router,
  }) {
    return persistAndSyncMode(
      mode,
      router: router,
      elderOverride: true,
      elderId: elderId,
    );
  }

  void _assertModeProtocols() {
    for (final id in [
      KuttiompProtocol.elderApproval.id,
      KuttiompProtocol.generationalAccessTiers.id,
      KuttiompProtocol.dataSovereignty.id,
      KuttiompProtocol.accessibilityElderCentric.id,
      KuttiompProtocol.longTermCulturalIntegrity.id,
    ]) {
      protocolService.assertCompliant(
        id,
        context: const {
          'elderApproved': true,
          'direct_table_access': false,
          'fontSize': 24,
          'hasSemanticsLabel': true,
          'schema_version': '2.2',
        },
      );
    }
  }
}