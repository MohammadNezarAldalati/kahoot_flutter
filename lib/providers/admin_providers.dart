import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/supabase_client.dart';
import '../models/answer.dart';
import '../models/game.dart';
import '../models/participant.dart';
import '../repositories/answer_repository.dart';
import '../repositories/game_repository.dart';
import '../repositories/participant_repository.dart';

final gamesListProvider = FutureProvider<List<Game>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return GameRepository(client).getGames();
});

final allParticipantsProvider = FutureProvider<List<Participant>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ParticipantRepository(client).getAllParticipants();
});

final allAnswersProvider = FutureProvider<List<Answer>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AnswerRepository(client).getAllAnswers();
});
