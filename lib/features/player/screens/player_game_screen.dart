import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/participant.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/game_providers.dart';
import '../../../providers/realtime_providers.dart';
import '../widgets/nickname_form.dart';
import '../widgets/player_waiting_view.dart';
import '../widgets/player_question_view.dart';
import '../widgets/player_results_view.dart';

class PlayerGameScreen extends ConsumerStatefulWidget {
  final String gameId;

  const PlayerGameScreen({super.key, required this.gameId});

  @override
  ConsumerState<PlayerGameScreen> createState() => _PlayerGameScreenState();
}

class _PlayerGameScreenState extends ConsumerState<PlayerGameScreen> {
  Participant? _participant;
  bool _checkingExisting = true;

  @override
  void initState() {
    super.initState();
    _checkExistingParticipant();
  }

  Future<void> _checkExistingParticipant() async {
    final userId = await ref.read(currentUserIdProvider.future);
    final existing = await ref
        .read(participantRepositoryProvider)
        .findParticipant(widget.gameId, userId);
    if (mounted) {
      setState(() {
        _participant = existing;
        _checkingExisting = false;
      });
    }
  }

  Future<void> _joinGame(String nickname) async {
    final participant = await ref
        .read(participantRepositoryProvider)
        .joinGame(widget.gameId, nickname);
    if (mounted) {
      setState(() => _participant = participant);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingExisting) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final participant = _participant;
    if (participant == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Join Game')),
        body: NicknameForm(onSubmit: _joinGame),
      );
    }

    final gameAsync = ref.watch(gameStreamProvider(widget.gameId));

    return Scaffold(
      body: gameAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (game) {
          return switch (game.phase) {
            'lobby' => PlayerWaitingView(nickname: participant.nickname),
            'quiz' => PlayerQuestionView(
                game: game,
                participant: participant,
              ),
            'result' => const PlayerResultsView(),
            _ => Center(child: Text('Unknown phase: ${game.phase}')),
          };
        },
      ),
    );
  }
}
