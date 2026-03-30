import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../../../core/supabase_client.dart';
import '../../../models/game_result.dart';
import '../../../repositories/game_results_repository.dart';
import '../../shared/widgets/leaderboard_widget.dart';

final _gameResultsProvider =
    FutureProvider.family<List<GameResult>, String>((ref, gameId) {
  final client = ref.watch(supabaseClientProvider);
  return GameResultsRepository(client).getResults(gameId);
});

class HostResultsView extends ConsumerStatefulWidget {
  final String gameId;

  const HostResultsView({super.key, required this.gameId});

  @override
  ConsumerState<HostResultsView> createState() => _HostResultsViewState();
}

class _HostResultsViewState extends ConsumerState<HostResultsView> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(_gameResultsProvider(widget.gameId));

    return Stack(
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Leaderboard',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: resultsAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: $e')),
                      data: (results) {
                        if (results.isEmpty) {
                          return const Center(
                              child: Text('No results yet'));
                        }
                        return LeaderboardWidget(results: results);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.purple,
              Colors.orange,
              Colors.pink,
            ],
          ),
        ),
      ],
    );
  }
}
