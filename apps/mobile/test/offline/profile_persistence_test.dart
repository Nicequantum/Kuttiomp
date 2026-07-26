import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/features/auth/auth_service.dart';
import 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';

void main() {
  late KuttiompProtocolService protocolService;
  late KuttiompAuthService authService;
  late UserProfileService profileService;
  late UserProfilePersistence persistence;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    AuditLogStore.instance.clear();
    protocolService = KuttiompProtocolService.instance;
    protocolService.init(claims: {
      'mode': KuttiompMode.coreAdult.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': GenerationalTierBitmask.coreAdult,
    });
    authService = KuttiompAuthService(protocolService: protocolService);
    profileService = UserProfileService(
      authService: authService,
      protocolService: protocolService,
    );
    persistence = UserProfilePersistence(
      profileService: profileService,
      protocolService: protocolService,
    );
  });

  group('UserProfilePersistence', () {
    test('syncWithSupabase uses audited path and marks profile persisted', () async {
      final mastery = await persistence.syncWithSupabase();

      expect(persistence.profilePersisted, isTrue);
      expect(persistence.lastSyncLog, contains('Profile sync log'));
      expect(mastery.canonicalStage, isNotEmpty);
      expect(mastery.modeProgress.keys, contains(KuttiompMode.littleOnes.id));
    });

    test('encryptedMirror produces deterministic hash', () {
      final profile = {
        'user_id': 'guest-kuttiomp',
        'mode': 'little_ones',
        'clan': 'kuttiomp_clan',
        'role': 'learner',
      };
      final a = UserProfileService.encryptedMirror(profile);
      final b = UserProfileService.encryptedMirror(profile);
      expect(a, equals(b));
      expect(a, isNotEmpty);
    });

    test('elder override simulation logs audit entry', () async {
      await persistence.syncWithSupabase();
      await persistence.simulateElderOverride(
        mode: KuttiompMode.elder.id,
        elderId: 'elder-test-001',
      );

      expect(persistence.lastSyncLog, contains('Elder override'));
      expect(
        AuditLogStore.instance.entries.any((e) => e.operation == 'elder_override'),
        isTrue,
      );
    });

    test('updateClaims synchronizes JWT without re-init', () {
      protocolService.updateClaims({'mode': KuttiompMode.elder.id});
      expect(protocolService.currentMode, KuttiompMode.elder);
      expect(protocolService.isInitialized, isTrue);
    });
  });
}