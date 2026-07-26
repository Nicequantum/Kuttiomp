import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/shared/design_system/kuttiomp_design_system.dart';

/// Protocol 12 – validates package support horizon and protocol coverage.
class IntegrityValidator {
  IntegrityValidator({
    this.minimumSupportHorizonYears = 5,
    this.minimumProtocolCoverage = 0.98,
  });

  final int minimumSupportHorizonYears;
  final double minimumProtocolCoverage;

  static const Map<String, int> _pinnedPackageSupportYears = {
    'flutter_riverpod': 8,
    'riverpod_annotation': 8,
    'supabase_flutter': 6,
    'isar': 8,
    'isar_flutter_libs': 8,
    'go_router': 6,
  };

  IntegrityValidationResult validate({
    required int registeredGuardCount,
    required int protocolTestCount,
  }) {
    final failures = <String>[];

    if (registeredGuardCount < KuttiompProtocol.all.length) {
      failures.add(
        'Protocol guard count $registeredGuardCount < required ${KuttiompProtocol.all.length}',
      );
    }

    final coverage = protocolTestCount / KuttiompProtocol.all.length;
    if (coverage < minimumProtocolCoverage) {
      failures.add(
        'Protocol test coverage ${(coverage * 100).toStringAsFixed(1)}% < '
        '${(minimumProtocolCoverage * 100).toStringAsFixed(0)}%',
      );
    }

    for (final entry in _pinnedPackageSupportYears.entries) {
      if (entry.value < minimumSupportHorizonYears) {
        failures.add(
          'Package ${entry.key} support horizon ${entry.value}y < $minimumSupportHorizonYears y',
        );
      }
    }

    if (KuttiompProtocolService.instance.isInitialized) {
      try {
        KuttiompDesignSystem.assertDignity();
      } catch (e) {
        failures.add('DignityLint runtime check failed: $e');
      }
    }

    return IntegrityValidationResult(
      passed: failures.isEmpty,
      failures: failures,
      protocolCoverage: coverage,
    );
  }
}

class IntegrityValidationResult {
  IntegrityValidationResult({
    required this.passed,
    required this.failures,
    required this.protocolCoverage,
  });

  final bool passed;
  final List<String> failures;
  final double protocolCoverage;
}