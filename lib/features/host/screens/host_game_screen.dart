import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/game_providers.dart';
import '../widgets/host_lobby_view.dart';
import '../widgets/host_question_view.dart';
import '../widgets/host_results_view.dart';

class HostGameScreen extends ConsumerWidget {
  final String gameId;

  const HostGameScreen({super.key, required this.gameId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(gameStreamProvider(gameId));

    return Scaffold(
      body: gameAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (game) {
          return switch (game.phase) {
            'lobby' => HostLobbyView(gameId: gameId),
            'quiz' => HostQuestionView(game: game),
            'result' => HostResultsView(gameId: gameId),
            _ => Center(child: Text('Unknown phase: ${game.phase}')),
          };
        },
      ),
    );
  }
}
