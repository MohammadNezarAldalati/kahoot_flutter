import 'package:flutter/material.dart';
import '../../../models/game_result.dart';

class LeaderboardWidget extends StatelessWidget {
  final List<GameResult> results;

  const LeaderboardWidget({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        final rank = index + 1;
        final isTop3 = rank <= 3;

        return Card(
          color: isTop3 ? _podiumColor(rank) : null,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isTop3 ? Colors.white24 : null,
              child: Text(
                '$rank',
                style: TextStyle(
                  fontWeight: isTop3 ? FontWeight.bold : FontWeight.normal,
                  fontSize: isTop3 ? 20 : 16,
                ),
              ),
            ),
            title: Text(
              result.nickname,
              style: TextStyle(
                fontWeight: isTop3 ? FontWeight.bold : FontWeight.normal,
                fontSize: isTop3 ? 20 : 16,
              ),
            ),
            trailing: Text(
              '${result.totalScore} pts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isTop3 ? 20 : 16,
              ),
            ),
          ),
        );
      },
    );
  }

  Color _podiumColor(int rank) {
    return switch (rank) {
      1 => const Color(0xFFFFD700), // Gold
      2 => const Color(0xFFC0C0C0), // Silver
      3 => const Color(0xFFCD7F32), // Bronze
      _ => Colors.transparent,
    };
  }
}
