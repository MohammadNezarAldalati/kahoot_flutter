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
        ? (correct ? Colors.green : color.withValues(alpha: 0.3))
        : color;

    return SizedBox(
      height: 80,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: selected
                ? const BorderSide(color: Colors.white, width: 3)
                : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (showResult && correct)
              const Icon(Icons.check_circle, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
