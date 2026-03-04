class Game {
  final String id;
  final DateTime createdAt;
  final int currentQuestionSequence;
  final bool isAnswerRevealed;
  final String phase; // 'lobby' | 'quiz' | 'result'
  final String quizSetId;
  final String? hostUserId;

  const Game({
    required this.id,
    required this.createdAt,
    required this.currentQuestionSequence,
    required this.isAnswerRevealed,
    required this.phase,
    required this.quizSetId,
    this.hostUserId,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      currentQuestionSequence: json['current_question_sequence'] as int,
      isAnswerRevealed: json['is_answer_revealed'] as bool,
      phase: json['phase'] as String,
      quizSetId: json['quiz_set_id'] as String,
      hostUserId: json['host_user_id'] as String?,
    );
  }
}
