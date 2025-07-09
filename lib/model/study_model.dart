class Study {
  final String verse;
  final String studyText;
  final DateTime createdAt;

  Study({
    required this.verse,
    required this.studyText,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'verse': verse,
      'studyText': studyText,
      'createdAt': createdAt,
    };
  }
}
