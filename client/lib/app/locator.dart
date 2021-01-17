import 'package:get_it/get_it.dart';

import 'package:client/services/auth_service.dart';
export 'package:client/services/auth_service.dart';

import 'package:client/services/collect_service.dart';
export 'package:client/services/collect_service.dart';

import 'package:client/services/settings_service.dart';
export 'package:client/services/settings_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
export 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

Future<void> configureDependencies() async {
  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<CollectService>(CollectService());
  locator.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
  locator.registerLazySingleton<SettingsService>(() => SettingsService());

  await locator.allReady();
}