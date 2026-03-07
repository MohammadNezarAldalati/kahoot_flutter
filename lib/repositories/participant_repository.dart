import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/participant.dart';

class ParticipantRepository {
  final SupabaseClient _client;

  ParticipantRepository(this._client);

  Future<List<Participant>> getParticipants(String gameId) async {
    final data = await _client
        .from('participants')
        .select()
        .eq('game_id', gameId)
        .order('created_at');
    return data.map((json) => Participant.fromJson(json)).toList();
  }

  Future<List<Participant>> getAllParticipants() async {
    final data = await _client
        .from('participants')
        .select()
        .order('created_at', ascending: false);
    return data.map((json) => Participant.fromJson(json)).toList();
  }

  Stream<List<Participant>> watchParticipants(String gameId) {
    return _client
        .from('participants')
        .stream(primaryKey: ['id'])
        .eq('game_id', gameId)
        .order('created_at')
        .map((rows) => rows.map((r) => Participant.fromJson(r)).toList());
  }

  Future<Participant?> findParticipant(String gameId, String userId) async {
    final data = await _client
        .from('participants')
        .select()
        .eq('game_id', gameId)
        .eq('user_id', userId)
        .maybeSingle();
    return data != null ? Participant.fromJson(data) : null;
  }

  Future<Participant> joinGame(String gameId, String nickname) async {
    final data = await _client
        .from('participants')
        .insert({'game_id': gameId, 'nickname': nickname})
        .select()
        .single();
    return Participant.fromJson(data);
  }

  Future<void> deleteParticipant(String id) async {
    await _client.from('participants').delete().eq('id', id);
  }
}
