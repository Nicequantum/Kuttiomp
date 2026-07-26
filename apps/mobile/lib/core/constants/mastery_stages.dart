/// Six canonical learning stages (§6).
enum MasteryStage {
  awakening(
    id: 'awakening',
    label: 'Awakening',
    description: 'Recognizes 50 common words/phrases by sound and context.',
    wordThreshold: 50,
  ),
  rooted(
    id: 'rooted',
    label: 'Rooted',
    description: 'Uses 200+ words in daily routines.',
    wordThreshold: 200,
  ),
  flowing(
    id: 'flowing',
    label: 'Flowing',
    description: 'Holds short conversations describing land and family.',
    wordThreshold: 400,
  ),
  deepening(
    id: 'deepening',
    label: 'Deepening',
    description: 'Participates in ceremonies.',
    wordThreshold: 600,
  ),
  fluent(
    id: 'fluent',
    label: 'Fluent',
    description: 'Conducts all daily and tribal business.',
    wordThreshold: 800,
  ),
  ancestralMastery(
    id: 'ancestral_mastery',
    label: 'Ancestral Mastery',
    description: 'Teaches and creates new respectful content (elder verified).',
    wordThreshold: 1000,
  );

  const MasteryStage({
    required this.id,
    required this.label,
    required this.description,
    required this.wordThreshold,
  });

  final String id;
  final String label;
  final String description;
  final int wordThreshold;

  static MasteryStage fromId(String id) {
    return MasteryStage.values.firstWhere(
      (s) => s.id == id,
      orElse: () => MasteryStage.awakening,
    );
  }

  static MasteryStage forWordCount(int count) {
    var result = MasteryStage.awakening;
    for (final stage in MasteryStage.values) {
      if (count >= stage.wordThreshold) result = stage;
    }
    return result;
  }
}