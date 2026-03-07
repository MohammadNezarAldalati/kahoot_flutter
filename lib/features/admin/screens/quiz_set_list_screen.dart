import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/quiz_providers.dart';
import '../../../repositories/quiz_repository.dart';
import '../../../core/supabase_client.dart';
import '../widgets/delete_dialog.dart';

class QuizSetListScreen extends ConsumerWidget {
  const QuizSetListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizSetsAsync = ref.watch(quizSetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Sets'),
        leading: BackButton(onPressed: () => context.go('/host/admin')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/host/admin/quiz-sets/create'),
        child: const Icon(Icons.add),
      ),
      body: quizSetsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (quizSets) {
          if (quizSets.isEmpty) {
            return const Center(child: Text('No quiz sets yet.'));
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: quizSets.length,
                itemBuilder: (context, index) {
                  final qs = quizSets[index];
                  return Card(
                    child: ListTile(
                      title: Text(qs.name),
                      subtitle: Text(
                        qs.description ?? 'No description',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.list),
                            tooltip: 'Questions',
                            onPressed: () => context.go('/host/admin/quiz-sets/${qs.id}/questions'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: 'Edit',
                            onPressed: () => context.go('/host/admin/quiz-sets/${qs.id}'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Delete',
                            onPressed: () async {
                              final confirmed = await showDeleteDialog(context, 'quiz set');
                              if (!confirmed || !context.mounted) return;
                              final repo = QuizRepository(ref.read(supabaseClientProvider));
                              await repo.deleteQuizSet(qs.id);
                              ref.invalidate(quizSetsProvider);
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
