import 'package:server/server.dart';

class CollectService {

  CollectService(this.messageHub, this.context);

  final ApplicationMessageHub messageHub;
  final ManagedContext context;
  final Map<String, WebSocket> webSockets = {};

  Future<bool> exist(String username) async {
    final query = Query<User>(context)
    ..where((u) => u.username).equalTo(username);
    final user = await query.fetchOne();

    if(user != null) {
      return user.connected;
    }

    return false;
  }

  void add(String username, WebSocket webSocket) async {
    if(!webSockets.containsKey(username)) {
      webSockets[username] = webSocket;

      webSocket.listen((data) {
        _onData(webSocket, username, data);
      }, onDone: () {
        _onDone(username);
      }, onError: (e) {
        _onError(username, e);
      });

      await _setConnected(username, true);

      final query = Query<User>(context);
      final users = await query.fetch();

      for(final user in users) {
        final event = Event(
          username: user.username,
          collected: user.collected,
        );
        webSocket.add(jsonEncode(event.toJson()));
      }
    }
  }

  Future<WebSocket> remove(String username) async {
    await _setConnected(username, false);
    return webSockets.remove(username);
  }

  void _onData(WebSocket webSocket, String username, dynamic data) async {
    final jason = jsonDecode(data as String) as Map<String, dynamic>;
    final event = Event.fromJson(jason);

    final updateQuery = Query<User>(context)
    ..values.collected = event.collected
    ..where((u) => u.username).equalTo(event.username);

    final user = await updateQuery.updateOne();

    if(user == null) {
      return;
    }

    messageHub.add(event);
    broadcast(event, fromUsername: username);
  }

  void _onDone(String username) async {
    final webSocket = await remove(username);
    if(webSocket != null) {
      await webSocket.close();
    }

    final logoutQuery = Query<User>(context)
    ..values.connected = false
    ..where((u) => u.username).equalTo(username);

    await logoutQuery.updateOne();
  }

  void _onError(String username, dynamic e) {
    _onDone(username);
  }

  Future<void> _setConnected(String username, bool connected) async {
    final updateQuery = Query<User>(context)
    ..values.connected = connected
    ..where((u) => u.username).equalTo(username);

    await updateQuery.updateOne();
  }

  void broadcast(Event event, {String fromUsername}) {
    webSockets.forEach((username, socket) {
      if(username != fromUsername) {
        socket.add(jsonEncode(event.toJson()));
      }
    });
  }
}