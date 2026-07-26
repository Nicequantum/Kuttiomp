import 'package:kuttiomp_mobile/shared/design_system/protocol_base_widget.dart';

/// Abstract base for all culturally governed content surfaces (§2, Protocol 1).
///
/// This serves our people by requiring explicit speaker, elder, and clan metadata
/// on every content-bearing widget — ensuring attribution survives OS changes
/// through 2050 without tribal developers hunting implicit context.
abstract class KuttiompContentWidget extends ProtocolBaseWidget {
  KuttiompContentWidget({
    required super.speakerMetadata,
    required bool elderApproved,
    required List<String> clanScope,
    required Map<String, dynamic> contentContext,
    super.key,
  }) : super(
          contentContext: buildContentContext(
            speakerMetadata: speakerMetadata,
            elderApproved: elderApproved,
            clanScope: clanScope,
            extra: contentContext,
          ),
        );

  /// Builds the merged protocol context used by detail screens and repositories.
  static Map<String, dynamic> buildContentContext({
    required Map<String, dynamic> speakerMetadata,
    required bool elderApproved,
    required List<String> clanScope,
    Map<String, dynamic> extra = const {},
  }) {
    return {
      ...extra,
      'speaker_id': speakerMetadata['speaker_id'] ?? speakerMetadata['id'],
      'attribution_json': speakerMetadata,
      'speakerMetadata': speakerMetadata,
      'elderApproved': elderApproved,
      'clan_scope': clanScope,
      'authority_source':
          extra['authority_source'] ?? speakerMetadata['authority_source'] ?? 'elder',
      'fontSize': extra['fontSize'] ?? 24,
      'hasSemanticsLabel': true,
    };
  }
}