import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_guard.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_violation_exception.dart';

/// Protocol 10 – Non-Gamification & Dignity.
class DignityGuard extends ProtocolGuard {
  DignityGuard(super.protocolService);

  /// Absolute Protocol 10 catalogue — mirrored in scripts/dignity_lint.dart.
  static const Set<String> prohibitedWidgetTypes = {
    'NoPlayWidget',
    'GamificationBadge',
    'PointsCounter',
    'StreakTracker',
    'Leaderboard',
    'PlayfulMascot',
    'ConfettiWidget',
    'AchievementBadge',
    'CompetitiveRank',
  };

  static const Set<String> prohibitedAssetPatterns = {
    'playful_mascot',
    'achievement_badge',
    'confetti',
    'emoji',
    'cartoon',
    'gamification',
    'streak_flame',
  };

  @override
  KuttiompProtocol get protocol => KuttiompProtocol.nonGamificationDignity;

  @override
  void assertCompliant({required dynamic context}) {
    if (context is! Map<String, dynamic>) return;

    final widgetType = context['widgetType']?.toString();
    if (widgetType != null && prohibitedWidgetTypes.contains(widgetType)) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'Gamification elements are not permitted in Kuttiomp.',
      );
    }

    final usesPlayfulAssets = context['usesPlayfulAssets'] == true;
    if (usesPlayfulAssets) {
      throw ProtocolViolationException(
        protocol.id,
        respectfulMessage: 'Playful assets violate the dignity design standard.',
      );
    }
  }
}