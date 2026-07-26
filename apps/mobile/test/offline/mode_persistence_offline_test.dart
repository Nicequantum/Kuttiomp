import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/modes/mode_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Offline mode persistence stubs (§7, §13, Protocol 9).
///
/// This serves our people by verifying mode survives network loss through
/// SharedPreferences + Isar mirror audit trail for 25 years.
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AuditLogStore.instance.clear();
  });

  group('ModePersistence offline', () {
    test('defaults to Little Ones on first launch', () async {
      final persistence = await ModePersistence.open();
      expect(persistence.isFirstLaunchComplete, isFalse);
      expect(persistence.savedMode, KuttiompMode.littleOnes);
    });

    test('saveMode persists across offline reads', () async {
      final persistence = await ModePersistence.open();
      await persistence.saveMode(KuttiompMode.elder);
      final reopened = await ModePersistence.open();
      expect(reopened.savedMode, KuttiompMode.elder);
    });

    test('mirrorModeToIsar writes encrypted mirror key and audits', () async {
      final persistence = await ModePersistence.open();
      await persistence.mirrorModeToIsar(KuttiompMode.coreAdult);
      expect(persistence.mirroredMode, KuttiompMode.coreAdult);
      expect(AuditLogStore.instance.entries, isNotEmpty);
    });

    test('completeFirstLaunch marks onboarding done with default Little Ones', () async {
      final persistence = await ModePersistence.open();
      await persistence.completeFirstLaunch();
      expect(persistence.isFirstLaunchComplete, isTrue);
      expect(persistence.savedMode, KuttiompMode.littleOnes);
      expect(persistence.mirroredMode, KuttiompMode.littleOnes);
    });
  });
}