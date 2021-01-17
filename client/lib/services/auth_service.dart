import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  String _token;

  String get token => _token;

  Future<bool> login(String username, String password) async {
    http.Response res;

    try {
      res = await http.post(
        "http://192.168.1.14/login",
        body: jsonEncode({
          "username": username,
          "password": password
        }),
        headers: {
          "Content-Type": "application/json"
        }
      );
    }
    catch(e) {
      print(e);
    }

    if(res?.statusCode == 200) {
      final body = jsonDecode(res.body);
      _token = body["token"];
      return true;
    }

    return false;
  }
}