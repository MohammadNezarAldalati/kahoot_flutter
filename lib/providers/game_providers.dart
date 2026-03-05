import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/supabase_client.dart';
import '../models/game.dart';
import '../repositories/game_repository.dart';

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepository(ref.watch(supabaseClientProvider));
});

final gameStreamProvider = StreamProvider.family<Game, String>((ref, gameId) {
  return ref.watch(gameRepositoryProvider).watchGame(gameId);
});

class HostGameController extends AsyncNotifier<void> {
  HostGameController(this.gameId);

  final String gameId;

  @override
  void build() {}

  Future<void> startGame() async {
    await ref.read(gameRepositoryProvider).updatePhase(gameId, 'quiz');
  }

  Future<void> revealAnswer() async {
    await ref.read(gameRepositoryProvider).revealAnswer(gameId);
  }

  Future<void> nextQuestion(int nextSequence, int totalQuestions) async {
    if (nextSequence >= totalQuestions) {
      await ref.read(gameRepositoryProvider).updatePhase(gameId, 'result');
    } else {
      await ref.read(gameRepositoryProvider).nextQuestion(gameId, nextSequence);
    }
  }
}

class GameInitializationController extends AsyncNotifier<String?> {
  GameInitializationController(this.quizSetId);

  final String quizSetId;

  void create() async {
    final game = await ref.read(gameRepositoryProvider).createGame(quizSetId);
    state = AsyncData(game.id);
  }

  @override
  Future<String?> build() async => null;
}

final hostGameControllerProvider = AsyncNotifierProvider.family
    .autoDispose<HostGameController, void, String>(HostGameController.new);

final initGameControllerProvider = AsyncNotifierProvider.family
    .autoDispose<GameInitializationController, String?, String>(
      GameInitializationController.new,
    );
