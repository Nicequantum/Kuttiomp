import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/features/auth/auth_service.dart';

/// Immutable auth snapshot for Riverpod consumers (§3, §13).
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

  bool get isGuest => userId == KuttiompAuthService.guestUserId;

  factory KuttiompAuthSnapshot.guest() => const KuttiompAuthSnapshot(
        userId: KuttiompAuthService.guestUserId,
        isAuthenticated: false,
        mode: 'little_ones',
        clan: 'kuttiomp_clan',
        role: 'learner',
        tier: 1,
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