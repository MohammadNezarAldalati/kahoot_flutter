class Answer {
  final String id;
  final DateTime createdAt;
  final String participantId;
  final String questionId;
  final String? choiceId;
  final int score;

  const Answer({
    required this.id,
    required this.createdAt,
    required this.participantId,
    required this.questionId,
    this.choiceId,
    required this.score,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      participantId: json['participant_id'] as String,
      questionId: json['question_id'] as String,
      choiceId: json['choice_id'] as String?,
      score: json['score'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'participant_id': participantId,
        'question_id': questionId,
        'choice_id': choiceId,
        'score': score,
      };
}
