/// Secure RPC names exposed by the Kuttiomp backend (no direct table access).
class KuttiompRpc {
  KuttiompRpc._();

  static const String getLexeme = 'get_lexeme_secure';
  static const String listLexemes = 'list_lexemes_secure';
  static const String getLexemeById = 'get_lexeme_by_id';
  static const String getLexemesForStage = 'get_lexemes_for_stage';
  static const String getPhrasesForStage = 'get_phrases_for_stage';
  static const String getPhraseContext = 'get_phrase_context';
  static const String getLessonsForStage = 'get_lessons_for_stage';
  static const String getLessonContent = 'get_lesson_content';
  static const String completeLesson = 'complete_lesson_secure';
  static const String searchContent = 'search_content_secure';
  static const String getSpeaker = 'get_speaker_secure';
  static const String listSpeakers = 'list_speakers_secure';
  static const String getUserProfile = 'get_user_profile_secure';
  static const String updateUserMode = 'update_user_mode_secure';
  static const String syncOfflineBatch = 'sync_offline_batch_secure';
  static const String submitElderRecording = 'submit_elder_recording_secure';
  static const String approveElderRecording = 'approve_elder_recording_secure';
  static const String submitPilotFeedback = 'submit_pilot_feedback_secure';
  static const String notifyCorpusUpdated = 'notify_corpus_updated_secure';
  static const String submitLivePilotObservation = 'submit_live_pilot_observation_secure';
  static const String createHouseholdSeedClaim = 'create_household_seed_claim_secure';
  static const String review48hrObservations = 'review_48hr_observations_secure';
  static const String sealCovenant = 'seal_covenant_secure';
  static const String sealDay7Covenant = 'seal_day7_covenant_secure';

  static const List<String> all = [
    getLexeme,
    listLexemes,
    getLexemeById,
    getLexemesForStage,
    getPhrasesForStage,
    getPhraseContext,
    getLessonsForStage,
    getLessonContent,
    completeLesson,
    searchContent,
    getSpeaker,
    listSpeakers,
    getUserProfile,
    updateUserMode,
    syncOfflineBatch,
    submitElderRecording,
    approveElderRecording,
    submitPilotFeedback,
    notifyCorpusUpdated,
    submitLivePilotObservation,
    createHouseholdSeedClaim,
    review48hrObservations,
    sealCovenant,
    sealDay7Covenant,
  ];
}