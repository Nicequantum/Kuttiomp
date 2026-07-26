import 'package:flutter/material.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_service.dart';
import 'package:kuttiomp_mobile/core/theme/kuttiomp_theme_extension.dart';
import 'package:kuttiomp_mobile/shared/design_system/kuttiomp_content_widget.dart';

List<String> _clanScopeFromContext(Map<String, dynamic> contentContext) {
  final clanRaw = contentContext['clan_scope'] ?? contentContext['clanScope'];
  if (clanRaw is List) {
    return clanRaw.map((e) => e.toString()).toList();
  }
  return const [];
}

/// Protocol 7 implementing widget – oral tradition primacy (§2, §8).
///
/// This serves our people by placing ancestor voices before written text,
/// honoring oral tradition as the primary transmission path through 2050.
class AudioDominantView extends KuttiompContentWidget {
  AudioDominantView({
    required super.speakerMetadata,
    required Map<String, dynamic> contentContext,
    required this.audioLabel,
    this.textContent,
    this.onPlayAudio,
    bool? elderApproved,
    List<String>? clanScope,
    super.key,
  }) : super(
          elderApproved: elderApproved ?? contentContext['elderApproved'] == true,
          clanScope: clanScope ?? _clanScopeFromContext(contentContext),
          contentContext: contentContext,
        );

  final String audioLabel;
  final String? textContent;
  final VoidCallback? onPlayAudio;

  @override
  Widget buildProtocolContent(BuildContext context) {
    KuttiompProtocolService.instance.assertCompliant(
      '7',
      context: {
        ...mergedContext,
        'primary_audio_id': contentContext['primary_audio_id'] ?? 'audio-primary',
        'text_only': textContent != null,
      },
    );
    KuttiompProtocolService.instance.assertOralFirst(
      context: {
        ...mergedContext,
        'primary_audio_id': contentContext['primary_audio_id'] ?? 'audio-primary',
        'text_only': textContent != null,
      },
    );

    final ext = KuttiompThemeExtension.of(context);
    var showText = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Semantics(
          label: 'Oral tradition player. Primary audio: $audioLabel',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KuttiompOralPlayButton(
                label: audioLabel,
                onPressed: onPlayAudio,
                ext: ext,
              ),
              if (textContent != null) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() => showText = !showText),
                  child: Text(showText ? 'Hide text' : 'Show text (secondary)'),
                ),
                if (showText)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(textContent!, style: ext.bodyLarge),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Shared oral play control – dignified, no gamification (Protocol 10).
class KuttiompOralPlayButton extends StatelessWidget {
  const KuttiompOralPlayButton({
    required this.label,
    required this.ext,
    this.onPressed,
    super.key,
  });

  final String label;
  final KuttiompThemeExtension ext;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Play oral tradition audio: $label',
      child: SizedBox(
        height: ext.minimumTouchTarget,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.volume_up),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: ext.landAccent,
            foregroundColor: Colors.white,
            textStyle: ext.bodyLarge,
          ),
        ),
      ),
    );
  }
}