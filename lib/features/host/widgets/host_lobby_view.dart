import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/game_providers.dart';
import '../../../providers/realtime_providers.dart';
import '../../shared/widgets/qr_code_display.dart';

class HostLobbyView extends ConsumerWidget {
  final String gameId;

  const HostLobbyView({super.key, required this.gameId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participantsAsync = ref.watch(participantsStreamProvider(gameId));

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Waiting for players',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            QrCodeDisplay(gameId: gameId),
            const SizedBox(height: 32),
            Text(
              'Players joined:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            participantsAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
              data: (participants) {
                if (participants.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No players yet...'),
                  );
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: participants
                      .map((p) => Chip(
                            avatar: const Icon(Icons.person, size: 18),
                            label: Text(p.nickname),
                          ))
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 32),
            participantsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (participants) => ElevatedButton.icon(
                onPressed: participants.isEmpty
                    ? null
                    : () => ref
                        .read(hostGameControllerProvider.notifier)
                        .startGame(gameId),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Quiz'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
