import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:client/utils/dialogs.dart';
import 'package:common/event.dart';

import 'package:client/app/locator.dart';
import 'package:flutter/cupertino.dart';

class CollectService {

  final _authService = locator<AuthService>();
  final _settings = locator<SettingsService>();

  final _stream = StreamController<List<Event>>();
  final _players = <String, Event>{};

  Stream<List<Event>> get stream => _stream.stream;
  WebSocket _webSocket;
  bool _showError = true;

  Future<void> collect(BuildContext context, Function logout) async {
    _webSocket = await WebSocket.connect("wss://${_settings.serverIp}/collect", headers: {
      "Authorization": "Bearer ${_authService.token}"
    }).timeout(Duration(seconds: 4));

    _webSocket.listen((data) {
      final event = Event.fromJson(jsonDecode(data));
      _players[event.username] = event;
      _stream.add(_players.values.toList());
    }, onDone: () async {
      if(_showError) {
        showErrorDialog(context, 
          "You are disconnected from the server.\n"
          "Press ok to reconnect.",
          onTap: logout
        );
      }
      await _webSocket.close();
      await _stream.close();
    }, onError: (e) async {
      showErrorDialog(context, 
        "An error occured :\n $e\n"
        "Press ok to reconnect.",
        onTap: logout
      );
      await _webSocket.close();
      await _stream.close();
    });
  }

  bool send(Event event) {
    try {
      _webSocket.add(jsonEncode(event.toJson()));
      _players[event.username] = event;
      _stream.add(_players.values.toList());
    }
    catch(e) {
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    _showError = true;
    await _webSocket.close();
    _showError = false;
  }
}