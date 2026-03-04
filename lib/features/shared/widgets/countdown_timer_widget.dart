import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  final int durationMs;
  final VoidCallback? onComplete;
  final bool paused;

  const CountdownTimerWidget({
    super.key,
    required this.durationMs,
    this.onComplete,
    this.paused = false,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late DateTime _startTime;
  Timer? _timer;
  double _progress = 1.0;
  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _secondsLeft = (widget.durationMs / 1000).ceil();
    if (!widget.paused) _startTimer();
  }

  @override
  void didUpdateWidget(CountdownTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.paused && !widget.paused) {
      _startTime = DateTime.now();
      _startTimer();
    } else if (!oldWidget.paused && widget.paused) {
      _timer?.cancel();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final elapsed =
          DateTime.now().difference(_startTime).inMilliseconds;
      final remaining = widget.durationMs - elapsed;
      if (remaining <= 0) {
        _timer?.cancel();
        setState(() {
          _progress = 0;
          _secondsLeft = 0;
        });
        widget.onComplete?.call();
      } else {
        setState(() {
          _progress = remaining / widget.durationMs;
          _secondsLeft = (remaining / 1000).ceil();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: _progress,
            strokeWidth: 6,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation(
              _secondsLeft <= 5 ? Colors.red : Colors.white,
            ),
          ),
          Center(
            child: Text(
              '$_secondsLeft',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _secondsLeft <= 5 ? Colors.red : null,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
