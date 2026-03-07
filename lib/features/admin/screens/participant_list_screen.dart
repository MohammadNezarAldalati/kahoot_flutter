import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/supabase_client.dart';
import '../../../providers/admin_providers.dart';
import '../../../repositories/participant_repository.dart';
import '../widgets/delete_dialog.dart';

class ParticipantListScreen extends ConsumerWidget {
  const ParticipantListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participantsAsync = ref.watch(allParticipantsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Participants'),
        leading: BackButton(onPressed: () => context.go('/host/admin')),
      ),
      body: participantsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (participants) {
          if (participants.isEmpty) {
            return const Center(child: Text('No participants yet.'));
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: participants.length,
                itemBuilder: (context, index) {
                  final p = participants[index];
                  return Card(
                    child: ListTile(
                      title: Text(p.nickname),
                      subtitle: Text('Game: ${p.gameId.substring(0, 8)}...'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Delete',
                        onPressed: () async {
                          final confirmed = await showDeleteDialog(context, 'participant');
                          if (!confirmed || !context.mounted) return;
                          final repo = ParticipantRepository(ref.read(supabaseClientProvider));
                          await repo.deleteParticipant(p.id);
                          ref.invalidate(allParticipantsProvider);
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
