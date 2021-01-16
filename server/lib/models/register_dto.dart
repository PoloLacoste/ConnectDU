import 'package:server/server.dart';

class RegisterDto with Serializable
{

	RegisterDto({
		this.username,
		this.password
	});

	String username;
	String password;

  static const require = ["username", "password"];

	@override
	Map<String, String> asMap() 
	{
		return {
			"username": username,
			"password": password
		};
	}

	@override
	void readFromMap(Map<String, dynamic> object)
	{
		username = object["username"] as String;
		password = object["password"] as String;
	}
}