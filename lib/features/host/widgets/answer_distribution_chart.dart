import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../constants.dart';
import '../../../models/choice.dart';
import '../../../models/answer.dart';

class AnswerDistributionChart extends StatelessWidget {
  final List<Choice> choices;
  final List<Answer> answers;

  const AnswerDistributionChart({
    super.key,
    required this.choices,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final choice in choices) {
      counts[choice.id] = 0;
    }
    for (final answer in answers) {
      if (answer.choiceId != null && counts.containsKey(answer.choiceId)) {
        counts[answer.choiceId!] = counts[answer.choiceId!]! + 1;
      }
    }

    final maxCount = counts.values.fold(0, (a, b) => a > b ? a : b);

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxCount > 0 ? maxCount.toDouble() : 1,
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= choices.length) {
                    return const SizedBox.shrink();
                  }
                  final choice = choices[idx];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (choice.isCorrect)
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            choice.body,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: List.generate(choices.length, (i) {
            final choice = choices[i];
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: (counts[choice.id] ?? 0).toDouble(),
                  color: kAnswerColors[i % kAnswerColors.length],
                  width: 40,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
