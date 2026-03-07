class Participant {
  final String id;
  final DateTime createdAt;
  final String nickname;
  final String gameId;
  final String userId;

  const Participant({
    required this.id,
    required this.createdAt,
    required this.nickname,
    required this.gameId,
    required this.userId,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      nickname: json['nickname'] as String,
      gameId: json['game_id'] as String,
      userId: json['user_id'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'game_id': gameId,
      };
}
