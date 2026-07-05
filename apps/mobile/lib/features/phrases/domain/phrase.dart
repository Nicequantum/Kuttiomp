import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/modes.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';
import 'package:kuttiomp_mobile/core/protocol/protocol_gateway.dart';

// Tribal Maintainer Guide (Protocol 12): governed phrase domain model (§4).
// Riverpod providers: `core/di/phrase_providers.dart` | UI: `presentation/phrase_card.dart`

/// Governed phrase categories for list filtering (§6 Flowing stage).
enum PhraseCategory {
  greeting('greeting', 'Greetings'),
  land('land', 'Land & Place'),
  family('family', 'Family'),
  ceremony('ceremony', 'Ceremony');

  const PhraseCategory(this.id, this.label);

  final String id;
  final String label;

  static PhraseCategory fromId(String? raw) {
    return PhraseCategory.values.firstWhere(
      (c) => c.id == raw,
      orElse: () => PhraseCategory.greeting,
    );
  }
}

/// Immutable governed phrase record with land and family context (§6, Protocols 1,6,7).
@immutable
class PhraseModel {
  const PhraseModel({
    required this.id,
    required this.phrase,
    required this.translation,
    required this.speakerMetadata,
    required this.primaryAudioId,
    this.category = 'greeting',
    this.landContext,
    this.familyContext,
    this.contextExamples = const [],
    this.seasonalWindow,
    this.sacredFlag = false,
    this.clanScope = const ['kuttiomp_clan'],
    this.visibleToTiers = GenerationalTierBitmask.allTiers,
    this.canonicalStage = 'awakening',
    this.elderApproved = true,
    this.authoritySource = 'elder',
    this.schemaVersion = '2.0',
    this.relatedLexemeIds = const [],
    this.conversationPrompt,
  });

  final String id;
  final String phrase;
  final String translation;
  final Map<String, dynamic> speakerMetadata;
  final String primaryAudioId;
  final String category;
  final Map<String, dynamic>? landContext;
  final Map<String, dynamic>? familyContext;
  final List<String> contextExamples;
  final String? seasonalWindow;
  final bool sacredFlag;
  final List<String> clanScope;
  final int visibleToTiers;
  final String canonicalStage;
  final bool elderApproved;
  final String authoritySource;
  final String schemaVersion;
  final List<String> relatedLexemeIds;
  final String? conversationPrompt;

  bool get isSacred => sacredFlag;

  bool get requiresLandContext => landContext != null && landContext!.isNotEmpty;

  PhraseCategory get phraseCategory => PhraseCategory.fromId(category);

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
        'requires_land_context': requiresLandContext,
        if (landContext != null) 'land_geometry': landContext,
        if (landContext != null)
          'landContext': landContext!['label'] ?? 'Narragansett territory',
        if (familyContext != null) 'family_context': familyContext,
        if (seasonalWindow != null) 'seasonal_window': seasonalWindow,
        'canonical_stage': canonicalStage,
        'category': category,
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
    gateway.protocolService.assertOralFirst(
      context: {...ctx, 'text_only': true, 'primary_audio_id': primaryAudioId},
    );
    gateway.protocolService.assertLivingAuthority(context: ctx);
    if (requiresLandContext) {
      gateway.protocolService.assertLandContext(
        context: {
          ...ctx,
          'requires_land_context': true,
          'land_geometry': landContext,
          if (seasonalWindow != null) 'seasonal_window': seasonalWindow,
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

  factory PhraseModel.fromJson(Map<String, dynamic> json) {
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

    final landRaw = json['land_context'] ?? json['land_geometry'];
    Map<String, dynamic>? landContext;
    if (landRaw is Map) {
      landContext = Map<String, dynamic>.from(landRaw);
    }

    final familyRaw = json['family_context'];
    Map<String, dynamic>? familyContext;
    if (familyRaw is Map) {
      familyContext = Map<String, dynamic>.from(familyRaw);
    }

    final examplesRaw = json['context_examples'];
    final contextExamples = <String>[];
    if (examplesRaw is List) {
      for (final item in examplesRaw) {
        contextExamples.add(item.toString());
      }
    }

    final lexemeRaw = json['related_lexeme_ids'];
    final relatedLexemeIds = <String>[];
    if (lexemeRaw is List) {
      for (final item in lexemeRaw) {
        relatedLexemeIds.add(item.toString());
      }
    }

    final audioId = json['primary_audio_id'] as String?;
    if (audioId == null || audioId.isEmpty) {
      throw ArgumentError('primary_audio_id is required for all phrases (Protocol 7)');
    }

    return PhraseModel(
      id: json['id'] as String? ?? json['phrase_id'] as String? ?? 'phrase-unknown',
      phrase: json['phrase'] as String? ?? '',
      translation: json['translation'] as String? ?? json['gloss'] as String? ?? '',
      speakerMetadata: speakerMetadata,
      primaryAudioId: audioId,
      category: json['category'] as String? ?? 'greeting',
      landContext: landContext,
      familyContext: familyContext,
      contextExamples: contextExamples,
      seasonalWindow: json['seasonal_window'] as String?,
      sacredFlag: json['sacred_flag'] as bool? ?? false,
      clanScope: clanScope.isEmpty ? ['kuttiomp_clan'] : clanScope,
      visibleToTiers: json['visible_to_tiers'] as int? ?? GenerationalTierBitmask.allTiers,
      canonicalStage: json['canonical_stage'] as String? ?? 'awakening',
      elderApproved: json['elderApproved'] as bool? ?? json['elder_approved'] as bool? ?? true,
      authoritySource: json['authority_source'] as String? ?? 'elder',
      schemaVersion: json['schema_version'] as String? ?? '2.0',
      relatedLexemeIds: relatedLexemeIds,
      conversationPrompt: json['conversation_prompt'] as String?,
    );
  }
}

/// Canonical governed phrase type alias (§4).
typedef Phrase = PhraseModel;