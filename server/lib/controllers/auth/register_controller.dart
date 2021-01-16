import 'package:server/server.dart';

class RegisterController extends ResourceController
{
	RegisterController(this.context);
	
  final ManagedContext context;

	@Operation.post()
	Future<Response> register(@Bind.body(
    require: RegisterDto.require
  ) RegisterDto body) async
	{
		final digest = sha256.convert(utf8.encode(body.password));
    final hashedPassword = "$digest";
    
		final query = Query<User>(context)
		..values.username = body.username
		..values.password = hashedPassword;

		final user = await query.insert();

		return Response.ok(user);
	}
}