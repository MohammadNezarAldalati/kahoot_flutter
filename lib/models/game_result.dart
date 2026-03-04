class GameResult {
  final String participantId;
  final String nickname;
  final int totalScore;
  final String gameId;

  const GameResult({
    required this.participantId,
    required this.nickname,
    required this.totalScore,
    required this.gameId,
  });

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      participantId: json['participant_id'] as String,
      nickname: json['nickname'] as String,
      totalScore: (json['total_score'] as num).toInt(),
      gameId: json['game_id'] as String,
    );
  }
}
