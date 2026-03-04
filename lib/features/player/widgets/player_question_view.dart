import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants.dart';
import '../../../models/game.dart';
import '../../../models/question.dart';
import '../../../models/choice.dart';
import '../../../models/participant.dart';
import '../../../providers/quiz_providers.dart';
import '../../../providers/realtime_providers.dart';
import '../../shared/widgets/answer_button.dart';
import '../../shared/widgets/countdown_timer_widget.dart';

class PlayerQuestionView extends ConsumerStatefulWidget {
  final Game game;
  final Participant participant;

  const PlayerQuestionView({
    super.key,
    required this.game,
    required this.participant,
  });

  @override
  ConsumerState<PlayerQuestionView> createState() => _PlayerQuestionViewState();
}

class _PlayerQuestionViewState extends ConsumerState<PlayerQuestionView> {
  bool _hasShownChoices = false;
  Choice? _chosenChoice;
  DateTime? _questionStartTime;
  bool _submitted = false;
  int? _score;
  int _lastQuestionSequence = -1;

  Game get game => widget.game;

  @override
  void didUpdateWidget(PlayerQuestionView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.game.currentQuestionSequence !=
        oldWidget.game.currentQuestionSequence) {
      setState(() {
        _hasShownChoices = false;
        _chosenChoice = null;
        _questionStartTime = null;
        _submitted = false;
        _score = null;
      });
    }
  }

  void _onChoiceRevealComplete() {
    if (mounted) {
      setState(() {
        _hasShownChoices = true;
        _questionStartTime = DateTime.now();
      });
    }
  }

  Future<void> _selectChoice(Choice choice, String questionId) async {
    if (_submitted || _chosenChoice != null) return;

    final elapsed =
        DateTime.now().difference(_questionStartTime!).inMilliseconds;
    final score = !choice.isCorrect
        ? 0
        : 1000 -
            (((elapsed / kQuestionAnswerTime).clamp(0.0, 1.0)) * 1000)
                .round();

    setState(() {
      _chosenChoice = choice;
      _submitted = true;
      _score = score;
    });

    await ref.read(answerRepositoryProvider).submitAnswer(
          participantId: widget.participant.id,
          questionId: questionId,
          choiceId: choice.id,
          score: score,
        );
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsProvider(game.quizSetId));

    return questionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (questions) {
        if (game.currentQuestionSequence >= questions.length) {
          return const Center(child: Text('Waiting...'));
        }

        if (_lastQuestionSequence != game.currentQuestionSequence) {
          _lastQuestionSequence = game.currentQuestionSequence;
        }

        final question = questions[game.currentQuestionSequence];
        return _buildQuestionView(question);
      },
    );
  }

  Widget _buildQuestionView(Question question) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Timer
              if (!game.isAnswerRevealed && !_submitted)
                if (!_hasShownChoices)
                  CountdownTimerWidget(
                    key: ValueKey(
                        'p-reveal-${game.currentQuestionSequence}'),
                    durationMs: kTimeTilChoiceReveal,
                    onComplete: _onChoiceRevealComplete,
                  )
                else
                  CountdownTimerWidget(
                    key: ValueKey(
                        'p-answer-${game.currentQuestionSequence}'),
                    durationMs: kQuestionAnswerTime,
                  ),
              const SizedBox(height: 16),

              // Question
              Text(
                question.body,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // State: waiting for reveal, choosing, submitted, or revealed
              if (game.isAnswerRevealed && _chosenChoice != null) ...[
                // Feedback after reveal
                Icon(
                  _chosenChoice!.isCorrect
                      ? Icons.check_circle
                      : Icons.cancel,
                  size: 64,
                  color:
                      _chosenChoice!.isCorrect ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 8),
                Text(
                  _chosenChoice!.isCorrect ? 'Correct!' : 'Incorrect',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: _chosenChoice!.isCorrect
                            ? Colors.green
                            : Colors.red,
                      ),
                ),
                if (_score != null)
                  Text(
                    '+$_score points',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
              ] else if (game.isAnswerRevealed && _chosenChoice == null) ...[
                const Icon(Icons.timer_off, size: 64, color: Colors.orange),
                const SizedBox(height: 8),
                Text(
                  "Time's up!",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ] else if (_submitted) ...[
                const Icon(Icons.hourglass_top,
                    size: 64, color: Colors.blue),
                const SizedBox(height: 8),
                Text(
                  'Answer submitted! Waiting for others...',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ] else if (_hasShownChoices) ...[
                // Show choice buttons in 2x2 grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.5,
                  children: List.generate(question.choices.length, (i) {
                    final choice = question.choices[i];
                    return AnswerButton(
                      text: choice.body,
                      color: kAnswerColors[i % kAnswerColors.length],
                      onPressed: () => _selectChoice(choice, question.id),
                    );
                  }),
                ),
              ] else ...[
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Get ready...'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
