import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';

/// Guest user id for offline / anonymous tribal sessions (§3).
const String kGuestUserId = 'guest-kuttiomp';

/// Immutable auth snapshot for Riverpod consumers (§3, §13).
///
/// This serves our people by keeping session claims (mode, clan, role) clear
/// for protocol enforcement across device lifetimes through 2050.
class KuttiompAuthSnapshot {
  const KuttiompAuthSnapshot({
    required this.userId,
    required this.isAuthenticated,
    required this.mode,
    required this.clan,
    required this.role,
    required this.tier,
  });

  final String userId;
  final bool isAuthenticated;
  final String mode;
  final String clan;
  final String role;
  final int tier;

  KuttiompMode get kuttiompMode => KuttiompMode.fromId(mode);

  bool get isGuest => userId == kGuestUserId;

  factory KuttiompAuthSnapshot.guest() => const KuttiompAuthSnapshot(
        userId: kGuestUserId,
        isAuthenticated: false,
        mode: 'little_ones',
        clan: 'kuttiomp_clan',
        role: 'learner',
        tier: GenerationalTierBitmask.littleOnes,
      );

  factory KuttiompAuthSnapshot.fromClaims({
    required String userId,
    required bool isAuthenticated,
    required Map<String, dynamic> claims,
  }) {
    final modeId = claims['mode'] as String? ?? KuttiompMode.littleOnes.id;
    final mode = KuttiompMode.fromId(modeId);
    return KuttiompAuthSnapshot(
      userId: userId,
      isAuthenticated: isAuthenticated,
      mode: mode.id,
      clan: claims['clan'] as String? ?? 'kuttiomp_clan',
      role: claims['role'] as String? ?? 'learner',
      tier: claims['tier'] as int? ?? mode.tierBitmask,
    );
  }
}