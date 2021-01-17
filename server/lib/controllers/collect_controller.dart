import 'package:server/server.dart';

class CollectController extends ResourceController
{
  CollectController(this.context);
	
  final ManagedContext context;

	@Operation.get()
	Future<Response> collect() async
	{
    final socket = await WebSocketTransformer.upgrade(request.raw);

    final username = request.authorization.clientID;

    socket.listen((data) {

    }, onDone: () async {
      print("Socket done $username");
      await socket.close();
    }, onError: (e) async {
      print("Socket error $username : $e");
      await socket.close();
    });

    return null;
	}
}