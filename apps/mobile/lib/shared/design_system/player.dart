/// Protocol 7 – oral-first player barrel (§4 directory tree).
///
/// This serves our people by providing a single import path (`player.dart`)
/// that tribal maintainers can locate within one hour per Protocol 12.
library;

export 'package:kuttiomp_mobile/shared/design_system/audio_dominant_view.dart'
    show AudioDominantView, KuttiompOralPlayButton;

import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/shared/design_system/audio_dominant_view.dart';

/// Backward-compatible oral-first player used by feature cards (Protocol 7).
class OralFirstPlayer extends AudioDominantView {
  OralFirstPlayer({
    required Map<String, dynamic> speakerMetadata,
    required Map<String, dynamic> contentContext,
    required String audioLabel,
    String? textContent,
    VoidCallback? onPlayAudio,
    Key? key,
  }) : super(
          speakerMetadata: speakerMetadata,
          contentContext: contentContext,
          audioLabel: audioLabel,
          textContent: textContent,
          onPlayAudio: onPlayAudio,
          key: key,
        );
}