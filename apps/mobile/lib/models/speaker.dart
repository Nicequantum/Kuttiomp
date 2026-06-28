class Speaker {
  final String id;
  final String displayName;
  final String role;
  final String generation;
  final bool isElder;
  final bool isTwoSpirit;

  const Speaker({
    required this.id,
    required this.displayName,
    required this.role,
    required this.generation,
    this.isElder = false,
    this.isTwoSpirit = false,
  });

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      role: json['role'] as String,
      generation: json['generation'] as String? ?? 'middle',
      isElder: json['is_elder'] as bool? ?? false,
      isTwoSpirit: json['is_two_spirit'] as bool? ?? false,
    );
  }
}