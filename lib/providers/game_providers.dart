import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/supabase_client.dart';
import '../models/game.dart';
import '../repositories/game_repository.dart';

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepository(ref.watch(supabaseClientProvider));
});

final gameStreamProvider =
    StreamProvider.family<Game, String>((ref, gameId) {
  return ref.watch(gameRepositoryProvider).watchGame(gameId);
});

class HostGameController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<String> createGame(String quizSetId) async {
    state = const AsyncValue.loading();
    try {
      final game =
          await ref.read(gameRepositoryProvider).createGame(quizSetId);
      state = const AsyncValue.data(null);
      return game.id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> startGame(String gameId) async {
    await ref.read(gameRepositoryProvider).updatePhase(gameId, 'quiz');
  }

  Future<void> revealAnswer(String gameId) async {
    await ref.read(gameRepositoryProvider).revealAnswer(gameId);
  }

  Future<void> nextQuestion(
      String gameId, int nextSequence, int totalQuestions) async {
    if (nextSequence >= totalQuestions) {
      await ref.read(gameRepositoryProvider).updatePhase(gameId, 'result');
    } else {
      await ref.read(gameRepositoryProvider).nextQuestion(gameId, nextSequence);
    }
  }
}

final hostGameControllerProvider =
    NotifierProvider<HostGameController, AsyncValue<void>>(
        HostGameController.new);
