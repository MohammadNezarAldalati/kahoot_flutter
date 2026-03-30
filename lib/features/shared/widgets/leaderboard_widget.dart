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
          color: isTop3 ? _podiumColor(rank) : const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isTop3
                ? BorderSide(
                    color: _podiumColor(rank).withValues(alpha: 0.5),
                    width: 2,
                  )
                : BorderSide.none,
          ),
          elevation: isTop3 ? 8 : 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isTop3
                  ? Colors.white24
                  : const Color(0xFF7C4DFF).withValues(alpha: 0.3),
              child: isTop3
                  ? Icon(_trophyIcon(rank), color: textColor(rank), size: 24)
                  : Text(
                      '$rank',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
            title: Text(
              result.nickname,
              style: TextStyle(
                fontWeight: isTop3 ? FontWeight.bold : FontWeight.normal,
                fontSize: isTop3 ? 20 : 16,
                color: textColor(rank)
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${result.totalScore} pts',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isTop3 ? 20 : 16,
                  color: textColor(rank),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _trophyIcon(int rank) {
    return switch (rank) {
      1 => Icons.emoji_events,
      2 => Icons.workspace_premium,
      3 => Icons.military_tech,
      _ => Icons.tag,
    };
  }

  Color _podiumColor(int rank) {
    return switch (rank) {
      1 => const Color(0xFFFFD740), // Gold
      2 => const Color(0xFFB0BEC5), // Silver
      3 => const Color(0xFFFF8A65), // Bronze
      _ => Colors.transparent,
    };
  }

  Color textColor(int rank) {
    return switch (rank) {
      1 => Colors.grey, // Gold
      _ => Colors.white,
    };
  }
}
