// Protocol 10 – DignityLint CI scanner (offline, zero external services).
//
// This serves our people by failing the build when gamification or playful
// patterns appear, protecting cultural dignity through 2050.
//
// Run: dart run scripts/dignity_lint.dart
// Exit code 1 = Protocol 10 violation (CI must fail).

import 'dart:io';

const prohibitedTokens = <String>[
  'NoPlayWidget',
  'GamificationBadge',
  'PointsCounter',
  'StreakTracker',
  'Leaderboard',
  'PlayfulMascot',
  'ConfettiWidget',
  'achievement_badge',
  'confetti',
  'gamification',
  'streak_flame',
  'playful_mascot',
  'cartoon_character',
  'emoji_pack',
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
  if (p.contains('protocol_compliance') && p.endsWith('.dart')) {
    // Tests may mention forbidden names when asserting rejection.
    return true;
  }
  if (p.contains('dignity_lint_test')) return true;
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
    for (final token in prohibitedTokens) {
      if (lowerPath.contains(token.toLowerCase())) {
        violations.add('PATH: $path contains prohibited token "$token"');
      }
    }
    if (!path.endsWith('.dart') &&
        !path.endsWith('.yaml') &&
        !path.endsWith('.yml') &&
        !path.endsWith('.md') &&
        !path.endsWith('.arb')) {
      return;
    }
    final content = file.readAsStringSync();
    final lower = content.toLowerCase();
    for (final token in prohibitedTokens) {
      if (lower.contains(token.toLowerCase())) {
        // Allowlisted definition sites only.
        if (isAllowlisted(path)) continue;
        violations.add('CONTENT: $path references prohibited "$token"');
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
