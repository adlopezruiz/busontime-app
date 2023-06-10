import 'dart:async';

import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({
    super.key,
    required this.targetTime,
    required this.textStyle,
  });

  final String targetTime;
  final TextStyle textStyle;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late int _secondsRemaining;

  @override
  void initState() {
    super.initState();
    final separatedParts = widget.targetTime.split(':');
    final hour = int.parse(separatedParts[0]);
    final minutes = int.parse(separatedParts[1]);

    final now = DateTime.now();
    final targetTimeDateTime =
        DateTime(now.year, now.month, now.day, hour, minutes);

    final difference = targetTimeDateTime.difference(now);
    _secondsRemaining = difference.inSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours > 0) {
      return "${hours.toString().padLeft(2, '0')} h ${minutes.toString().padLeft(2, '0')} m";
    } else {
      return "${minutes.toString().padLeft(2, '0')} minutos";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatTime(_secondsRemaining),
      style: widget.textStyle,
    );
  }
}
