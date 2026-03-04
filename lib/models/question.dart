import 'choice.dart';

class Question {
  final String id;
  final DateTime createdAt;
  final String body;
  final String? imageUrl;
  final int order;
  final String quizSetId;
  final List<Choice> choices;

  const Question({
    required this.id,
    required this.createdAt,
    required this.body,
    this.imageUrl,
    required this.order,
    required this.quizSetId,
    this.choices = const [],
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      body: json['body'] as String,
      imageUrl: json['image_url'] as String?,
      order: json['order'] as int,
      quizSetId: json['quiz_set_id'] as String,
      choices: (json['choices'] as List<dynamic>?)
              ?.map((c) => Choice.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
