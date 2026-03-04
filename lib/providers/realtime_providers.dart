import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/supabase_client.dart';
import '../models/participant.dart';
import '../models/answer.dart';
import '../repositories/participant_repository.dart';
import '../repositories/answer_repository.dart';

final participantRepositoryProvider = Provider<ParticipantRepository>((ref) {
  return ParticipantRepository(ref.watch(supabaseClientProvider));
});

final answerRepositoryProvider = Provider<AnswerRepository>((ref) {
  return AnswerRepository(ref.watch(supabaseClientProvider));
});

final participantsStreamProvider =
    StreamProvider.family<List<Participant>, String>((ref, gameId) {
  return ref.watch(participantRepositoryProvider).watchParticipants(gameId);
});

final answersStreamProvider =
    StreamProvider.family<List<Answer>, String>((ref, questionId) {
  return ref.watch(answerRepositoryProvider).watchAnswersForQuestion(questionId);
});
