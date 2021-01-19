import 'package:flutter/material.dart';

import 'package:common/common.dart';

import 'package:client/services/collect_service.dart';
import 'package:client/screens/login_screen.dart';
import 'package:client/widgets/timer_widget.dart';
import 'package:client/utils/dialogs.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _collectService = CollectService();

  @override
  void initState() { 
    super.initState();
    _collectService.collect().catchError((e) {
      print(e);
      showErrorDialog(context, "Failed to connect to the server," 
        " you are maybe already connected on this account", onTap: _goToLogin);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ConnectDU'),
      ),
      body: StreamBuilder(
        stream: _collectService.stream,
        builder: (context, AsyncSnapshot<List<Event>> snapshot) {
          if(snapshot.hasData) {
            final events = snapshot.data;

            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, i) {
                final event = events[i];
                return CheckboxListTile(
                  secondary: Icon(
                    Icons.person
                  ),
                  title: Text(
                    event.username
                  ),
                  subtitle: _buildSubtitle(event),
                  value: event.isCollected,
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

  Widget _buildSubtitle(Event event) {
    if(event.isCollected) {
      return TimerWidget(
        date: event.collected
      );
    }

    String msg = "No information";

    if(event.canCollect) {
      msg = "Can collect !";
    }

    return Text(
      msg,
      style: TextStyle(
        color: event.canCollect ? Colors.green : null
      )
    );
  }

  void _onChanged(Event event, bool value) {
    if(value) {
      event.collected = DateTime.now().millisecondsSinceEpoch.toDouble();
    }
    else {
      event.collected = -1;
    }
    
    final sent = _collectService.send(event);

    if(!sent) {
      showErrorDialog(context, 
        "You are disconnected from the server.\n"
        "Press ok to reconnect.",
        onTap: _goToLogin
      );
      return;
    }
  }

  void _goToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) => LoginScreen()
    ), (route) => route == null);
  }
}