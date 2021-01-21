import 'package:client/app/locator.dart';

class SettingsService {
  final prefs = locator<SharedPreferences>();

  String get username => prefs.getString("username");
  set username(String username) => prefs.setString("username", username);

  String get serverIp => prefs.getString("serverIp");
  set serverIp(String serverIp) => prefs.setString("serverIp", serverIp);
}