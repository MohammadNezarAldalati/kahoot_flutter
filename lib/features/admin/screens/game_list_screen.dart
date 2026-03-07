import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/supabase_client.dart';
import '../../../providers/admin_providers.dart';
import '../../../repositories/game_repository.dart';
import '../widgets/delete_dialog.dart';

class GameListScreen extends ConsumerWidget {
  const GameListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesAsync = ref.watch(gamesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        leading: BackButton(onPressed: () => context.go('/host/admin')),
      ),
      body: gamesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (games) {
          if (games.isEmpty) {
            return const Center(child: Text('No games yet.'));
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final g = games[index];
                  return Card(
                    child: ListTile(
                      title: Text('Game ${g.id.substring(0, 8)}...'),
                      subtitle: Text('Phase: ${g.phase} | Quiz: ${g.quizSetId.substring(0, 8)}...'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete',
                        onPressed: () async {
                          final confirmed = await showDeleteDialog(context, 'game');
                          if (!confirmed || !context.mounted) return;
                          final repo = GameRepository(ref.read(supabaseClientProvider));
                          await repo.deleteGame(g.id);
                          ref.invalidate(gamesListProvider);
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
