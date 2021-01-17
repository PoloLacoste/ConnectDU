import 'package:flutter/material.dart';

import 'package:common/common.dart';

import 'package:client/services/collect_service.dart';
import 'package:client/widgets/timer_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _collectService = CollectService();

  final _players = <String, Event>{};
  List<Event> _events = [];

  @override
  void initState() { 
    super.initState();
    _collectService.collect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ConnectDU'),
      ),
      body: StreamBuilder(
        stream: _collectService.stream,
        builder: (context, AsyncSnapshot<Event> snapshot) {
          if(snapshot.hasData) {
            final event = snapshot.data;
            _players[event.username] = event;

            _events = _players.values.toList();

            return ListView.builder(
              itemCount: _players.length,
              itemBuilder: (context, i) {
                final event = _events[i];
                return CheckboxListTile(
                  secondary: Icon(
                    Icons.person
                  ),
                  title: Text(
                    event.username
                  ),
                  subtitle: TimerWidget(
                    date: event.date,
                  ),
                  value: event.collected,
                  onChanged: (value) => _onChanged(event, value),
                );
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }

  void _onChanged(Event event, bool value) {
    event.collected = value;
    if(value) {
      event.collectDate = DateTime.now().millisecondsSinceEpoch;
    }
    else {
      event.collectDate = -1;
    }
    _collectService.send(event);

    setState(() {
      _players[event.username] = event;
    });
  }
}