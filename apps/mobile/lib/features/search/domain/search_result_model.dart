import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';

/// Governed content types unified by search (§4).
enum SearchContentType {
  lexeme('lexeme', 'Word'),
  phrase('phrase', 'Phrase'),
  lesson('lesson', 'Lesson');

  const SearchContentType(this.id, this.label);

  final String id;
  final String label;

  static SearchContentType fromId(String? raw) {
    return SearchContentType.values.firstWhere(
      (t) => t.id == raw,
      orElse: () => SearchContentType.lexeme,
    );
  }
}

/// Immutable unified search result with protocol metadata (Protocols 1,4,5,6,7,9).
@immutable
class SearchResultModel {
  const SearchResultModel({
    required this.id,
    required this.contentType,
    required this.title,
    required this.subtitle,
    required this.speakerMetadata,
    required this.primaryAudioId,
    this.sacredFlag = false,
    this.ceremonialFlag = false,
    this.clanScope = const ['kuttiomp_clan'],
    this.visibleToTiers = GenerationalTierBitmask.allTiers,
    this.canonicalStage = 'awakening',
    this.landContext,
    this.seasonalWindow,
    this.elderApproved = true,
    this.authoritySource = 'elder',
    this.schemaVersion = '2.0',
  });

  final String id;
  final SearchContentType contentType;
  final String title;
  final String subtitle;
  final Map<String, dynamic> speakerMetadata;
  final String primaryAudioId;
  final bool sacredFlag;
  final bool ceremonialFlag;
  final List<String> clanScope;
  final int visibleToTiers;
  final String canonicalStage;
  final Map<String, dynamic>? landContext;
  final String? seasonalWindow;
  final bool elderApproved;
  final String authoritySource;
  final String schemaVersion;

  bool get requiresSacredGate => sacredFlag || ceremonialFlag;

  bool get requiresLandContext => landContext != null && landContext!.isNotEmpty;

  String get speakerId =>
      speakerMetadata['speaker_id'] as String? ??
      speakerMetadata['id'] as String? ??
      'unknown-speaker';

  String get detailRoute {
    switch (contentType) {
      case SearchContentType.lexeme:
        return '/lexeme/$id';
      case SearchContentType.phrase:
        return '/phrase/$id';
      case SearchContentType.lesson:
        return '/lesson/$id';
    }
  }

  Map<String, dynamic> toContentContext({KuttiompMode? mode}) => {
        'speaker_id': speakerId,
        'attribution_json': speakerMetadata,
        'speakerMetadata': speakerMetadata,
        'primary_audio_id': primaryAudioId,
        'sacred_flag': sacredFlag || ceremonialFlag,
        'clan_scope': clanScope,
        'visible_to_tiers': visibleToTiers,
        'elderApproved': elderApproved,
        'authority_source': authoritySource,
        'schema_version': schemaVersion,
        'requires_land_context': requiresLandContext,
        if (landContext != null) 'land_geometry': landContext,
        if (landContext != null)
          'landContext': landContext!['label'] ?? 'Narragansett territory',
        if (seasonalWindow != null) 'seasonal_window': seasonalWindow,
        'canonical_stage': canonicalStage,
        'content_type': contentType.id,
        'fontSize': mode?.minimumFontSize ?? 24.0,
        'hasSemanticsLabel': true,
      };

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    final clanRaw = json['clan_scope'];
    final clanScope = <String>[];
    if (clanRaw is List) {
      for (final item in clanRaw) {
        clanScope.add(item.toString());
      }
    }

    final speakerRaw = json['speaker_metadata'] ?? json['attribution_json'];
    final speakerMetadata = speakerRaw is Map<String, dynamic>
        ? Map<String, dynamic>.from(speakerRaw)
        : <String, dynamic>{
            'speaker_id': json['speaker_id'] ?? 'grandmother-comus',
            'name': json['speaker_name'] ?? 'Attributed Speaker',
            'authority_source': json['authority_source'] ?? 'elder',
          };

    final audioId = json['primary_audio_id'] as String?;
    if (audioId == null || audioId.isEmpty) {
      throw ArgumentError('primary_audio_id required for search results (Protocol 7)');
    }

    return SearchResultModel(
      id: json['id'] as String? ?? json['content_id'] as String? ?? 'unknown',
      contentType: SearchContentType.fromId(
        json['content_type'] as String? ?? json['type'] as String?,
      ),
      title: json['title'] as String? ?? json['label'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? json['translation'] as String? ?? '',
      speakerMetadata: speakerMetadata,
      primaryAudioId: audioId,
      sacredFlag: json['sacred_flag'] as bool? ?? false,
      ceremonialFlag: json['ceremonial_flag'] as bool? ?? false,
      clanScope: clanScope.isEmpty ? ['kuttiomp_clan'] : clanScope,
      visibleToTiers: json['visible_to_tiers'] as int? ?? GenerationalTierBitmask.allTiers,
      canonicalStage:
          json['canonical_stage'] as String? ?? json['stage'] as String? ?? 'awakening',
      landContext: json['land_context'] is Map
          ? Map<String, dynamic>.from(json['land_context'] as Map)
          : json['land_geometry'] is Map
              ? Map<String, dynamic>.from(json['land_geometry'] as Map)
              : null,
      seasonalWindow: json['seasonal_window'] as String?,
      elderApproved: json['elderApproved'] as bool? ?? json['elder_approved'] as bool? ?? true,
      authoritySource: json['authority_source'] as String? ?? 'elder',
      schemaVersion: json['schema_version'] as String? ?? '2.0',
    );
  }
}