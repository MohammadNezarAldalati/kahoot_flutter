import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quiz_set.dart';
import '../models/question.dart';
import '../models/choice.dart';

class QuizRepository {
  final SupabaseClient _client;

  QuizRepository(this._client);

  Future<List<QuizSet>> getQuizSets() async {
    final data = await _client
        .from('quiz_sets')
        .select('*, questions(*, choices(*))')
        .order('created_at');
    return data.map((json) => QuizSet.fromJson(json)).toList();
  }

  Future<QuizSet> getQuizSet(String id) async {
    final data = await _client
        .from('quiz_sets')
        .select('*, questions(*, choices(*))')
        .eq('id', id)
        .order('order', referencedTable: 'questions')
        .single();
    return QuizSet.fromJson(data);
  }

  Future<List<Question>> getQuestions(String quizSetId) async {
    final data = await _client
        .from('questions')
        .select('*, choices(*)')
        .eq('quiz_set_id', quizSetId)
        .order('order');
    return data.map((json) => Question.fromJson(json)).toList();
  }

  // Quiz Set CRUD

  Future<QuizSet> createQuizSet({
    required String name,
    String? description,
  }) async {
    final data = await _client
        .from('quiz_sets')
        .insert({'name': name, 'description': description})
        .select('*, questions(*, choices(*))')
        .single();
    return QuizSet.fromJson(data);
  }

  Future<void> updateQuizSet({
    required String id,
    required String name,
    String? description,
  }) async {
    await _client
        .from('quiz_sets')
        .update({'name': name, 'description': description}).eq('id', id);
  }

  Future<void> deleteQuizSet(String id) async {
    await _client.from('quiz_sets').delete().eq('id', id);
  }

  // Question CRUD

  Future<Question> createQuestion({
    required String quizSetId,
    required String body,
    required int order,
    String? imageUrl,
  }) async {
    final data = await _client.from('questions').insert({
      'quiz_set_id': quizSetId,
      'body': body,
      'order': order,
      'image_url': imageUrl,
    }).select('*, choices(*)').single();
    return Question.fromJson(data);
  }

  Future<void> updateQuestion({
    required String id,
    required String body,
    required int order,
    String? imageUrl,
  }) async {
    await _client.from('questions').update({
      'body': body,
      'order': order,
      'image_url': imageUrl,
    }).eq('id', id);
  }

  Future<void> deleteQuestion(String id) async {
    await _client.from('questions').delete().eq('id', id);
  }

  // Choice CRUD

  Future<Choice> createChoice({
    required String questionId,
    required String body,
    required bool isCorrect,
  }) async {
    final data = await _client.from('choices').insert({
      'question_id': questionId,
      'body': body,
      'is_correct': isCorrect,
    }).select().single();
    return Choice.fromJson(data);
  }

  Future<void> updateChoice({
    required String id,
    required String body,
    required bool isCorrect,
  }) async {
    await _client.from('choices').update({
      'body': body,
      'is_correct': isCorrect,
    }).eq('id', id);
  }

  Future<void> deleteChoice(String id) async {
    await _client.from('choices').delete().eq('id', id);
  }

  /// Save a question with its choices in one transaction-like operation.
  /// For new questions, pass questionId as null.
  /// Deletes existing choices and re-inserts them.
  Future<void> saveQuestionWithChoices({
    String? questionId,
    required String quizSetId,
    required String body,
    required int order,
    String? imageUrl,
    required List<({String body, bool isCorrect})> choices,
  }) async {
    String qId;
    if (questionId == null) {
      final q = await createQuestion(
        quizSetId: quizSetId,
        body: body,
        order: order,
        imageUrl: imageUrl,
      );
      qId = q.id;
    } else {
      await updateQuestion(id: questionId, body: body, order: order, imageUrl: imageUrl);
      // Delete old choices
      await _client.from('choices').delete().eq('question_id', questionId);
      qId = questionId;
    }

    // Insert new choices
    if (choices.isNotEmpty) {
      await _client.from('choices').insert(
        choices
            .map((c) => {
                  'question_id': qId,
                  'body': c.body,
                  'is_correct': c.isCorrect,
                })
            .toList(),
      );
    }
  }
}
