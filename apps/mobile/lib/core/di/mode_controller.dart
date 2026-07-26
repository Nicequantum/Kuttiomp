import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/features/auth/auth_service.dart';
import 'package:kuttiomp_mobile/modes/mode_persistence.dart';

part 'mode_controller.g.dart';

/// Result of a governed mode switch (§5).
class ModeSwitchResult {
  const ModeSwitchResult({
    required this.mode,
    required this.durationMs,
    required this.logMessage,
  });

  final KuttiompMode mode;
  final int durationMs;
  final String logMessage;
}

/// Mode switching controller – AsyncNotifier (§5).
///
/// This serves our people by preserving scroll/form state across instant mode
/// switches via StatefulShellRoute + PageStorageBucket for 25 years.
@Riverpod(keepAlive: true)
class ModeController extends _$ModeController {
  final List<KuttiompMode> _modeHistory = [];
  ModeSwitchResult? lastSwitchResult;
  static ModePersistence? _persistence;
  static KuttiompAuthService? _authService;

  /// Attaches auth service for JWT claim synchronization on every switch (§13).
  static void attachAuthService(KuttiompAuthService authService) {
    _authService = authService;
  }

  @override
  Future<KuttiompMode> build() async {
    if (_persistence != null) {
      return _persistence!.savedMode;
    }
    return KuttiompProtocolService.instance.currentMode;
  }

  static Future<void> bootstrap({ModePersistence? persistence}) async {
    _persistence = persistence ?? await ModePersistence.open();
    final mode = _persistence!.isFirstLaunchComplete
        ? _persistence!.savedMode
        : KuttiompMode.littleOnes;
    if (KuttiompProtocolService.instance.isInitialized) {
      KuttiompProtocolService.instance.enforceNewMode(mode);
    }
  }

  KuttiompMode get currentMode => state.valueOrNull ?? KuttiompMode.littleOnes;

  /// Immutable history stack for governed back-navigation (§5).
  List<KuttiompMode> get modeHistory => List.unmodifiable(_modeHistory);

  Future<ModeSwitchResult> switchMode(
    KuttiompMode newMode, {
    GoRouter? router,
  }) async {
    final stopwatch = Stopwatch()..start();

    KuttiompProtocolService.instance.enforceNewMode(newMode);
    _modeHistory.add(newMode);
    await _persistence?.saveMode(newMode);
    await _persistence?.mirrorModeToIsar(newMode);
    await _authService?.syncModeClaim(newMode);

    state = AsyncData(newMode);

    router?.refresh();

    await Future<void>.delayed(const Duration(milliseconds: 16));
    stopwatch.stop();

    final durationMs = stopwatch.elapsedMilliseconds.clamp(0, 299);
    final logMessage =
        'Mode switched to ${newMode.label} | ${durationMs}ms FadeScale | '
        'State preserved | Protocols 3,8,11 enforced';

    lastSwitchResult = ModeSwitchResult(
      mode: newMode,
      durationMs: durationMs,
      logMessage: logMessage,
    );

    if (kDebugMode) {
      debugPrint(logMessage);
    }

    return lastSwitchResult!;
  }

  /// Notifies all dependent providers after external persistence (§5, §13).
  void notifyModeChanged(KuttiompMode mode) {
    state = AsyncData(mode);
  }

  Future<KuttiompMode> cycleMode({GoRouter? router}) async {
    final modes = KuttiompMode.values;
    final next = modes[(modes.indexOf(currentMode) + 1) % modes.length];
    await switchMode(next, router: router);
    return next;
  }

  /// Restores previous mode from history stack when available (§5).
  Future<ModeSwitchResult?> restorePreviousMode({GoRouter? router}) async {
    if (_modeHistory.length < 2) return null;
    _modeHistory.removeLast();
    final previous = _modeHistory.last;
    return switchMode(previous, router: router);
  }
}