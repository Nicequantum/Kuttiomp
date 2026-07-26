import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Per-mode offline record limits with oral-primacy enforcement (§7, Protocol 7).
class OfflineQuotaGuard {
  OfflineQuotaGuard({KuttiompProtocolService? protocolService})
      : _protocolService = protocolService ?? KuttiompProtocolService.instance;

  final KuttiompProtocolService _protocolService;

  static const Map<String, int> limitsByMode = {
    'little_ones': 50,
    'young_learner': 200,
    'core_adult': 500,
    'elder': 1000,
  };

  int limitForMode(String modeId) =>
      limitsByMode[modeId] ?? limitsByMode[KuttiompMode.littleOnes.id]!;

  bool canAddRecords({
    required String modeId,
    required int currentCount,
    required int incomingCount,
  }) {
    return currentCount + incomingCount <= limitForMode(modeId);
  }

  /// Throws [ProtocolViolationException] when quota exceeded.
  void enforce(String modeId, int recordCount) {
    _protocolService.assertCompliant(
      '7',
      context: {
        'text_only': recordCount > 0,
        'primary_audio_id': recordCount > 0 ? 'quota-check' : null,
      },
    );

    final limit = limitForMode(modeId);
    if (recordCount > limit) {
      throw ProtocolViolationException(
        '7',
        respectfulMessage:
            'Offline storage limit reached for your learning path. '
            'Please sync with elder approval before saving more oral content.',
      );
    }
  }

  /// Enforces quota for a delta batch before mirror write.
  void enforceBatch({
    required String modeId,
    required int existingCount,
    required int incomingCount,
  }) {
    enforce(modeId, existingCount + incomingCount);
  }

  int remainingCapacity(String modeId, int currentCount) {
    return (limitForMode(modeId) - currentCount).clamp(0, limitForMode(modeId));
  }
}