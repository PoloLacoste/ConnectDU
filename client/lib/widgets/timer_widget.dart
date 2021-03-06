import 'dart:async';

import 'package:client/providers/timer_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class TimerWidget extends StatefulWidget {
  
  TimerWidget({
    @required this.date,
  }) : super(key: GlobalKey());

  final double date;

  @override
  TimerState createState() => TimerState();
}

class TimerState extends State<TimerWidget> {

  final _duration = const Duration(seconds: 1);
  Timer _timer;
  DateTime _date;
  String _str;

  @override
  void initState() { 
    super.initState();
    _date = DateTime.fromMillisecondsSinceEpoch(widget.date.floor());
    _str = _formatDate(_date);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(_duration, (timer) {
      setState(() {
        _str = _formatDate(_date);
        if(_str == null) {
          context.read<TimerProvider>().canCollect = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool canCollect = _str == null;
    return Text(
      _str ?? "Can collect !",
      style: TextStyle(
        color: canCollect ? Colors.green : null
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final collectDate = date.add(Duration(hours: 24));

    final nowTs = now.millisecondsSinceEpoch / 1000;
    final collectTs = collectDate.millisecondsSinceEpoch / 1000;

    final diff = collectTs - nowTs;

    final hours = (diff / 3600).floor();
    final hourSeconds = (diff - hours * 3600);
    final minutes = (hourSeconds / 60).floor();
    final seconds = (hourSeconds - minutes * 60).floor();

    if(now.isBefore(collectDate) && !(hours == 0 && minutes == 0 && seconds == 0)) {
      return "Can collect in ${_formatInt(hours)}:${_formatInt(minutes)}:${_formatInt(seconds)}";
    }

    return null;
  }

  String _formatInt(int i) {
    return i < 10 ? "0$i" : "$i";
  }
}