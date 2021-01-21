import 'package:flutter/material.dart';

import 'package:client/app/locator.dart';
import 'package:client/screens/settings_screen.dart';
import 'package:client/screens/home_screen.dart';
import 'package:client/utils/dialogs.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _settings = locator<SettingsService>();
  final _authService = locator<AuthService>();
  final _formKey = GlobalKey<FormState>();

  String _username, _password;

  @override
  void initState() { 
    super.initState();
    final username = _settings.username;
    if(username != null) {
      _username = username;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings
            ),
            onPressed: _goToSettings,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _username,
                  decoration: InputDecoration(
                    labelText: "Username"
                  ),
                  validator: (str) {
                    if(str.isEmpty) {
                      return "You must enter a username";
                    }
                    return null;
                  },
                  onSaved: (str) {
                    _username = str;
                  },
                ),
                TextFormField(
                  initialValue: _password,
                  decoration: InputDecoration(
                    labelText: "Password"
                  ),
                  validator: (str) {
                    if(str.isEmpty) {
                      return "You must enter a password";
                    }
                    return null;
                  },
                  onSaved: (str) {
                    _password = str;
                  },
                ),
              ]
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4
        ),
        child: Row(
          children: [
            Expanded(
              child: RaisedButton(
                color: Colors.green,
                child: Text(
                  "Login"
                ),
                onPressed: _login,
              ),
            )
          ]
        ),
      ),
    );
  }

  void _goToSettings() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => SettingsScreen()
    ));
  }

  void _login() async {
    if(_formKey.currentState.validate()) {

      if(_settings.serverIp == null) {
        showErrorDialog(context, "The server ip is not configured !\n"
          "Press ok to configure it.", onTap: _goToSettings);
        return;
      }

      showLoadingDialog(context, canPop: false);
      _formKey.currentState.save();

      _settings.username = _username;

      final authMsg = await _authService.login(_username, _password);

      Navigator.pop(context);

      if(authMsg == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => HomeScreen()
        ));
      }
      else {
        showErrorDialog(context, authMsg);
      }
    }
  }
}