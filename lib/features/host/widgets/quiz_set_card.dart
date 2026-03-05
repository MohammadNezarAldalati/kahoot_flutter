import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rwg_brainhub/providers/game_providers.dart';
import '../../../models/quiz_set.dart';

class QuizSetCard extends ConsumerWidget {
  final QuizSet quizSet;

  const QuizSetCard({super.key, required this.quizSet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(initGameControllerProvider(quizSet.id), (prev, next) {
      switch (next) {
        case AsyncValue(:final value, hasValue: true):
          if (value == null) return;
          if (context.mounted) {
            context.go('/host/game/$value');
          }
        case AsyncError e:
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: $e')));
          }
        case _:
      }
    });
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(quizSet.name, style: Theme.of(context).textTheme.titleLarge),
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
                onPressed: () {
                  ref
                      .read(initGameControllerProvider(quizSet.id).notifier)
                      .create();
                },
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
