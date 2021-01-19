import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:common/event.dart';

import 'package:client/app/locator.dart';
import 'package:client/utils/utils.dart';

class CollectService {

  final _authService = locator<AuthService>();

  final _stream = StreamController<List<Event>>();
  final _players = <String, Event>{};

  Stream<List<Event>> get stream => _stream.stream;
  WebSocket _webSocket;

  Future<void> collect() async {
    _webSocket = await WebSocket.connect("wss://$serverIp/collect", headers: {
      "Authorization": "Bearer ${_authService.token}"
    }).timeout(Duration(seconds: 4));

    _webSocket.listen((data) {
      final event = Event.fromJson(jsonDecode(data));
      _players[event.username] = event;
      _stream.add(_players.values.toList());
    }, onDone: () async {
      await _webSocket.close();
      await _stream.close();
    }, onError: (e) async {
      print(e);
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
}