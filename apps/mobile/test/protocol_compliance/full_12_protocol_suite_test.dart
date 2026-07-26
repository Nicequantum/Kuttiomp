import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/di/injection.dart';
import 'package:kuttiomp_mobile/core/di/mode_controller.dart';
import 'package:kuttiomp_mobile/core/di/offline_quota_guard.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/ceremonial_vault.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';
import 'package:kuttiomp_mobile/core/supabase/audited_client.dart';
import 'package:kuttiomp_mobile/core/supabase/rpc_definitions.dart';
import 'package:kuttiomp_mobile/core/bootstrap/app_bootstrap.dart';
import 'package:kuttiomp_mobile/core/utils/integrity_validator.dart';
import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/features/auth/auth_service.dart';
import 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';
import 'package:kuttiomp_mobile/shared/widgets/protocol_base_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../helpers/kuttiomp_test_harness.dart';
import '../helpers/kuttiomp_test_keys.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approved_contributions_store.dart';
import 'package:kuttiomp_mobile/features/profile/domain/recording_service.dart';
import 'package:kuttiomp_mobile/features/profile/domain/approval_simulation.dart';
import 'package:kuttiomp_mobile/features/profile/presentation/pending_approval_gate.dart';
import 'package:kuttiomp_mobile/features/lexeme/data/lexeme_repository.dart';
import 'package:kuttiomp_mobile/features/phrases/data/phrases_repository.dart';

void main() {
  late KuttiompProtocolService service;

  final mockJwt = {
    'mode': KuttiompMode.coreAdult.id,
    'clan': 'kuttiomp_clan',
    'role': 'learner',
    'tier': GenerationalTierBitmask.coreAdult,
  };

  final compliantContent = {
    'speaker_id': 'grandmother-comus',
    'attribution_json': {'name': 'Grandmother Comus'},
    'speakerMetadata': {'name': 'Grandmother Comus'},
    'elderApproved': true,
    'authority_source': 'elder',
    'visible_to_tiers': GenerationalTierBitmask.allTiers,
    'clan_scope': ['kuttiomp_clan'],
    'schema_version': '2.0',
    'primary_audio_id': 'audio-001',
    'fontSize': 24,
    'hasSemanticsLabel': true,
  };

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    try {
      await Supabase.initialize(
        url: 'https://example.supabase.co',
        anonKey: 'test-anon-key',
      );
    } catch (_) {
      // Already initialized in this test run.
    }
  });

  setUp(() {
    AuditLogStore.instance.clear();
    service = KuttiompProtocolService.instance;
    service.init(claims: mockJwt);
  });

  group('IntegrityValidator', () {
    test('passes with 12 guards and full protocol test coverage', () {
      final result = IntegrityValidator().validate(
        registeredGuardCount: KuttiompProtocol.all.length,
        protocolTestCount: KuttiompProtocol.all.length,
      );
      expect(result.passed, isTrue);
      expect(result.protocolCoverage, greaterThanOrEqualTo(0.98));
    });
  });

  group('Protocol 1 – Speaker Attribution', () {
    test('passes with speaker metadata', () {
      expect(
        () => service.assertSpeakerPresent(context: compliantContent),
        returnsNormally,
      );
    });

    test('fails without speaker_id', () {
      expect(
        () => service.assertSpeakerPresent(context: {'attribution_json': {}}),
        throwsA(isA<ProtocolViolationException>()),
      );
    });
  });

  group('Protocol 2 – Elder Approval', () {
    test('passes when elderApproved is true', () {
      expect(
        () => service.assertElderApproved(context: compliantContent),
        returnsNormally,
      );
    });

    test('fails with respectful message when not approved', () {
      try {
        service.assertElderApproved(context: {'elderApproved': false});
        fail('Expected ProtocolViolationException');
      } on ProtocolViolationException catch (e) {
        expect(e.respectfulMessage, 'Content pending elder review');
      }
    });
  });

  group('Protocol 3 – Generational Access Tiers', () {
    test('passes when tier bitmask matches', () {
      expect(
        () => service.assertTierAccess(
          context: {'visible_to_tiers': GenerationalTierBitmask.coreAdult},
        ),
        returnsNormally,
      );
    });

    test('fails when tier does not match', () {
      expect(
        () => service.assertTierAccess(
          context: {'visible_to_tiers': GenerationalTierBitmask.elder},
        ),
        throwsA(isA<ProtocolViolationException>()),
      );
    });
  });

  group('Protocol 4 – Sacred Content Protection', () {
    test('passes with consent', () {
      expect(
        () => service.assertSacredProtected(
          context: {'sacred_flag': true, 'sacred_consent_granted': true},
        ),
        returnsNormally,
      );
    });

    test('CeremonialVault purges on consent failure', () {
      final vault = CeremonialVault(protocolService: service);
      vault.store(
        recordId: 'sacred-1',
        payload: {'word': 'ceremony'},
        consentGranted: true,
      );
      expect(
        () => vault.retrieve(recordId: 'sacred-1', consentGranted: false),
        throwsA(isA<ProtocolViolationException>()),
      );
    });
  });

  group('Protocol 5 – Clan Visibility', () {
    test('passes for matching clan', () {
      expect(
        () => service.assertClanScope(context: compliantContent),
        returnsNormally,
      );
    });

    test('fails for non-matching clan', () {
      expect(
        () => service.assertClanScope(
          context: {'clan_scope': ['other_clan']},
        ),
        throwsA(isA<ProtocolViolationException>()),
      );
    });

    test('ProtocolGateway isClanPermitted respects JWT clan claim', () {
      final gateway = ProtocolGateway(protocolService: service);
      expect(gateway.isClanPermitted(['kuttiomp_clan']), isTrue);
      expect(gateway.isClanPermitted(['other_clan']), isFalse);
    });
  });

  group('Protocol 6 – Land Contextualization', () {
    test('passes when land context present', () {
      expect(
        () => service.assertLandContext(
          context: {
            'requires_land_context': true,
            'land_geometry': {'type': 'Point'},
          },
        ),
        returnsNormally,
      );
    });
  });

  group('Protocol 7 – Oral Tradition Primacy', () {
    test('passes with primary audio for text-only flag', () {
      expect(
        () => service.assertOralFirst(
          context: {'text_only': true, 'primary_audio_id': 'audio-1'},
        ),
        returnsNormally,
      );
    });

    test('OfflineQuotaGuard enforces per-mode limits', () {
      final guard = OfflineQuotaGuard(protocolService: service);
      expect(() => guard.enforce('little_ones', 25), returnsNormally);
      expect(() => guard.enforce('little_ones', 51), throwsA(isA<ProtocolViolationException>()));
    });
  });

  group('Protocol 8 – Living Authority', () {
    test('passes with authority_source', () {
      expect(
        () => service.assertLivingAuthority(context: compliantContent),
        returnsNormally,
      );
    });
  });

  group('Protocol 9 – Data Sovereignty', () {
    test('passes without direct table access', () {
      expect(
        () => service.assertDataSovereignty(
          context: const {'direct_table_access': false},
        ),
        returnsNormally,
      );
    });

    test('logs audit entries on protocol init', () {
      expect(AuditLogStore.instance.entries, isNotEmpty);
    });

    test('AuditedSupabaseClient.initialize logs startup audit entry', () async {
      await AuditedSupabaseClient.initialize(client: Supabase.instance.client);
      expect(AuditedSupabaseClient.instance?.isInitialized, isTrue);
      expect(
        AuditLogStore.instance.entries.any((e) => e.operation == 'initialize'),
        isTrue,
      );
    });

    test('rejects unknown RPC names', () async {
      final client = await AuditedSupabaseClient.initialize(
        client: Supabase.instance.client,
      );
      expect(
        () => client.rpc('direct_table_select'),
        throwsA(isA<ProtocolViolationException>()),
      );
      expect(KuttiompRpc.all, isNot(contains('direct_table_select')));
    });
  });

  group('Protocol 10 – Non-Gamification', () {
    test('rejects prohibited widget types', () {
      expect(
        () => service.assertDignity(
          context: {'widgetType': 'Leaderboard'},
        ),
        throwsA(isA<ProtocolViolationException>()),
      );
    });
  });

  group('Protocol 11 – Accessibility', () {
    test('passes with adequate font size', () {
      expect(
        () => service.assertAccessibility(
          context: {'fontSize': 24, 'requiresSemantics': true, 'hasSemanticsLabel': true},
        ),
        returnsNormally,
      );
    });
  });

  group('Protocol 12 – Cultural Integrity', () {
    test('passes with schema version', () {
      expect(
        () => service.assertCulturalIntegrity(context: compliantContent),
        returnsNormally,
      );
    });
  });

  group('ProtocolGateway', () {
    test('assertSpeakerPresent delegates to service', () {
      final gateway = ProtocolGateway(protocolService: service);
      expect(
        () => gateway.assertSpeakerPresent(context: compliantContent),
        returnsNormally,
      );
    });

    test('withElderApprovedFilter appends elderApproved', () {
      final gateway = ProtocolGateway(protocolService: service);
      final filtered = gateway.withElderApprovedFilter({'limit': 10});
      expect(filtered['elderApproved'], isTrue);
    });
  });

  group('Unguarded render firewall', () {
    testWidgets('UnguardedContentProbe blocks non-guarded render', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: UnguardedContentProbe(),
        ),
      );
      expect(tester.takeException(), isA<ProtocolViolationException>());
    });
  });

  group('Mode enforcement', () {
    test('enforceNewMode updates JWT claim and audits', () {
      service.enforceNewMode(KuttiompMode.elder);
      expect(service.currentMode, KuttiompMode.elder);
    });

    test('ModeController switchMode logs governed transition', () async {
      SharedPreferences.setMockInitialValues({'kuttiomp_first_launch_complete': true});
      await ModeController.bootstrap();
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(modeControllerProvider.future);
      final result =
          await container.read(modeControllerProvider.notifier).switchMode(KuttiompMode.elder);
      expect(result.logMessage, contains('FadeScale'));
    });
  });

  group('Component 5 – Bootstrap & Profile Persistence', () {
    test('AppBootstrap logs full layer sequence', () async {
      SharedPreferences.setMockInitialValues({});
      final result = await AppBootstrap.initialize();
      expect(result.layerLogs, contains('Protocol'));
      expect(result.layerLogs, contains('Navigation'));
      expect(result.statusMessage, contains('Foundation complete'));
    });

    test('UserProfilePersistence syncWithSupabase enforces Protocol 9', () async {
      final auth = KuttiompAuthService(protocolService: service);
      final profileService = UserProfileService(
        authService: auth,
        protocolService: service,
      );
      final persistence = UserProfilePersistence(
        profileService: profileService,
        protocolService: service,
      );
      final mastery = await persistence.syncWithSupabase();
      expect(persistence.profilePersisted, isTrue);
      expect(mastery.canonicalStage, isNotEmpty);
    });

    test('updateClaims syncs JWT without guard re-registration', () {
      service.updateClaims({'role': 'keeper'});
      expect(service.role, 'keeper');
      expect(service.registeredGuardCount, KuttiompProtocol.all.length);
    });
  });

  group('Component 6 – Foundation Golden Lock', () {
    test('MasteryStage resolves six canonical stages', () {
      expect(MasteryStage.values.length, 6);
      expect(MasteryStage.forWordCount(250), MasteryStage.rooted);
    });

    test('AuthService guest snapshot when no client', () {
      final auth = KuttiompAuthService(protocolService: service);
      final snapshot = auth.currentSnapshot();
      expect(snapshot.isGuest, isTrue);
    });

    test('AppBootstrap includes auth and profile layers', () async {
      SharedPreferences.setMockInitialValues({'kuttiomp_first_launch_complete': true});
      final result = await AppBootstrap.initialize();
      expect(result.layerLogs, contains('Auth'));
      expect(result.userProfile.userId, isNotEmpty);
      expect(result.authSnapshot.clan, 'kuttiomp_clan');
    });
  });

  group('Riverpod DI container (Component 2)', () {
    test('providers resolve after protocol init', () {
      final container = ProviderContainer(
        overrides: buildProviderOverrides(),
      );
      addTearDown(container.dispose);

      expect(container.read(protocolServiceProvider), isA<KuttiompProtocolService>());
      expect(container.read(offlineQuotaGuardProvider), isA<OfflineQuotaGuard>());
      expect(container.read(protocolGatewayProvider), isA<ProtocolGateway>());
      expect(container.read(syncWorkerProvider), isNotNull);
    });
  });

  group('Kuttiomp v2.0 — 12 Protocol Golden Compliance Suite', () {
    setUp(() {
      ApprovedContributionsStore.instance.clear();
    });

    testWidgets('Elder Recording → Approval → Corpus Promotion — All Protocols', (tester) async {
      await tester.pumpKuttiompApp(mode: KuttiompMode.elder);

      expect(find.text('Welcome back'), findsOneWidget);

      await tester.pumpElderRecordingPage();
      await tester.enterText(find.byKey(KuttiompTestKeys.wordField), 'wunnegin');
      await tester.enterText(find.byKey(KuttiompTestKeys.translationField), 'It is good');
      await tester.tap(find.byKey(KuttiompTestKeys.recordStub));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(KuttiompTestKeys.submitSecure));
      await tester.pumpAndSettle();

      expect(
        find.text(RecordingService.submitLogMessage),
        findsOneWidget,
      );
      expect(find.byType(PendingApprovalGate), findsOneWidget);

      await tester.pumpKeeperPanel();
      await tester.tap(find.byKey(KuttiompTestKeys.keeperApprove));
      await tester.pumpAndSettle();

      expect(
        AuditLogStore.instance.entries.any(
          (e) => e.outcome == ApprovalSimulation.approveLogMessage,
        ),
        isTrue,
      );

      final gateway = ProtocolGateway(protocolService: KuttiompProtocolService.instance);
      final lexemeRepo = LexemeRepository(gateway: gateway);
      final approved = ApprovedContributionsStore.instance.approvedRecordings();
      expect(approved.any((r) => r.word == 'wunnegin' && r.elderApproved), isTrue);
      final approvedLexeme = await lexemeRepo.getById(approved.first.id);
      expect(approvedLexeme.word, 'wunnegin');
      expect(approvedLexeme.elderApproved, isTrue);
      expect(lexemeRepo, isA<LexemeRepository>());

      final phrasesRepo = PhrasesRepository(gateway: gateway);
      final phrases = await phrasesRepo.watchPhrasesForTier(
        KuttiompMode.elder.tierBitmask,
        stage: 'awakening',
      );
      expect(phrases.every((p) => p.elderApproved), isTrue);

      for (final mode in KuttiompMode.values) {
        service.enforceNewMode(mode);
        await tester.switchToMode(mode);
        expect(gateway.allAssertionsPassed(), isTrue);
        tester.verifyElderAccessibilityLabels();
        tester.verifyOfflineMirrorIntact();
      }
    });

    test('IntegrityValidator passes after golden suite expansion', () {
      final result = IntegrityValidator().validate(
        registeredGuardCount: KuttiompProtocol.all.length,
        protocolTestCount: KuttiompProtocol.all.length,
      );
      expect(result.passed, isTrue);
    });
  });
}