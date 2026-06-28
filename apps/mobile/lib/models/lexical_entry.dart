class LexicalEntry {
  final String id;
  final String wordNarragansett;
  final String englishGloss;
  final String? culturalContextSummary;
  final String visibility;

  const LexicalEntry({
    required this.id,
    required this.wordNarragansett,
    required this.englishGloss,
    this.culturalContextSummary,
    this.visibility = 'clan',
  });

  factory LexicalEntry.fromJson(Map<String, dynamic> json) {
    return LexicalEntry(
      id: json['id'] as String,
      wordNarragansett: json['word_narragansett'] as String,
      englishGloss: json['english_gloss'] as String,
      culturalContextSummary: json['cultural_context_summary'] as String?,
      visibility: json['visibility'] as String? ?? 'clan',
    );
  }
}