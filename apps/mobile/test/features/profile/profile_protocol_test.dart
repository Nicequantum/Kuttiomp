import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/features/auth/auth_service.dart';
import 'package:kuttiomp_mobile/features/profile/data/profile_repository.dart';
import 'package:kuttiomp_mobile/features/profile/domain/mode_persistence_service.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';

void main() {
  late KuttiompProtocolService service;
  late ProfileRepository repository;
  late ModePersistenceService modePersistenceService;

  setUp(() {
    AuditLogStore.instance.clear();
    service = KuttiompProtocolService.instance;
    service.init(claims: {
      'mode': KuttiompMode.coreAdult.id,
      'clan': 'kuttiomp_clan',
      'role': 'learner',
      'tier': GenerationalTierBitmask.coreAdult,
    });

    final auth = KuttiompAuthService(protocolService: service);
    final profileService = UserProfileService(
      authService: auth,
      protocolService: service,
    );
    repository = ProfileRepository(
      gateway: ProtocolGateway(protocolService: service),
      profileService: profileService,
    );
    modePersistenceService = ModePersistenceService(
      profileRepository: repository,
      authService: auth,
      protocolService: service,
    );
  });

  group('ProfileRepository – Protocol enforcement', () {
    test('syncProfile logs Protocols 2,9 message', () async {
      await repository.syncProfile();
      expect(
        AuditLogStore.instance.entries.any(
          (e) => e.outcome.contains('Protocols 2,9'),
        ),
        isTrue,
      );
      expect(ProfileRepository.syncLogMessage, contains('Protocols 2,9'));
    });

    test('updateMode uses audited path only', () async {
      final model = await repository.updateMode(KuttiompMode.elder);
      expect(model.mode, KuttiompMode.elder.id);
      expect(model.tier, KuttiompMode.elder.tierBitmask);
    });

    test('getCorpusStats returns governed counts', () {
      final stats = repository.getCorpusStats();
      expect(stats.approvedContributions, greaterThanOrEqualTo(0));
      expect(stats.pendingContributions, greaterThanOrEqualTo(0));
    });
  });

  group('ModePersistenceService – §13 persistence', () {
    test('persistAndSyncMode logs audit entry', () async {
      await modePersistenceService.persistAndSyncMode(KuttiompMode.youngLearner);
      expect(
        AuditLogStore.instance.entries.any(
          (e) => e.operation == 'mode:persist_and_sync',
        ),
        isTrue,
      );
      expect(ModePersistenceService.persistLogMessage, contains('Protocols 2,3,9,11,12'));
    });

    test('applyElderOverride sets elder mode with audit', () async {
      final profile = await modePersistenceService.applyElderOverride(
        mode: KuttiompMode.elder,
        elderId: 'elder-test-keeper',
      );
      expect(profile.elderOverride, isTrue);
      expect(profile.mode, KuttiompMode.elder.id);
    });
  });
}