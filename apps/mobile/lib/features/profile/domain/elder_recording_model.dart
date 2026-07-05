import 'package:flutter/foundation.dart';
import 'package:kuttiomp_mobile/core/constants/protocols.dart';

/// Approval lifecycle for elder-contributed oral recordings (Protocol 2).
enum RecordingApprovalStatus {
  draft('draft'),
  pending('pending'),
  approved('approved'),
  rejected('rejected');

  const RecordingApprovalStatus(this.id);

  final String id;

  static RecordingApprovalStatus fromId(String? raw) {
    return RecordingApprovalStatus.values.firstWhere(
      (s) => s.id == raw,
      orElse: () => RecordingApprovalStatus.draft,
    );
  }
}

/// Governed elder recording submission (Protocols 1,2,7,8).
@immutable
class ElderRecordingModel {
  const ElderRecordingModel({
    required this.id,
    required this.word,
    required this.translation,
    required this.speakerMetadata,
    required this.primaryAudioId,
    required this.contentType,
    required this.status,
    this.canonicalStage = 'awakening',
    this.clanScope = const ['kuttiomp_clan'],
    this.visibleToTiers = GenerationalTierBitmask.elder,
    this.elderApproved = false,
    this.authoritySource = 'elder',
    this.schemaVersion = '2.0',
    this.submittedAt,
    this.approvedAt,
    this.approvalChain = const [],
  });

  final String id;
  final String word;
  final String translation;
  final Map<String, dynamic> speakerMetadata;
  final String primaryAudioId;
  final String contentType;
  final RecordingApprovalStatus status;
  final String canonicalStage;
  final List<String> clanScope;
  final int visibleToTiers;
  final bool elderApproved;
  final String authoritySource;
  final String schemaVersion;
  final DateTime? submittedAt;
  final DateTime? approvedAt;
  final List<String> approvalChain;

  bool get isPending => status == RecordingApprovalStatus.pending;
  bool get isApproved => status == RecordingApprovalStatus.approved;

  String get speakerId =>
      speakerMetadata['speaker_id'] as String? ??
      speakerMetadata['id'] as String? ??
      'elder-contributor';

  Map<String, dynamic> toContentContext() => {
        'speaker_id': speakerId,
        'attribution_json': speakerMetadata,
        'speakerMetadata': speakerMetadata,
        'primary_audio_id': primaryAudioId,
        'elderApproved': elderApproved,
        'authority_source': authoritySource,
        'schema_version': schemaVersion,
        'canonical_stage': canonicalStage,
        'clan_scope': clanScope,
        'visible_to_tiers': visibleToTiers,
        'approval_chain': approvalChain,
        'hasSemanticsLabel': true,
      };

  ElderRecordingModel copyWith({
    RecordingApprovalStatus? status,
    bool? elderApproved,
    DateTime? submittedAt,
    DateTime? approvedAt,
    List<String>? approvalChain,
  }) {
    return ElderRecordingModel(
      id: id,
      word: word,
      translation: translation,
      speakerMetadata: speakerMetadata,
      primaryAudioId: primaryAudioId,
      contentType: contentType,
      status: status ?? this.status,
      canonicalStage: canonicalStage,
      clanScope: clanScope,
      visibleToTiers: visibleToTiers,
      elderApproved: elderApproved ?? this.elderApproved,
      authoritySource: authoritySource,
      schemaVersion: schemaVersion,
      submittedAt: submittedAt ?? this.submittedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      approvalChain: approvalChain ?? this.approvalChain,
    );
  }

  factory ElderRecordingModel.fromJson(Map<String, dynamic> json) {
    final audioId = json['primary_audio_id'] as String?;
    if (audioId == null || audioId.isEmpty) {
      throw ArgumentError('primary_audio_id required for elder recordings (Protocol 7)');
    }

    final chainRaw = json['approval_chain'];
    final chain = <String>[];
    if (chainRaw is List) {
      for (final item in chainRaw) {
        chain.add(item.toString());
      }
    }

    final speakerRaw = json['speaker_metadata'] ?? json['attribution_json'];
    final speakerMetadata = speakerRaw is Map<String, dynamic>
        ? Map<String, dynamic>.from(speakerRaw)
        : <String, dynamic>{
            'speaker_id': json['speaker_id'] ?? 'elder-contributor',
            'name': json['speaker_name'] ?? 'Elder Contributor',
            'authority_source': 'elder',
          };

    return ElderRecordingModel(
      id: json['id'] as String? ?? 'recording-${DateTime.now().millisecondsSinceEpoch}',
      word: json['word'] as String? ?? json['title'] as String? ?? '',
      translation: json['translation'] as String? ?? '',
      speakerMetadata: speakerMetadata,
      primaryAudioId: audioId,
      contentType: json['content_type'] as String? ?? 'lexeme',
      status: RecordingApprovalStatus.fromId(json['status'] as String?),
      canonicalStage: json['canonical_stage'] as String? ?? 'awakening',
      elderApproved: json['elderApproved'] as bool? ?? json['elder_approved'] as bool? ?? false,
      submittedAt: json['submitted_at'] != null
          ? DateTime.tryParse(json['submitted_at'].toString())
          : null,
      approvedAt: json['approved_at'] != null
          ? DateTime.tryParse(json['approved_at'].toString())
          : null,
      approvalChain: chain,
    );
  }
}