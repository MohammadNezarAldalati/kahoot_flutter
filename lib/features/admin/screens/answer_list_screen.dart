import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/supabase_client.dart';
import '../../../providers/admin_providers.dart';
import '../../../repositories/answer_repository.dart';
import '../widgets/delete_dialog.dart';

class AnswerListScreen extends ConsumerWidget {
  const AnswerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answersAsync = ref.watch(allAnswersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Answers'),
        leading: BackButton(onPressed: () => context.go('/host/admin')),
      ),
      body: answersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (answers) {
          if (answers.isEmpty) {
            return const Center(child: Text('No answers yet.'));
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: answers.length,
                itemBuilder: (context, index) {
                  final a = answers[index];
                  return Card(
                    child: ListTile(
                      title: Text('Score: ${a.score}'),
                      subtitle: Text(
                        'Participant: ${a.participantId.substring(0, 8)}... | '
                        'Question: ${a.questionId.substring(0, 8)}...',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete',
                        onPressed: () async {
                          final confirmed = await showDeleteDialog(context, 'answer');
                          if (!confirmed || !context.mounted) return;
                          final repo = AnswerRepository(ref.read(supabaseClientProvider));
                          await repo.deleteAnswer(a.id);
                          ref.invalidate(allAnswersProvider);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
