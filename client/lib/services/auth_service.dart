import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:client/utils/utils.dart';

class AuthService {
  String _token;

  String get token => _token;

  Future<String> login(String username, String password) async {
    http.Response res;

    try {
      res = await http.post(
        "http://$serverIp/login",
        body: jsonEncode({
          "username": username,
          "password": password
        }),
        headers: {
          "Content-Type": "application/json"
        }
      ).timeout(Duration(seconds: 4));
    }
    catch(e) {
      print(e);
      return "Failed to etablished a connection with the server";
    }

    if(res?.statusCode == 200) {
      final body = jsonDecode(res.body);
      _token = body["token"];
      return null;
    }

    return "Invalid credentials";
  }
}