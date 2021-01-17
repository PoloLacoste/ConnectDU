import 'dart:async';

import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  
  TimerWidget({
    @required this.date
  });

  final DateTime date;

  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<TimerWidget> {

  final _duration = Duration(seconds: 1);
  DateTime _date;

  @override
  void initState() { 
    super.initState();
    _date = widget.date;

    Timer.periodic(_duration, (timer) {
      setState(() {
        _date = _date.subtract(_duration);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String str = _formatDate(_date);
    bool canCollect = str == null;
    return Text(
      str ?? "Can collect !",
      style: TextStyle(
        color: canCollect ? Colors.green : null
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final collectDate = date.add(Duration(hours: 24));

    if(now.isBefore(collectDate)) {
      return "Can collect in ${date.hour}:${date.minute}:${date.second}";
    }

    return null;
  }
}