import 'package:kuttiomp_mobile/core/constants/protocols.dart';

/// Four switchable learning modes (Master Architecture §5).
enum KuttiompMode {
  littleOnes(
    id: 'little_ones',
    label: 'Little Ones',
    tierBitmask: GenerationalTierBitmask.littleOnes,
    minimumFontSize: 24.0,
  ),
  youngLearner(
    id: 'young_learner',
    label: 'Young Learner / Student',
    tierBitmask: GenerationalTierBitmask.youngLearner,
    minimumFontSize: 24.0,
  ),
  coreAdult(
    id: 'core_adult',
    label: 'Core Adult / Tribal Member',
    tierBitmask: GenerationalTierBitmask.coreAdult,
    minimumFontSize: 24.0,
  ),
  elder(
    id: 'elder',
    label: 'Elder',
    tierBitmask: GenerationalTierBitmask.elder,
    minimumFontSize: 32.0,
  );

  const KuttiompMode({
    required this.id,
    required this.label,
    required this.tierBitmask,
    required this.minimumFontSize,
  });

  final String id;
  final String label;
  final int tierBitmask;
  final double minimumFontSize;

  static KuttiompMode fromId(String id) {
    return KuttiompMode.values.firstWhere(
      (mode) => mode.id == id,
      orElse: () => KuttiompMode.littleOnes,
    );
  }

  static KuttiompMode defaultMode = KuttiompMode.littleOnes;
}