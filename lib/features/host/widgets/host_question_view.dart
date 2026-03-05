import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants.dart';
import '../../../models/game.dart';
import '../../../models/question.dart';
import '../../../providers/game_providers.dart';
import '../../../providers/quiz_providers.dart';
import '../../../providers/realtime_providers.dart';
import '../../shared/widgets/answer_button.dart';
import '../../shared/widgets/countdown_timer_widget.dart';
import 'answer_distribution_chart.dart';

class HostQuestionView extends ConsumerStatefulWidget {
  final Game game;

  const HostQuestionView({super.key, required this.game});

  @override
  ConsumerState<HostQuestionView> createState() => _HostQuestionViewState();
}

class _HostQuestionViewState extends ConsumerState<HostQuestionView> {
  bool _hasShownChoices = false;
  bool _timerExpired = false;

  // Track the question sequence to reset state on question change
  int _lastQuestionSequence = -1;

  Game get game => widget.game;

  @override
  void didUpdateWidget(HostQuestionView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.game.currentQuestionSequence !=
        oldWidget.game.currentQuestionSequence) {
      setState(() {
        _hasShownChoices = false;
        _timerExpired = false;
      });
    }
  }

  void _onChoiceRevealComplete() {
    if (mounted) setState(() => _hasShownChoices = true);
  }

  void _onTimerExpired() {
    if (mounted && !game.isAnswerRevealed) {
      setState(() => _timerExpired = true);
      ref.read(hostGameControllerProvider(game.id).notifier).revealAnswer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(questionsProvider(game.quizSetId));

    return questionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (questions) {
        if (game.currentQuestionSequence >= questions.length) {
          return const Center(child: Text('No more questions'));
        }

        // Reset state when question changes
        if (_lastQuestionSequence != game.currentQuestionSequence) {
          _lastQuestionSequence = game.currentQuestionSequence;
          // State reset happens in didUpdateWidget
        }

        final question = questions[game.currentQuestionSequence];
        return _buildQuestionView(question, questions.length);
      },
    );
  }

  Widget _buildQuestionView(Question question, int totalQuestions) {
    final answersAsync = ref.watch(answersStreamProvider(question.id));
    final participantsAsync = ref.watch(participantsStreamProvider(game.id));

    final answerCount = answersAsync.value?.length ?? 0;
    final participantCount = participantsAsync.value?.length ?? 0;

    // Auto-reveal when all participants answered
    if (answerCount > 0 &&
        participantCount > 0 &&
        answerCount >= participantCount &&
        !game.isAnswerRevealed &&
        !_timerExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(hostGameControllerProvider(game.id).notifier).revealAnswer();
      });
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header: question number + timer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${game.currentQuestionSequence + 1} of $totalQuestions',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (!game.isAnswerRevealed)
                    if (!_hasShownChoices)
                      CountdownTimerWidget(
                        key: ValueKey('reveal-${game.currentQuestionSequence}'),
                        durationMs: kTimeTilChoiceReveal,
                        onComplete: _onChoiceRevealComplete,
                      )
                    else
                      CountdownTimerWidget(
                        key: ValueKey('answer-${game.currentQuestionSequence}'),
                        durationMs: kQuestionAnswerTime,
                        onComplete: _onTimerExpired,
                      ),
                ],
              ),
              const SizedBox(height: 24),

              // Question body
              Text(
                question.body,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Answer count
              Text(
                '$answerCount / $participantCount answered',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),

              // Choices or chart
              if (game.isAnswerRevealed) ...[
                AnswerDistributionChart(
                  choices: question.choices,
                  answers: answersAsync.value ?? [],
                ),
                const SizedBox(height: 24),
                // Answer buttons showing correct/incorrect
                ...List.generate(question.choices.length, (i) {
                  final choice = question.choices[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AnswerButton(
                      text: choice.body,
                      color: kAnswerColors[i % kAnswerColors.length],
                      showResult: true,
                      correct: choice.isCorrect,
                    ),
                  );
                }),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .read(hostGameControllerProvider(game.id).notifier)
                        .nextQuestion(
                          game.currentQuestionSequence + 1,
                          totalQuestions,
                        );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(
                    game.currentQuestionSequence + 1 >= totalQuestions
                        ? 'Show Results'
                        : 'Next Question',
                  ),
                ),
              ] else if (_hasShownChoices) ...[
                // Show choices (read-only for host)
                ...List.generate(question.choices.length, (i) {
                  final choice = question.choices[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AnswerButton(
                      text: choice.body,
                      color: kAnswerColors[i % kAnswerColors.length],
                    ),
                  );
                }),
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
