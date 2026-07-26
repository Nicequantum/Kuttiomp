// Protocol 10 – DignityLint CI scanner (offline, zero external services).
//
// This serves our people by failing the build when gamification or playful
// patterns appear, protecting cultural dignity through 2050.
//
// Run: dart run scripts/dignity_lint.dart
// Exit code 1 = Protocol 10 violation (CI must fail).

import 'dart:io';

/// Concrete gamification surface names (not the word "gamification" in Protocol 10 docs).
const prohibitedTypeDefinitions = <String>[
  'class NoPlayWidget',
  'class GamificationBadge',
  'class PointsCounter',
  'class StreakTracker',
  'class Leaderboard',
  'class PlayfulMascot',
  'class ConfettiWidget',
  'class AchievementBadge',
  'class CompetitiveRank',
];

const prohibitedAssetTokens = <String>[
  'achievement_badge',
  'confetti_animation',
  'playful_mascot',
  'cartoon_character',
  'emoji_pack',
  'streak_flame',
];

/// Paths that define or document prohibitions are allowlisted.
bool isAllowlisted(String path) {
  final p = path.replaceAll('\\', '/').toLowerCase();
  if (p.contains('dignity')) return true;
  if (p.contains('build_guards')) return true;
  if (p.contains('dignity_lint')) return true;
  if (p.contains('kuttiomp_design_system')) return true;
  if (p.contains('integrity_validator')) return true;
  if (p.contains('freezed_decision')) return true;
  if (p.endsWith('dignity_lint.yaml')) return true;
  if (p.contains('tribal_maintainer_guide') || p.contains('tribal maintainer guide')) {
    return true;
  }
  if (p.contains('protocol_compliance') && p.endsWith('.dart')) return true;
  if (p.contains('dignity_lint_test')) return true;
  // Protocol enum / service names include "nonGamification" by design.
  if (p.endsWith('protocols.dart')) return true;
  if (p.endsWith('protocol_service.dart')) return true;
  return false;
}

void main() {
  final root = Directory.current;
  final libDir = Directory('${root.path}/lib');
  final assetsDir = Directory('${root.path}/assets');
  final violations = <String>[];

  void scanFile(File file) {
    final path = file.path;
    if (isAllowlisted(path)) return;
    final lowerPath = path.replaceAll('\\', '/').toLowerCase();
    for (final token in prohibitedAssetTokens) {
      if (lowerPath.contains(token.toLowerCase())) {
        violations.add('PATH: $path contains prohibited asset token "$token"');
      }
    }
    if (!path.endsWith('.dart') &&
        !path.endsWith('.yaml') &&
        !path.endsWith('.yml') &&
        !path.endsWith('.arb')) {
      return;
    }
    // Skip markdown docs from content scan (guides explain Protocol 10).
    if (path.endsWith('.md')) return;

    final content = file.readAsStringSync();
    for (final token in prohibitedTypeDefinitions) {
      if (content.contains(token)) {
        violations.add('CONTENT: $path defines prohibited type "$token"');
      }
    }
    final lower = content.toLowerCase();
    for (final token in prohibitedAssetTokens) {
      if (lower.contains(token.toLowerCase())) {
        violations.add('CONTENT: $path references prohibited asset "$token"');
      }
    }
  }

  void walk(Directory dir) {
    if (!dir.existsSync()) return;
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File) scanFile(entity);
    }
  }

  walk(libDir);
  walk(assetsDir);

  if (violations.isEmpty) {
    stdout.writeln(
      'DignityLint PASSED | Protocol 10 | zero gamification / playful assets',
    );
    exit(0);
  }

  stderr.writeln('DignityLint FAILED | Protocol 10 violations:');
  for (final v in violations) {
    stderr.writeln('  - $v');
  }
  exit(1);
}
