import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttiomp_mobile/features/auth/auth_state.dart';
import 'package:kuttiomp_mobile/features/profile/persistence_provider.dart';

/// Reactive auth snapshot for router refresh and profile UI (Component 6).
final authSnapshotProvider = StateProvider<KuttiompAuthSnapshot>(
  (ref) => KuttiompAuthSnapshot.guest(),
);

/// Ensures auth session at startup and publishes snapshot.
final authBootstrapProvider = FutureProvider<KuttiompAuthSnapshot>((ref) async {
  final auth = ref.watch(kuttiompAuthServiceProvider);
  final snapshot = await auth.ensureSession();
  ref.read(authSnapshotProvider.notifier).state = snapshot;
  return snapshot;
});