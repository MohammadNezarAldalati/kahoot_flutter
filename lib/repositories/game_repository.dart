import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/game.dart';

class GameRepository {
  final SupabaseClient _client;

  GameRepository(this._client);

  Future<Game> createGame(String quizSetId) async {
    // Delete old finished games for this quiz set so stale answers don't
    // leak into the new game (answers query filters by questionId only).
    await _client
        .from('games')
        .delete()
        .eq('quiz_set_id', quizSetId)
        .eq('phase', 'result');

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

  Future<List<Game>> getGames() async {
    final data =
        await _client.from('games').select().order('created_at', ascending: false);
    return data.map((json) => Game.fromJson(json)).toList();
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

  Future<void> deleteGame(String id) async {
    await _client.from('games').delete().eq('id', id);
  }
}
