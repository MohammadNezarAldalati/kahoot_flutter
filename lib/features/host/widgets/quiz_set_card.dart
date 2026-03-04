import 'package:flutter/material.dart';
import '../../../models/quiz_set.dart';

class QuizSetCard extends StatelessWidget {
  final QuizSet quizSet;
  final VoidCallback onStartGame;

  const QuizSetCard({
    super.key,
    required this.quizSet,
    required this.onStartGame,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quizSet.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (quizSet.description != null) ...[
              const SizedBox(height: 4),
              Text(
                quizSet.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 8),
            Text(
              '${quizSet.questions.length} questions',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: onStartGame,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Game'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
