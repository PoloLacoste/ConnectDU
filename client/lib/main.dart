import 'package:flutter/material.dart';

import 'package:client/screens/home_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConnectDU',
      theme: ThemeData(),
      home: HomeScreen(),
    );
  }
}