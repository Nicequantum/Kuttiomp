import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/mastery_stages.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';

// Tribal Maintainer Guide (Protocol 12): governed lesson domain model (§4).
// Riverpod providers: `core/di/lesson_providers.dart` | UI: `presentation/lesson_card.dart`

/// Sequential oral audio block within a lesson (Protocol 7).
@immutable
class LessonAudioBlock {
  const LessonAudioBlock({
    required this.id,
    required this.label,
    required this.primaryAudioId,
    required this.order,
    this.transcript,
  });

  final String id;
  final String label;
  final String primaryAudioId;
  final int order;
  final String? transcript;

  factory LessonAudioBlock.fromJson(Map<String, dynamic> json) {
    final audioId = json['primary_audio_id'] as String?;
    if (audioId == null || audioId.isEmpty) {
      throw ArgumentError('primary_audio_id required for every audio block (Protocol 7)');
    }
    return LessonAudioBlock(
      id: json['id'] as String? ?? 'block-${json['order'] ?? 0}',
      label: json['label'] as String? ?? 'Listen',
      primaryAudioId: audioId,
      order: json['order'] as int? ?? 0,
      transcript: json['transcript'] as String?,
    );
  }
}

/// Embedded protocol metadata snapshot on every lesson entity (§7).
@immutable
class LessonProtocolMetadata {
  const LessonProtocolMetadata({
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

/// Structured lesson record for six-stage progression (§6).
@immutable
class LessonModel {
  const LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.stage,
    required this.speakerMetadata,
    required this.audioBlocks,
    this.ceremonialFlag = false,
    this.clanScope = const ['kuttiomp_clan'],
    this.visibleToTiers = GenerationalTierBitmask.allTiers,
    this.elderApproved = true,
    this.authoritySource = 'elder',
    this.schemaVersion = '2.0',
    this.progressPercent = 0,
    this.relatedLexemeIds = const [],
    this.relatedPhraseIds = const [],
    this.landContextGeo,
  });

  final String id;
  final String title;
  final String description;
  final MasteryStage stage;
  final Map<String, dynamic> speakerMetadata;
  final List<LessonAudioBlock> audioBlocks;
  final bool ceremonialFlag;
  final List<String> clanScope;
  final int visibleToTiers;
  final bool elderApproved;
  final String authoritySource;
  final String schemaVersion;
  final int progressPercent;
  final List<String> relatedLexemeIds;
  final List<String> relatedPhraseIds;
  final String? landContextGeo;

  String get stageId => stage.id;

  bool get isSacred => ceremonialFlag;

  String get speakerId =>
      speakerMetadata['speaker_id'] as String? ??
      speakerMetadata['id'] as String? ??
      'unknown-speaker';

  Map<String, dynamic> get attributionJson => speakerMetadata;

  String get primaryAudioId =>
      audioBlocks.isNotEmpty ? audioBlocks.first.primaryAudioId : 'audio-lesson';

  LessonProtocolMetadata get protocolMetadata => LessonProtocolMetadata(
        recordId: id,
        speakerId: speakerId,
        primaryAudioId: primaryAudioId,
        sacredFlag: ceremonialFlag,
        elderApproved: elderApproved,
        clanScope: clanScope,
        visibleToTiers: visibleToTiers,
        authoritySource: authoritySource,
        schemaVersion: schemaVersion,
      );

  Map<String, dynamic> toContentContext({KuttiompMode? mode}) => {
        'speaker_id': speakerId,
        'attribution_json': speakerMetadata,
        'speakerMetadata': speakerMetadata,
        'primary_audio_id': primaryAudioId,
        'sacred_flag': ceremonialFlag,
        'clan_scope': clanScope,
        'visible_to_tiers': visibleToTiers,
        'elderApproved': elderApproved,
        'authority_source': authoritySource,
        'schema_version': schemaVersion,
        'canonical_stage': stage.id,
        if (landContextGeo != null) 'landContext': landContextGeo,
        'fontSize': mode?.minimumFontSize ?? 24.0,
        'hasSemanticsLabel': true,
      };

  /// Asserts full protocol compliance before render or persistence.
  void assertCompliant(ProtocolGateway gateway) {
    final ctx = toContentContext();
    gateway.assertSpeakerPresent(context: ctx);
    gateway.protocolService.assertElderApproved(context: ctx);
    gateway.protocolService.assertTierAccess(context: ctx);
    gateway.protocolService.assertClanScope(context: ctx);
    gateway.protocolService.assertLivingAuthority(context: ctx);
    for (final block in audioBlocks) {
      gateway.protocolService.assertOralFirst(
        context: {
          ...ctx,
          'text_only': block.transcript != null,
          'primary_audio_id': block.primaryAudioId,
        },
      );
    }
    if (ceremonialFlag) {
      gateway.protocolService.assertSacredProtected(
        context: {...ctx, 'sacred_flag': true, 'sacred_consent_granted': true},
      );
    }
    gateway.assertCompliant(
      KuttiompProtocol.dataSovereignty.id,
      context: const {'direct_table_access': false},
    );
  }

  factory LessonModel.fromJson(Map<String, dynamic> json) {
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

    final blocksRaw = json['audio_blocks'] ?? json['audioBlocks'];
    final blocks = <LessonAudioBlock>[];
    if (blocksRaw is List) {
      for (final item in blocksRaw) {
        if (item is Map) {
          blocks.add(LessonAudioBlock.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }
    blocks.sort((a, b) => a.order.compareTo(b.order));

    final stageId = json['stage'] as String? ?? json['canonical_stage'] as String? ?? 'awakening';

    return LessonModel(
      id: json['id'] as String? ?? json['lesson_id'] as String? ?? 'lesson-unknown',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      stage: MasteryStage.fromId(stageId),
      speakerMetadata: speakerMetadata,
      audioBlocks: blocks,
      ceremonialFlag: json['ceremonial_flag'] as bool? ?? json['sacred_flag'] as bool? ?? false,
      clanScope: clanScope.isEmpty ? ['kuttiomp_clan'] : clanScope,
      visibleToTiers: json['visible_to_tiers'] as int? ?? GenerationalTierBitmask.allTiers,
      elderApproved: json['elderApproved'] as bool? ?? json['elder_approved'] as bool? ?? true,
      authoritySource: json['authority_source'] as String? ?? 'elder',
      schemaVersion: json['schema_version'] as String? ?? '2.0',
      progressPercent: json['progress_percent'] as int? ?? 0,
      relatedLexemeIds: _parseIds(json['related_lexeme_ids']),
      relatedPhraseIds: _parseIds(json['related_phrase_ids']),
      landContextGeo: json['land_context_geo'] as String? ?? json['landContext'] as String?,
    );
  }

  static List<String> _parseIds(dynamic raw) {
    if (raw is! List) return [];
    return raw.map((e) => e.toString()).toList();
  }

  LessonModel copyWith({int? progressPercent}) => LessonModel(
        id: id,
        title: title,
        description: description,
        stage: stage,
        speakerMetadata: speakerMetadata,
        audioBlocks: audioBlocks,
        ceremonialFlag: ceremonialFlag,
        clanScope: clanScope,
        visibleToTiers: visibleToTiers,
        elderApproved: elderApproved,
        authoritySource: authoritySource,
        schemaVersion: schemaVersion,
        progressPercent: progressPercent ?? this.progressPercent,
        relatedLexemeIds: relatedLexemeIds,
        relatedPhraseIds: relatedPhraseIds,
        landContextGeo: landContextGeo,
      );
}

/// Canonical governed lesson type alias (§4).
typedef Lesson = LessonModel;