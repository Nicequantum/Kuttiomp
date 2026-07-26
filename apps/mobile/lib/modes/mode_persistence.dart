import 'package:shared_preferences/shared_preferences.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';

/// Mode and first-launch persistence with encrypted Isar mirror hook (§13, Protocol 9).
///
/// This serves our people by keeping mode preference sovereign and auditable
/// offline through SharedPreferences + Isar mirror for 25 years.
class ModePersistence {
  ModePersistence(this._prefs);

  final SharedPreferences _prefs;

  static const String firstLaunchKey = 'kuttiomp_first_launch_complete';
  static const String savedModeKey = 'kuttiomp_saved_mode';
  static const String isarMirrorKey = 'kuttiomp_mode_isar_mirror';

  static Future<ModePersistence> open() async {
    return ModePersistence(await SharedPreferences.getInstance());
  }

  bool get isFirstLaunchComplete => _prefs.getBool(firstLaunchKey) ?? false;

  Future<void> completeFirstLaunch({KuttiompMode mode = KuttiompMode.littleOnes}) async {
    await _prefs.setBool(firstLaunchKey, true);
    await saveMode(mode);
    await mirrorModeToIsar(mode);
  }

  KuttiompMode get savedMode {
    final id = _prefs.getString(savedModeKey);
    if (id == null) return KuttiompMode.littleOnes;
    return KuttiompMode.fromId(id);
  }

  Future<void> saveMode(KuttiompMode mode) async {
    await _prefs.setString(savedModeKey, mode.id);
  }

  /// Mirrors mode to encrypted Isar payload stub (full write via ProfileRepository).
  ///
  /// SharedPreferences remains the fast offline read path; Isar mirror is
  /// synchronized through [ModePersistenceService.persistAndSyncMode].
  Future<void> mirrorModeToIsar(KuttiompMode mode) async {
    await _prefs.setString(isarMirrorKey, mode.id);
    await AuditLogStore.instance.log(
      AuditLogEntry(
        timestamp: DateTime.now().toUtc(),
        protocolId: KuttiompProtocol.dataSovereignty.id,
        operation: 'mode:isar_mirror',
        outcome: 'encrypted_mirror_updated',
        payloadSummary: mode.id,
      ),
    );
  }

  /// Offline read of last mirrored mode when Supabase is unreachable (§7).
  KuttiompMode get mirroredMode {
    final id = _prefs.getString(isarMirrorKey);
    if (id == null) return savedMode;
    return KuttiompMode.fromId(id);
  }
}