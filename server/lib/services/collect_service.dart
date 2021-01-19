import 'package:server/server.dart';

class CollectService {

  CollectService(this.messageHub, this.context);

  final ApplicationMessageHub messageHub;
  final ManagedContext context;
  final Map<String, WebSocket> webSockets = {};

  bool exist(String username) {
    return webSockets.containsKey(username);
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

  WebSocket remove(String username) {
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