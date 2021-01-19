import 'package:server/server.dart';

class CollectController extends ResourceController
{
  CollectController(this.collectService);

  final CollectService collectService;

	@Operation.get()
	Future<Response> collect() async
	{
    final username = request.authorization.clientID;
    if(collectService.exist(username)) {
      return Response.badRequest(body: "You are already connected !");
    }

    final socket = await WebSocketTransformer.upgrade(request.raw);
    collectService.add(username, socket);

    return null;
	}
}