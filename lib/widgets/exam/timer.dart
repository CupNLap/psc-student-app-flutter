import 'dart:async';

import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final int minutes;
  final Function() onTimerOver;

  const TimerWidget({
    required this.minutes,
    required this.onTimerOver,
    Key? key,
  }) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration _duration = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _setDuration();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setDuration() {
    setState(() {
      _duration = Duration(minutes: widget.minutes);
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_duration.inSeconds > 0) {
          _duration -= Duration(seconds: 1);
        } else {
          _timer?.cancel();
          widget.onTimerOver();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = _duration.inMinutes.toString().padLeft(2, '0');
    String secondsStr = (_duration.inSeconds % 60).toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: TextStyle(fontSize: 36),
    );
  }
}
