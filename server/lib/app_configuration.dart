import 'dart:io';

import 'package:server/server.dart';

class AppConfiguration extends Configuration {
  AppConfiguration(String path): super.fromFile(File(path));

  DatabaseConfiguration database;
  String secret;
  bool register;
}