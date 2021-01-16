import 'package:server/server.dart';

class CollectController extends ResourceController {
  @Operation.get("username")
  Future<Response> collect(@Bind.path("username") String username) async {

    final socket = await WebSocketTransformer.upgrade(request.raw);
    socket.listen((data) {
      print("Data from $username : $data");
    }, onDone: () {
      socket.close();
    }, onError: (e) {
      print("$username error : $e");
      socket.close();
    });

    return null;
  }
}