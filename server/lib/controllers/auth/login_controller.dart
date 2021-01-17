import 'package:server/server.dart';

class LoginController extends ResourceController
{
  LoginController(this.context, this.secret);
	
  final ManagedContext context;
  final String secret;

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

    final jwt = JWT({
      'username': body.username
    });

    final token = jwt.sign(
      SecretKey(secret),
      expiresIn: const Duration(days: 1)
    );

    return Response.ok({
      'token': token
    });
	}
}