import 'package:server/server.dart';

class LoginController extends ResourceController
{
  LoginController(this.context);
	
  final ManagedContext context;

	@Operation.post()
	Future<Response> login(@Bind.body(
    require: LoginDto.require
  ) LoginDto body) async
	{
    final digest = sha256.convert(utf8.encode(body.password));
    final hashedPassword = "$digest";

		final query = Query<User>(context)
    ..where((u) => u.username).equalTo(body.username)
    ..where((u) => u.password).equalTo(hashedPassword);

    final user = await query.fetchOne();

    if(user == null) {
      return Response.badRequest(body: "Invalid username or password");
    }

    return Response.ok({});
	}
}