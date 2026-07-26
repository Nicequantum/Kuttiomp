import 'package:kuttiomp_mobile/rollout/domain/pilot_observation_model.dart';

/// In-memory Isar-equivalent mirror for pilot observations (§7, vRollout-1.0).
class PilotLogStore {
  PilotLogStore._();
  static final PilotLogStore instance = PilotLogStore._();

  final List<PilotObservation> _logs = [];

  List<PilotObservation> all() => List.unmodifiable(_logs);

  void put(PilotObservation observation) {
    _logs.removeWhere((o) => o.id == observation.id);
    _logs.add(observation);
  }

  void clear() => _logs.clear();

  int get count => _logs.length;
}

/// Persists pilot logs to local mirror for offline-first pilot cohort (Protocol 9).
class PilotLogMirrorRepository {
  Future<void> put(PilotObservation observation) async {
    PilotLogStore.instance.put(observation);
  }

  Future<List<PilotObservation>> listAll() async {
    return PilotLogStore.instance.all();
  }
}