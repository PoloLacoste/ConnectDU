import 'server.dart';

class ServerChannel extends ApplicationChannel {
  ManagedContext context;
  AppConfiguration config;

  static Future initializeApplication(ApplicationOptions options) async {
    configureDependencies();

    final config = AppConfiguration(options.configurationFilePath);
    final socketIoServer = SocketIoServer(config.socketIoPort);

    locator.registerSingleton<AppConfiguration>(config);
    locator.registerSingleton<SocketIoServer>(socketIoServer);
  }

  @override
  Future prepare() async {
    config = locator<AppConfiguration>();

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final psc = PostgreSQLPersistentStore.fromConnectionInfo(
      config.database.username,
      config.database.password,
      config.database.host,
      config.database.port,
      config.database.databaseName
    );

    context = ManagedContext(dataModel, psc);

    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route("/register")
    .link(() => RegisterController(context));

    router.route("/login")
    .link(() => LoginController(context));

    return router;
  }
}