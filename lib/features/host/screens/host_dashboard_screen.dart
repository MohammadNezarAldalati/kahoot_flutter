import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rwg_brainhub/constants.dart';
import 'package:rwg_brainhub/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../providers/quiz_providers.dart';
import '../widgets/quiz_set_card.dart';

class HostDashboardScreen extends ConsumerWidget {
  const HostDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizSetsAsync = ref.watch(quizSetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        actions: [
          if (authNotifier.isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              tooltip: 'Admin',
              onPressed: () => context.go('/host/admin'),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
          ),
        ],
      ),
      body: quizSetsAsync.when(
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
                  return QuizSetCard(quizSet: quizSets[index]);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
