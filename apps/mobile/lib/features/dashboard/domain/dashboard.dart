import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/features/profile/user_profile_service.dart';

// Tribal Maintainer Guide (Protocol 12): governed dashboard domain model (§4).
// Riverpod providers: `core/di/dashboard_providers.dart` | UI: `presentation/dashboard_page.dart`

/// Canonical dashboard type alias (§4).
typedef Dashboard = DashboardSnapshot;

/// Governed feature petal identifiers for navigation (§5, §6).
enum DashboardFeaturePetal {
  learn('learn', 'Learn', '/dashboard'),
  phrases('phrases', 'Conversation Starter', '/dashboard'),
  lessons('lessons', 'Lessons', '/dashboard'),
  discover('discover', 'Discover Language', '/search'),
  contribute('contribute', 'Contribute', '/contribute'),
  profile('profile', 'Profile', '/profile');

  const DashboardFeaturePetal(this.id, this.label, this.route);

  final String id;
  final String label;
  final String route;

  bool get isElderGated => this == DashboardFeaturePetal.contribute;
}

/// Configuration for a mode-learning petal (four Kuttiomp modes).
@immutable
class ModePetalConfig {
  const ModePetalConfig({
    required this.mode,
    required this.progressPercent,
    required this.longPressDescription,
  });

  final KuttiompMode mode;
  final int progressPercent;
  final String longPressDescription;
}

/// Unified dashboard snapshot – mastery, counts, mode history (§6).
@immutable
class DashboardSnapshot {
  const DashboardSnapshot({
    required this.currentMode,
    required this.modeHistory,
    required this.masteryStage,
    required this.mastery,
    required this.lexemeCount,
    required this.elderContributionCount,
    required this.bootstrapStatus,
    required this.modePetals,
  });

  final KuttiompMode currentMode;
  final List<KuttiompMode> modeHistory;
  final MasteryStage masteryStage;
  final UserMasterySummary mastery;
  final int lexemeCount;
  final int elderContributionCount;
  final String bootstrapStatus;
  final List<ModePetalConfig> modePetals;

  int get stageIndex => MasteryStage.values.indexOf(masteryStage);

  double get stageProgress => (stageIndex + 1) / MasteryStage.values.length;
}