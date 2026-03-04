import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/answer.dart';

class AnswerRepository {
  final SupabaseClient _client;

  AnswerRepository(this._client);

  Future<void> submitAnswer({
    required String participantId,
    required String questionId,
    required String? choiceId,
    required int score,
  }) async {
    await _client.from('answers').insert({
      'participant_id': participantId,
      'question_id': questionId,
      'choice_id': choiceId,
      'score': score,
    });
  }

  Stream<List<Answer>> watchAnswersForQuestion(String questionId) {
    return _client
        .from('answers')
        .stream(primaryKey: ['id'])
        .eq('question_id', questionId)
        .map((rows) => rows.map((r) => Answer.fromJson(r)).toList());
  }
}
