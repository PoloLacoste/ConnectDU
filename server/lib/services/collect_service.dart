import 'package:server/server.dart';

class CollectService {

  CollectService(this.messageHub);

  final ApplicationMessageHub messageHub;
  final Map<String, WebSocket> webSockets = {};

  void add(String username, WebSocket webSocket) {
    if(!webSockets.containsKey(username)) {
      webSockets[username] = webSocket;

      webSocket.listen((data) {
        _onData(webSocket, username, data);
      }, onDone: () {
        _onDone(username);
      }, onError: (e) {
        _onError(username, e);
      });
    }
  }

  WebSocket remove(String username) {
    return webSockets.remove(username);
  }

  void _onData(WebSocket webSocket, String username, dynamic data) {
    final jason = jsonDecode(data as String) as Map<String, dynamic>;
    final event = Event.fromJson(jason);

    messageHub.add(event);
    broadcast(event, fromUsername: username);
  }

  void _onDone(String username) {
    final webSocket = remove(username);
    if(webSocket != null) {
      webSocket.close();
    }
  }

  void _onError(String username, dynamic e) {
    _onDone(username);
  }

  void broadcast(Event event, {String fromUsername}) {
    webSockets.forEach((username, socket) {
      if(username != fromUsername) {
        socket.add(jsonEncode(event.toJson()));
      }
    });
  }
}