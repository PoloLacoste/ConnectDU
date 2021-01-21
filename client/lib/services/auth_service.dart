import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:client/app/locator.dart';

class AuthService {
  final _settings = locator<SettingsService>();

  String _token;

  String get token => _token;

  Future<String> login(String username, String password) async {
    http.Response res;

    try {
      res = await http.post(
        "https://${_settings.serverIp}/login",
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
      return "Failed to etablished a connection with the server";
    }

    if(res?.statusCode == 200) {
      final body = jsonDecode(res.body);
      _token = body["token"];
      return null;
    }

    if(res?.statusCode != 400) {
      return "Invalid server address";
    }

    return "Invalid credentials";
  }

  void logout() {
    _token = null;
  }
}