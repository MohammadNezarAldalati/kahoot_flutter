import 'package:flutter/material.dart';

class PlayerResultsView extends StatelessWidget {
  const PlayerResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.celebration, size: 80, color: Colors.amber),
          const SizedBox(height: 24),
          Text(
            'Thanks for playing!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Check the host screen for the leaderboard.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
