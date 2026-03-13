import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onPressed;
  final bool selected;
  final bool correct;
  final bool showResult;

  const AnswerButton({
    super.key,
    required this.text,
    required this.color,
    this.onPressed,
    this.selected = false,
    this.correct = false,
    this.showResult = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = showResult
        ? (correct ? const Color(0xFF00E676) : color.withValues(alpha: 0.25))
        : color;

    return SizedBox(
      height: 80,
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        elevation: selected ? 2 : 6,
        shadowColor: color.withValues(alpha: 0.5),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: selected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
              gradient: showResult
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color,
                        color.withValues(alpha: 0.7),
                      ],
                    ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (showResult && correct)
                  const Icon(Icons.check_circle, color: Colors.white, size: 28),
                if (showResult && !correct)
                  Icon(Icons.cancel, color: Colors.white.withValues(alpha: 0.5), size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
