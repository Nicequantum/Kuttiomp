import 'package:flutter/foundation.dart';
import 'package:flutter/semantics.dart';

/// First-launch audio narration with elder-reviewed asset hook (§13, Component 6).
class AudioNarrationService {
  AudioNarrationService._();

  static const String firstLaunchAssetPath = 'assets/audio/first_launch_welcome.mp3';

  static const String welcomeScript =
      'Welcome to Kuttiomp. Select the learning path that honors your journey. '
      'Little Ones is recommended for our youngest learners.';

  /// Plays accessibility narration; logs asset path for elder-reviewed audio in production.
  static Future<void> playFirstLaunchWelcome() async {
    SemanticsService.announce(welcomeScript, TextDirection.ltr);
    if (kDebugMode) {
      debugPrint(
        'Audio narration: $welcomeScript '
        '(elder-reviewed asset: $firstLaunchAssetPath)',
      );
    }
  }
}