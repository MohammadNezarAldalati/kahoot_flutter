import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/game.dart';

class GameRepository {
  final SupabaseClient _client;

  GameRepository(this._client);

  Future<Game> createGame(String quizSetId) async {
    final data = await _client
        .from('games')
        .insert({'quiz_set_id': quizSetId})
        .select()
        .single();
    return Game.fromJson(data);
  }

  Future<Game> getGame(String gameId) async {
    final data =
        await _client.from('games').select().eq('id', gameId).single();
    return Game.fromJson(data);
  }

  Stream<Game> watchGame(String gameId) {
    return _client
        .from('games')
        .stream(primaryKey: ['id'])
        .eq('id', gameId)
        .map((rows) => Game.fromJson(rows.first));
  }

  Future<void> updatePhase(String gameId, String phase) async {
    await _client.from('games').update({'phase': phase}).eq('id', gameId);
  }

  Future<void> revealAnswer(String gameId) async {
    await _client
        .from('games')
        .update({'is_answer_revealed': true}).eq('id', gameId);
  }

  Future<void> nextQuestion(String gameId, int nextSequence) async {
    await _client.from('games').update({
      'current_question_sequence': nextSequence,
      'is_answer_revealed': false,
    }).eq('id', gameId);
  }
}
