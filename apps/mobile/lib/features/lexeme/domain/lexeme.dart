import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';

// Tribal Maintainer Guide (Protocol 12): governed lexeme domain model (§4).
// Riverpod providers: `core/di/lexeme_providers.dart` | UI: `presentation/lexeme_card.dart`

/// Protocol 6 – land geometry context for lexeme surfaces.
@immutable
class GeoContext {
  const GeoContext({
    this.type,
    this.label,
    this.coordinates = const [],
    this.seasonalWindow,
  });

  final String? type;
  final String? label;
  final List<double> coordinates;
  final String? seasonalWindow;

  Map<String, dynamic> toJson() => {
        if (type != null) 'type': type,
        if (label != null) 'label': label,
        if (coordinates.isNotEmpty) 'coordinates': coordinates,
        if (seasonalWindow != null) 'seasonal_window': seasonalWindow,
      };

  factory GeoContext.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const GeoContext();
    final coords = <double>[];
    final raw = json['coordinates'];
    if (raw is List) {
      for (final item in raw) {
        if (item is num) coords.add(item.toDouble());
      }
    }
    return GeoContext(
      type: json['type'] as String?,
      label: json['label'] as String?,
      coordinates: coords,
      seasonalWindow: json['seasonal_window'] as String?,
    );
  }
}

/// Embedded protocol metadata snapshot on every lexeme entity (§7).
@immutable
class LexemeProtocolMetadata {
  const LexemeProtocolMetadata({
    required this.recordId,
    required this.speakerId,
    required this.primaryAudioId,
    required this.sacredFlag,
    required this.elderApproved,
    required this.clanScope,
    required this.visibleToTiers,
    required this.authoritySource,
    required this.schemaVersion,
  });

  final String recordId;
  final String speakerId;
  final String primaryAudioId;
  final bool sacredFlag;
  final bool elderApproved;
  final List<String> clanScope;
  final int visibleToTiers;
  final String authoritySource;
  final String schemaVersion;
}

/// Immutable governed lexeme record (§4, Protocols 1–12).
@immutable
class LexemeModel {
  const LexemeModel({
    required this.id,
    required this.word,
    required this.translation,
    required this.speakerMetadata,
    required this.primaryAudioId,
    required this.sacredFlag,
    required this.clanScope,
    required this.visibleToTiers,
    required this.canonicalStage,
    this.elderApproved = true,
    this.authoritySource = 'elder',
    this.schemaVersion = '2.0',
    this.requiresLandContext = false,
    this.geoContext,
  });

  final String id;
  final String word;
  final String translation;
  final Map<String, dynamic> speakerMetadata;
  final String primaryAudioId;
  final bool sacredFlag;
  final List<String> clanScope;
  final int visibleToTiers;
  final String canonicalStage;
  final bool elderApproved;
  final String authoritySource;
  final String schemaVersion;
  final bool requiresLandContext;
  final GeoContext? geoContext;

  /// Canonical governed lexeme type alias (§4).
  static LexemeModel fromGovernedJson(Map<String, dynamic> json) => LexemeModel.fromJson(json);

  bool get isSacred => sacredFlag;

  bool get hasGeoContext =>
      requiresLandContext ||
      (geoContext != null && (geoContext!.label?.isNotEmpty ?? false));

  Map<String, dynamic> get attributionJson => speakerMetadata;

  String? get landContextGeo => geoContext?.label;

  LexemeProtocolMetadata get protocolMetadata => LexemeProtocolMetadata(
        recordId: id,
        speakerId: speakerId,
        primaryAudioId: primaryAudioId,
        sacredFlag: sacredFlag,
        elderApproved: elderApproved,
        clanScope: clanScope,
        visibleToTiers: visibleToTiers,
        authoritySource: authoritySource,
        schemaVersion: schemaVersion,
      );

  String get speakerId =>
      speakerMetadata['speaker_id'] as String? ??
      speakerMetadata['id'] as String? ??
      'unknown-speaker';

  String get speakerName =>
      speakerMetadata['name'] as String? ?? 'Attributed Speaker';

  Map<String, dynamic> toContentContext({KuttiompMode? mode}) => {
        'speaker_id': speakerId,
        'attribution_json': speakerMetadata,
        'speakerMetadata': speakerMetadata,
        'primary_audio_id': primaryAudioId,
        'sacred_flag': sacredFlag,
        'clan_scope': clanScope,
        'visible_to_tiers': visibleToTiers,
        'elderApproved': elderApproved,
        'authority_source': authoritySource,
        'schema_version': schemaVersion,
        'requires_land_context': hasGeoContext,
        if (geoContext != null) 'land_geometry': geoContext!.toJson(),
        if (geoContext?.label != null) 'landContext': geoContext!.label,
        'canonical_stage': canonicalStage,
        'fontSize': mode?.minimumFontSize ?? 24.0,
        'hasSemanticsLabel': true,
      };

  /// Asserts full 12-protocol compliance before render or persistence.
  void assertCompliant(ProtocolGateway gateway) {
    final ctx = toContentContext();
    gateway.assertSpeakerPresent(context: ctx);
    gateway.protocolService.assertElderApproved(context: ctx);
    gateway.protocolService.assertTierAccess(context: ctx);
    gateway.protocolService.assertClanScope(context: ctx);
    gateway.protocolService.assertOralFirst(
      context: {...ctx, 'text_only': true, 'primary_audio_id': primaryAudioId},
    );
    gateway.protocolService.assertLivingAuthority(context: ctx);
    if (hasGeoContext) {
      gateway.protocolService.assertLandContext(
        context: {
          ...ctx,
          'requires_land_context': true,
          'land_geometry': geoContext?.toJson() ?? {'type': 'Point'},
        },
      );
    }
    if (sacredFlag) {
      gateway.protocolService.assertSacredProtected(
        context: {...ctx, 'sacred_flag': true, 'sacred_consent_granted': true},
      );
    }
    gateway.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false},
    );
  }

  factory LexemeModel.fromJson(Map<String, dynamic> json) {
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
            'name': json['speaker_name'] ?? 'Grandmother Comus',
            'authority_source': json['authority_source'] ?? 'elder',
          };

    return LexemeModel(
      id: json['id'] as String? ?? json['lexeme_id'] as String? ?? 'lexeme-unknown',
      word: json['word'] as String? ?? json['lexeme'] as String? ?? '',
      translation: json['translation'] as String? ?? json['gloss'] as String? ?? '',
      speakerMetadata: speakerMetadata,
      primaryAudioId: json['primary_audio_id'] as String? ?? 'audio-primary',
      sacredFlag: json['sacred_flag'] as bool? ?? false,
      clanScope: clanScope.isEmpty ? ['kuttiomp_clan'] : clanScope,
      visibleToTiers: json['visible_to_tiers'] as int? ?? GenerationalTierBitmask.allTiers,
      canonicalStage: json['canonical_stage'] as String? ?? 'awakening',
      elderApproved: json['elderApproved'] as bool? ?? json['elder_approved'] as bool? ?? true,
      authoritySource: json['authority_source'] as String? ?? 'elder',
      schemaVersion: json['schema_version'] as String? ?? '2.0',
      requiresLandContext: json['requires_land_context'] as bool? ?? false,
      geoContext: json['geo_context'] is Map
          ? GeoContext.fromJson(Map<String, dynamic>.from(json['geo_context'] as Map))
          : json['land_geometry'] is Map
              ? GeoContext.fromJson(Map<String, dynamic>.from(json['land_geometry'] as Map))
              : null,
    );
  }

  LexemeModel copyWith({
    String? id,
    String? word,
    String? translation,
    Map<String, dynamic>? speakerMetadata,
    String? primaryAudioId,
    bool? sacredFlag,
    List<String>? clanScope,
    int? visibleToTiers,
    String? canonicalStage,
    bool? elderApproved,
    String? authoritySource,
    String? schemaVersion,
    bool? requiresLandContext,
    GeoContext? geoContext,
  }) {
    return LexemeModel(
      id: id ?? this.id,
      word: word ?? this.word,
      translation: translation ?? this.translation,
      speakerMetadata: speakerMetadata ?? this.speakerMetadata,
      primaryAudioId: primaryAudioId ?? this.primaryAudioId,
      sacredFlag: sacredFlag ?? this.sacredFlag,
      clanScope: clanScope ?? this.clanScope,
      visibleToTiers: visibleToTiers ?? this.visibleToTiers,
      canonicalStage: canonicalStage ?? this.canonicalStage,
      elderApproved: elderApproved ?? this.elderApproved,
      authoritySource: authoritySource ?? this.authoritySource,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      requiresLandContext: requiresLandContext ?? this.requiresLandContext,
      geoContext: geoContext ?? this.geoContext,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LexemeModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Canonical governed lexeme type alias (§4).
typedef Lexeme = LexemeModel;