import 'package:flutter/material.dart';

import 'package:client/screens/login_screen.dart';
import 'package:client/app/locator.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConnectDU',
      theme: ThemeData(),
      home: LoginScreen(),
    );
  }
}