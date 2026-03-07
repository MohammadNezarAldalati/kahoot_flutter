import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/supabase_client.dart';
import '../../../providers/quiz_providers.dart';
import '../../../repositories/quiz_repository.dart';
import '../widgets/delete_dialog.dart';

class QuestionListScreen extends ConsumerWidget {
  final String quizSetId;

  const QuestionListScreen({super.key, required this.quizSetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(questionsProvider(quizSetId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
        leading: BackButton(onPressed: () => context.go('/host/admin/quiz-sets')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/host/admin/quiz-sets/$quizSetId/questions/create'),
        child: const Icon(Icons.add),
      ),
      body: questionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (questions) {
          if (questions.isEmpty) {
            return const Center(child: Text('No questions yet.'));
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final q = questions[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${q.order + 1}')),
                      title: Text(q.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: Text('${q.choices.length} choices'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: 'Edit',
                            onPressed: () => context.go(
                              '/host/admin/quiz-sets/$quizSetId/questions/${q.id}',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Delete',
                            onPressed: () async {
                              final confirmed = await showDeleteDialog(context, 'question');
                              if (!confirmed || !context.mounted) return;
                              final repo = QuizRepository(ref.read(supabaseClientProvider));
                              await repo.deleteQuestion(q.id);
                              ref.invalidate(questionsProvider(quizSetId));
                            },
                          ),
                        ],
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
