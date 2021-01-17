import 'package:server/server.dart';

class TokenController extends Controller
{
  TokenController(this.secret);
	
  final String secret;
  final bearerParser = const AuthorizationBearerParser();

  @override
  FutureOr<RequestOrResponse> handle(Request request) {
    final authorizationHeader = request.raw.headers.value(HttpHeaders.authorizationHeader);
    if(authorizationHeader == null) {
      return Response.unauthorized();
    }

    final token = bearerParser.parse(authorizationHeader);
    if(token == null) {
      return Response.unauthorized();
    }

    String error;

    try {
      final jwt = JWT.verify(token, SecretKey(secret));
      request.authorization = Authorization(
        jwt.payload['username'] as String,
        0,
        null
      );
      return request;
    }
    on JWTExpiredError {
      error = "Expired";
    }
    on JWTError {
      error = "Invalid signature";
    }

    return Response.unauthorized(body: error);
  }
}