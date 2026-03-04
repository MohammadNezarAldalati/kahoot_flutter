import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/game_result.dart';

class GameResultsRepository {
  final SupabaseClient _client;

  GameResultsRepository(this._client);

  Future<List<GameResult>> getResults(String gameId) async {
    final data = await _client
        .from('game_results')
        .select()
        .eq('game_id', gameId)
        .order('total_score', ascending: false);
    return data.map((json) => GameResult.fromJson(json)).toList();
  }
}
