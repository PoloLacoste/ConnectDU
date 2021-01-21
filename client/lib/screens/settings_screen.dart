import 'package:flutter/material.dart';

import 'package:validators/validators.dart';

import 'package:client/app/locator.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final settings = locator<SettingsService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings"
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                initialValue: settings.serverIp,
                decoration: InputDecoration(
                  labelText: "Server ip"
                ),
                validator: serverIpValidator,
                onFieldSubmitted: serverIpSave,
              )
            ],
          ),
        ),
      ),
    );
  }

  String serverIpValidator(String str) {
    if(str.isEmpty) {
      return "You must enter a server ip";
    }
    if(!isIP(str)) {
      return "You must enter a valid ip";
    }

    return null;
  }

  void serverIpSave(String str) {
    settings.serverIp = str;
  }
}