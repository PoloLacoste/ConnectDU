import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:common/event.dart';

import 'package:client/app/locator.dart';

class CollectService {

  final _authService = locator<AuthService>();

  final _stream = StreamController<Event>();

  Stream<Event> get stream => _stream.stream;
  WebSocket _webSocket;

  Future<void> collect() async {
    _webSocket = await WebSocket.connect("ws://192.168.1.14/collect", headers: {
      "Authorization": "Bearer ${_authService.token}"
    });

    _webSocket.listen((data) {
      _stream.add(Event.fromJson(jsonDecode(data)));
    }, onDone: () async {
      await _webSocket.close();
      await _stream.close();
    }, onError: (e) async {
      print(e);
      await _webSocket.close();
      await _stream.close();
    });
  }

  void send(Event event) {
    _webSocket.add(jsonEncode(event.toJson()));
  }
}