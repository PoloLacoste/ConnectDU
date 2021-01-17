import 'package:server/server.dart';

class CollectController extends ResourceController
{
  CollectController(this.context);
	
  final ManagedContext context;

	@Operation.get()
	Future<Response> collect() async
	{
    final socket = await WebSocketTransformer.upgrade(request.raw);

    socket.listen((data) {

    }, onDone: () async {
      print("Socket done");
      await socket.close();
    }, onError: (e) async {
      print("Socket error $e");
      await socket.close();
    });

    return null;
	}
}