import 'question.dart';

class QuizSet {
  final String id;
  final DateTime createdAt;
  final String name;
  final String? description;
  final List<Question> questions;

  const QuizSet({
    required this.id,
    required this.createdAt,
    required this.name,
    this.description,
    this.questions = const [],
  });

  factory QuizSet.fromJson(Map<String, dynamic> json) {
    return QuizSet(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      name: json['name'] as String,
      description: json['description'] as String?,
      questions: (json['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromJson(q as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
