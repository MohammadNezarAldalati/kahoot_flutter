import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quiz_set.dart';
import '../models/question.dart';

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
}
