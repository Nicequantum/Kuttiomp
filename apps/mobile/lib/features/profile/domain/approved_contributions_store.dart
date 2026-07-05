import 'package:kuttiomp_mobile/features/lessons/domain/lesson.dart';
import 'package:kuttiomp_mobile/features/lexeme/domain/lexeme.dart';
import 'package:kuttiomp_mobile/features/phrases/domain/phrase.dart';
import 'package:kuttiomp_mobile/features/profile/domain/elder_recording_model.dart';
import 'package:kuttiomp_mobile/features/search/domain/search_result_model.dart';

/// In-memory store for keeper-approved elder contributions (Protocol 2 corpus seed).
class ApprovedContributionsStore {
  ApprovedContributionsStore._();
  static final ApprovedContributionsStore instance = ApprovedContributionsStore._();

  final List<ElderRecordingModel> _approved = [];
  final List<ElderRecordingModel> _pending = [];
  final List<LessonModel> _lessonSeeds = [];

  List<ElderRecordingModel> pendingRecordings() => List.unmodifiable(_pending);

  List<ElderRecordingModel> approvedRecordings() => List.unmodifiable(_approved);

  void submitPending(ElderRecordingModel recording) {
    _pending.removeWhere((r) => r.id == recording.id);
    _pending.add(recording);
  }

  void promoteToApproved(ElderRecordingModel recording) {
    _pending.removeWhere((r) => r.id == recording.id);
    _approved.removeWhere((r) => r.id == recording.id);
    _approved.add(recording);
  }

  List<LexemeModel> approvedLexemes() {
    return _approved
        .where((r) => r.contentType == 'lexeme')
        .map(
          (r) => LexemeModel(
            id: r.id,
            word: r.word,
            translation: r.translation,
            speakerMetadata: r.speakerMetadata,
            primaryAudioId: r.primaryAudioId,
            sacredFlag: false,
            clanScope: r.clanScope,
            visibleToTiers: r.visibleToTiers,
            canonicalStage: r.canonicalStage,
            elderApproved: true,
            authoritySource: r.authoritySource,
          ),
        )
        .toList();
  }

  /// Merges elder-approved seeds into [base] without duplicate IDs (Protocol 2).
  static List<LexemeModel> mergeElderSeeds(List<LexemeModel> base) {
    final merged = List<LexemeModel>.from(base);
    for (final seed in instance.approvedLexemes()) {
      if (!merged.any((l) => l.id == seed.id)) {
        merged.add(seed);
      }
    }
    return merged;
  }

  /// Merges elder-approved phrase seeds into [base] without duplicate IDs (Protocol 2).
  static List<PhraseModel> mergeElderPhraseSeeds(List<PhraseModel> base) {
    final merged = List<PhraseModel>.from(base);
    for (final seed in instance.approvedPhrases()) {
      if (!merged.any((p) => p.id == seed.id)) {
        merged.add(seed);
      }
    }
    return merged;
  }

  List<PhraseModel> approvedPhrases() {
    return _approved
        .where((r) => r.contentType == 'phrase')
        .map(
          (r) => PhraseModel(
            id: r.id,
            phrase: r.word,
            translation: r.translation,
            speakerMetadata: r.speakerMetadata,
            primaryAudioId: r.primaryAudioId,
            canonicalStage: r.canonicalStage,
            category: r.speakerMetadata['category'] as String? ?? 'greeting',
            landContext: _landContextFromMetadata(r.speakerMetadata),
            seasonalWindow: r.speakerMetadata['seasonal_window'] as String?,
            elderApproved: true,
            authoritySource: r.authoritySource,
          ),
        )
        .toList();
  }

  List<LessonModel> approvedLessonSeeds() => List.unmodifiable(_lessonSeeds);

  void addLessonSeed(LessonModel lesson) {
    _lessonSeeds.removeWhere((l) => l.id == lesson.id);
    _lessonSeeds.add(lesson);
  }

  /// Merges elder-approved lesson seeds into [base] without duplicate IDs (Protocol 2).
  static List<LessonModel> mergeElderLessonSeeds(List<LessonModel> base) {
    final merged = List<LessonModel>.from(base);
    for (final seed in instance.approvedLessonSeeds()) {
      if (!merged.any((l) => l.id == seed.id)) {
        merged.add(seed);
      }
    }
    return merged;
  }

  static Map<String, dynamic>? _landContextFromMetadata(Map<String, dynamic> metadata) {
    final raw = metadata['land_context'];
    if (raw is Map<String, dynamic>) return Map<String, dynamic>.from(raw);
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  List<SearchResultModel> approvedSearchResults() {
    return _approved.map((r) {
      final type = SearchContentType.fromId(r.contentType);
      return SearchResultModel(
        id: r.id,
        contentType: type,
        title: r.word,
        subtitle: r.translation,
        speakerMetadata: r.speakerMetadata,
        primaryAudioId: r.primaryAudioId,
        canonicalStage: r.canonicalStage,
        clanScope: r.clanScope,
        visibleToTiers: r.visibleToTiers,
        landContext: _landContextFromMetadata(r.speakerMetadata),
        seasonalWindow: r.speakerMetadata['seasonal_window'] as String?,
        elderApproved: true,
        authoritySource: r.authoritySource,
      );
    }).toList();
  }

  void clear() {
    _pending.clear();
    _approved.clear();
    _lessonSeeds.clear();
  }
}