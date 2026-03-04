import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/quiz_providers.dart';
import '../../../providers/game_providers.dart';
import '../widgets/quiz_set_card.dart';

class HostDashboardScreen extends ConsumerWidget {
  const HostDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(currentUserIdProvider);
    final quizSetsAsync = ref.watch(quizSetsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('SupaQuiz')),
      body: authAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Auth error: $e')),
        data: (_) => quizSetsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error loading quizzes: $e'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(quizSetsProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          data: (quizSets) {
            if (quizSets.isEmpty) {
              return const Center(
                child: Text('No quiz sets found. Add some in Supabase!'),
              );
            }
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: quizSets.length,
                  itemBuilder: (context, index) {
                    final quizSet = quizSets[index];
                    return QuizSetCard(
                      quizSet: quizSet,
                      onStartGame: () async {
                        try {
                          final gameId = await ref
                              .read(hostGameControllerProvider.notifier)
                              .createGame(quizSet.id);
                          if (context.mounted) {
                            context.go('/host/game/$gameId');
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
