import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/offline/audit_log_entry.dart';
import 'package:kuttiomp_mobile/core/protocol/guards/accessibility_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/guards/clan_scope_filter.dart';
import 'package:kuttiomp_mobile/core/protocol/guards/cultural_integrity_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/guards/data_sovereignty_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/guards/dignity_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/guards/elder_approval_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/guards/land_context_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/guards/living_authority_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/guards/mode_tier_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/guards/oral_tradition_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/guards/sacred_content_locker.dart';
import 'package:kuttiomp_mobile/core/protocol/guards/speaker_attribution_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Singleton enforcing all 12 Cultural Governance Protocols (§2).
class KuttiompProtocolService {
  KuttiompProtocolService._();

  static final KuttiompProtocolService instance = KuttiompProtocolService._();

  late Map<String, dynamic> jwtClaims;
  bool _initialized = false;

  final Map<KuttiompProtocol, ProtocolGuard> _guards = {};

  bool get isInitialized => _initialized;

  int get registeredGuardCount => _guards.length;

  KuttiompMode get currentMode =>
      KuttiompMode.fromId(jwtClaims['mode'] as String? ?? KuttiompMode.defaultMode.id);

  int get currentTier => currentMode.tierBitmask;

  String? get clanId => jwtClaims['clan'] as String?;

  String? get role => jwtClaims['role'] as String?;

  void init({required Map<String, dynamic> claims}) {
    jwtClaims = Map<String, dynamic>.from(claims);
    _registerGuards();
    _initialized = true;
    _audit('init', KuttiompProtocol.dataSovereignty.id, 'initialized');
  }

  void _registerGuards() {
    _guards.clear();
    final guards = <ProtocolGuard>[
      SpeakerAttributionGuard(this),
      ElderApprovalGuard(this),
      ModeTierGuard(this),
      SacredContentLocker(this),
      ClanScopeFilter(this),
      LandContextGuard(this),
      OralTraditionGuard(this),
      LivingAuthorityGuard(this),
      DataSovereigntyGuard(this),
      DignityGuard(this),
      AccessibilityGuard(this),
      CulturalIntegrityGuard(this),
    ];
    for (final guard in guards) {
      _guards[guard.protocol] = guard;
    }
  }

  ProtocolGuard guardFor(KuttiompProtocol protocol) {
    final guard = _guards[protocol];
    if (guard == null) {
      throw StateError('Guard not registered for protocol ${protocol.id}');
    }
    return guard;
  }

  void assertCompliant(String protocolId, {required dynamic context}) {
    _ensureInitialized();
    final protocol = KuttiompProtocol.fromId(protocolId);
    if (protocol == null) {
      throw ProtocolViolationException(
        protocolId,
        respectfulMessage: 'Unknown cultural governance protocol.',
      );
    }
    guardFor(protocol).assertCompliant(context: context);
    _audit('assertCompliant', protocolId, 'passed');
  }

  void assertSpeakerPresent({required dynamic context}) =>
      assertCompliant(KuttiompProtocol.speakerAttribution.id, context: context);

  void assertElderApproved({required dynamic context}) =>
      assertCompliant(KuttiompProtocol.elderApproval.id, context: context);

  void assertTierAccess({required dynamic context}) =>
      assertCompliant(KuttiompProtocol.generationalAccessTiers.id, context: context);

  void assertSacredProtected({required dynamic context}) =>
      assertCompliant(KuttiompProtocol.sacredContentProtection.id, context: context);

  void assertClanScope({required dynamic context}) =>
      assertCompliant(KuttiompProtocol.clanVisibility.id, context: context);

  void assertLandContext({required dynamic context}) =>
      assertCompliant(KuttiompProtocol.landContextualization.id, context: context);

  void assertOralFirst({required dynamic context}) =>
      assertCompliant(KuttiompProtocol.oralTraditionPrimacy.id, context: context);

  void assertLivingAuthority({required dynamic context}) =>
      assertCompliant(KuttiompProtocol.livingAuthoritySupremacy.id, context: context);

  void assertDataSovereignty({required dynamic context}) =>
      assertCompliant(KuttiompProtocol.dataSovereignty.id, context: context);

  void assertDignity({required dynamic context}) =>
      assertCompliant(KuttiompProtocol.nonGamificationDignity.id, context: context);

  void assertAccessibility({required dynamic context}) =>
      assertCompliant(KuttiompProtocol.accessibilityElderCentric.id, context: context);

  void assertCulturalIntegrity({required dynamic context}) =>
      assertCompliant(KuttiompProtocol.longTermCulturalIntegrity.id, context: context);

  void enforceNewMode(KuttiompMode newMode) {
    _ensureInitialized();
    jwtClaims['mode'] = newMode.id;
    jwtClaims['tier'] = newMode.tierBitmask;
    assertTierAccess(context: {'mode': newMode.id, 'tier': newMode.tierBitmask});
    _audit('enforceNewMode', KuttiompProtocol.generationalAccessTiers.id, newMode.id);
  }

  /// Synchronizes JWT claims from Supabase Auth without re-initializing guards (§13).
  void updateClaims(Map<String, dynamic> claims) {
    _ensureInitialized();
    jwtClaims = Map<String, dynamic>.from({...jwtClaims, ...claims});
    _audit('updateClaims', KuttiompProtocol.dataSovereignty.id, 'synced');
  }

  Future<void> _audit(String operation, String protocolId, String outcome) async {
    await AuditLogStore.instance.log(
      AuditLogEntry(
        timestamp: DateTime.now().toUtc(),
        protocolId: protocolId,
        operation: operation,
        outcome: outcome,
      ),
    );
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'KuttiompProtocolService not initialized. Call init() at app start.',
      );
    }
  }
}