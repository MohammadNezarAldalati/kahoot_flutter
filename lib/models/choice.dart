class Choice {
  final String id;
  final DateTime createdAt;
  final String questionId;
  final String body;
  final bool isCorrect;

  const Choice({
    required this.id,
    required this.createdAt,
    required this.questionId,
    required this.body,
    required this.isCorrect,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      questionId: json['question_id'] as String,
      body: json['body'] as String,
      isCorrect: json['is_correct'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'question_id': questionId,
        'body': body,
        'is_correct': isCorrect,
      };
}
