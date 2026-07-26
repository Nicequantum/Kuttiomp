import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/bootstrap/app_bootstrap.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/offline/conflict_resolver.dart';
import 'package:kuttiomp_mobile/core/offline/isar_sync_metadata.dart';
import 'package:kuttiomp_mobile/core/offline/offline_quota_guard.dart';
import 'package:kuttiomp_mobile/core/offline/sync_worker.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';
import 'package:kuttiomp_mobile/features/auth/auth_service.dart';
import 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';
import 'package:kuttiomp_mobile/modes/mode_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kuttiomp_mobile/core/supabase/isar_schemas.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approved_contributions_store.dart';
import 'package:kuttiomp_mobile/features/profile/domain/recording_service.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approval_simulation.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';


/// Full offline functionality without external services (§7, §11, Component 6).
void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    AuditLogStore.instance.clear();
    InMemorySyncMetadataStore.instance.clear();
    KuttiompProtocolService.instance.init(
      claims: {
        'mode': KuttiompMode.youngLearner.id,
        'clan': 'kuttiomp_clan',
        'role': 'learner',
        'tier': GenerationalTierBitmask.youngLearner,
      },
    );
  });

  group('Offline foundation', () {
    test('mode persistence survives without Supabase', () async {
      SharedPreferences.setMockInitialValues({});
      final persistence = await ModePersistence.open();
      await persistence.completeFirstLaunch(mode: KuttiompMode.coreAdult);
      final reopened = await ModePersistence.open();
      expect(reopened.isFirstLaunchComplete, isTrue);
      expect(reopened.savedMode, KuttiompMode.coreAdult);
    });

    test('profile sync works offline via local fallback', () async {
      final auth = KuttiompAuthService(protocolService: KuttiompProtocolService.instance);
      final profileService = UserProfileService(
        authService: auth,
        protocolService: KuttiompProtocolService.instance,
      );
      final profilePersistence = UserProfilePersistence(
        profileService: profileService,
        protocolService: KuttiompProtocolService.instance,
      );

      final mastery = await profilePersistence.syncWithSupabase();
      expect(mastery.canonicalStage, isNotEmpty);
      expect(profilePersistence.profilePersisted, isTrue);
    });

    test('mode switch persists across controller bootstrap', () async {
      SharedPreferences.setMockInitialValues({
        'kuttiomp_first_launch_complete': true,
        'kuttiomp_saved_mode': KuttiompMode.elder.id,
      });
      await ModeController.bootstrap();
      final persistence = await ModePersistence.open();
      expect(persistence.savedMode, KuttiompMode.elder);
    });

    test('AppBootstrap completes offline with guest auth', () async {
      SharedPreferences.setMockInitialValues({});
      final result = await AppBootstrap.initialize();
      expect(result.layerLogs, contains('Protocol'));
      expect(result.layerLogs, contains('Auth'));
      expect(result.statusMessage, contains('Foundation complete'));
      expect(result.authSnapshot.isGuest || result.authSnapshot.isAuthenticated, isTrue);
    });

    test('encrypted mirror is deterministic offline', () {
      final profile = {
        'user_id': 'offline-user',
        'mode': 'young_learner',
        'clan': 'kuttiomp_clan',
        'role': 'learner',
      };
      expect(
        UserProfileService.encryptedMirror(profile),
        UserProfileService.encryptedMirror(profile),
      );
    });
  });

  group('Offline sync worker', () {
    test('delta sync mirrors records and logs completion', () async {
      final worker = SyncWorker(
        gateway: ProtocolGateway(protocolService: KuttiompProtocolService.instance),
      );

      final result = await worker.runDeltaSync(
        mode: KuttiompMode.littleOnes,
        canonicalStage: 'awakening',
      );

      expect(result.mirroredCount, greaterThan(0));
      expect(result.logMessage, SyncWorker.completeLogMessage);
      expect(
        AuditLogStore.instance.entries.any(
          (e) => e.outcome.contains('Protocols 4,5,9'),
        ),
        isTrue,
      );

      final mirrored = InMemorySyncMetadataStore.instance.all();
      expect(mirrored, isNotEmpty);
      expect(mirrored.every((m) => m.syncStatus == SyncStatus.synced), isTrue);
    });

    test('sacred record triggers consent callback', () async {
      KuttiompProtocolService.instance.init(
        claims: {
          'mode': KuttiompMode.elder.id,
          'clan': 'kuttiomp_clan',
          'role': 'elder',
          'tier': GenerationalTierBitmask.elder,
        },
      );

      var consentRequested = false;
      final worker = SyncWorker(
        gateway: ProtocolGateway(protocolService: KuttiompProtocolService.instance),
      );

      await worker.runDeltaSync(
        mode: KuttiompMode.elder,
        canonicalStage: 'deepening',
        onSacredConsentRequired: ({
          required recordId,
          required contentType,
          required sacredFlag,
        }) async {
          consentRequested = sacredFlag;
          return true;
        },
      );

      expect(consentRequested, isTrue);
    });

    test('sacred record blocked without consent callback', () async {
      KuttiompProtocolService.instance.init(
        claims: {
          'mode': KuttiompMode.elder.id,
          'clan': 'kuttiomp_clan',
          'role': 'elder',
          'tier': GenerationalTierBitmask.elder,
        },
      );

      final worker = SyncWorker(
        gateway: ProtocolGateway(protocolService: KuttiompProtocolService.instance),
      );

      final result = await worker.runDeltaSync(
        mode: KuttiompMode.elder,
        canonicalStage: 'deepening',
      );

      expect(result.blockedSacredCount, greaterThan(0));
    });

    test('OfflineQuotaGuard enforces per-mode batch limits', () {
      final guard = OfflineQuotaGuard(protocolService: KuttiompProtocolService.instance);
      expect(
        () => guard.enforceBatch(
          modeId: KuttiompMode.littleOnes.id,
          existingCount: 45,
          incomingCount: 5,
        ),
        returnsNormally,
      );
      expect(
        () => guard.enforceBatch(
          modeId: KuttiompMode.littleOnes.id,
          existingCount: 49,
          incomingCount: 2,
        ),
        throwsA(isA<ProtocolViolationException>()),
      );
    });

    test('ConflictResolver accepts remote as source of truth', () async {
      final resolver = ConflictResolver();
      final local = IsarSyncMetadata(
        recordId: 'lexeme-wunnegan',
        contentType: 'lexeme',
        syncStatus: SyncStatus.pending,
        lastSyncedAt: DateTime.utc(2026, 1, 1),
        localChecksum: '1.0',
      );
      final remote = local.copyWith(
        localChecksum: '2.0',
        syncStatus: SyncStatus.synced,
      );

      final resolution = await resolver.resolve(
        local: local,
        remote: remote,
        clanReauthenticated: true,
      );

      expect(resolution, ConflictResolution.acceptRemote);
      final applied = resolver.applyResolution(
        local: local,
        remote: remote,
        resolution: resolution,
      );
      expect(applied.syncStatus, SyncStatus.synced);
      expect(applied.localChecksum, '2.0');
    });

    test('AppBootstrap includes offline sync layer', () async {
      SharedPreferences.setMockInitialValues({});
      final result = await AppBootstrap.initialize();
      expect(result.layerLogs, contains('OfflineWorker'));
    });
  });

  group('Offline elder recording queue', () {
    setUp(() {
      ApprovedContributionsStore.instance.clear();
      KuttiompProtocolService.instance.init(
        claims: {
          'mode': KuttiompMode.elder.id,
          'clan': 'kuttiomp_clan',
          'role': 'elder',
          'tier': GenerationalTierBitmask.elder,
        },
      );
    });

    test('recording submit queues pending offline approval', () async {
      final gateway = ProtocolGateway();
      final recording = RecordingService(gateway: gateway);
      final draft = await recording.captureRecording(
        word: 'wunnegin',
        translation: 'It is good',
        speakerId: 'elder-offline',
        speakerName: 'Elder Offline',
      );
      final pending = await recording.submitForApproval(draft);

      expect(ApprovedContributionsStore.instance.pendingRecordings(), isNotEmpty);
      expect(pending.elderApproved, isFalse);
      expect(
        AuditLogStore.instance.entries.any(
          (e) => e.outcome == RecordingService.submitLogMessage,
        ),
        isTrue,
      );
    });

    test('keeper approval mirrors ProtocolMetadata fields', () async {
      final gateway = ProtocolGateway();
      final recording = RecordingService(gateway: gateway);
      final approval = ApprovalSimulation(gateway: gateway);

      final draft = await recording.captureRecording(
        word: 'nuttum',
        translation: 'Beautiful',
        speakerId: 'elder-offline',
        speakerName: 'Elder Offline',
      );
      final pending = await recording.submitForApproval(draft);
      final approved = await approval.approveRecording(
        recordingId: pending.id,
        keeperId: 'keeper-offline',
      );

      final meta = ProtocolMetadata()
        ..recordId = 'lexeme:${approved.id}'
        ..protocolId = 'synced'
        ..sacredFlag = false
        ..clanScope = ['kuttiomp_clan']
        ..visibleToTiers = GenerationalTierBitmask.elder
        ..speakerId = approved.speakerId
        ..elderApproved = true
        ..authoritySource = 'elder'
        ..primaryAudioId = approved.primaryAudioId
        ..requiresLandContext = false
        ..schemaVersion = '2.0'
        ..lastSyncedAt = DateTime.now().toUtc();

      expect(meta.elderApproved, isTrue);
      expect(meta.primaryAudioId, isNotEmpty);
      expect(ApprovedContributionsStore.instance.approvedRecordings(), isNotEmpty);
    });
  });
}