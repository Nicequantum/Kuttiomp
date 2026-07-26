import 'package:flutter_test/flutter_test.dart';
import 'package:kuttiomp_mobile/features/auth/data/auth_service.dart';
import 'package:kuttiomp_mobile/features/auth/domain/auth_state.dart';

void main() {
  test('guest snapshot uses domain guest id', () {
    final guest = KuttiompAuthSnapshot.guest();
    expect(guest.isGuest, isTrue);
    expect(guest.userId, kGuestUserId);
    expect(KuttiompAuthService.guestUserId, kGuestUserId);
  });

  test('fromClaims maps mode clan role', () {
    final snap = KuttiompAuthSnapshot.fromClaims(
      userId: 'u1',
      isAuthenticated: true,
      claims: {
        'mode': 'elder',
        'clan': 'kuttiomp_clan',
        'role': 'elder',
        'tier': 8,
      },
    );
    expect(snap.mode, 'elder');
    expect(snap.clan, 'kuttiomp_clan');
    expect(snap.isAuthenticated, isTrue);
  });
}