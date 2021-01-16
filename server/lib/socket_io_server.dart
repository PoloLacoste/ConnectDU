import 'package:common/common.dart';
import 'package:common/event.dart';

class SocketIoServer {
  SocketIoServer(this.port) {
    io.on(Event.connection, (client) {
      print("Connection of client $client");
      client.on(Event.msg, (data) {
        print("Data from $client : $data");
      });
    });

    io.listen(port);
  }

  final io = Server();
  final int port;
}