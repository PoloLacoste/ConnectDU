import 'package:server/server.dart';

class CollectController extends ResourceController
{
  CollectController(this.collectService);

  final CollectService collectService;

	@Operation.get()
	Future<Response> collect() async
	{
    final socket = await WebSocketTransformer.upgrade(request.raw);
    final username = request.authorization.clientID;

    collectService.add(username, socket);

    return null;
	}
}