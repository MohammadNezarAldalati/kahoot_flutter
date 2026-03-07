import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        leading: BackButton(onPressed: () => context.go('/host/dashboard')),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _NavCard(
                icon: Icons.quiz,
                title: 'Quiz Sets',
                subtitle: 'Create, edit, and delete quiz sets and questions',
                onTap: () => context.go('/host/admin/quiz-sets'),
              ),
              _NavCard(
                icon: Icons.sports_esports,
                title: 'Games',
                subtitle: 'View and delete games',
                onTap: () => context.go('/host/admin/games'),
              ),
              _NavCard(
                icon: Icons.people,
                title: 'Participants',
                subtitle: 'View and delete participants',
                onTap: () => context.go('/host/admin/participants'),
              ),
              _NavCard(
                icon: Icons.question_answer,
                title: 'Answers',
                subtitle: 'View and delete answers',
                onTap: () => context.go('/host/admin/answers'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
