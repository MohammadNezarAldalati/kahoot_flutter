import 'package:flutter/material.dart';

class PlayerWaitingView extends StatelessWidget {
  final String nickname;

  const PlayerWaitingView({super.key, required this.nickname});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.hourglass_top, size: 64),
          const SizedBox(height: 24),
          Text(
            'Welcome, $nickname!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Waiting for the host to start the game...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
