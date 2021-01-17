import 'server.dart';

class ServerChannel extends ApplicationChannel {
  ManagedContext context;
  AppConfiguration config;
  CollectService collectService;

  @override
  Future prepare() async {
    config = AppConfiguration(options.configurationFilePath);

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final psc = PostgreSQLPersistentStore.fromConnectionInfo(
      config.database.username,
      config.database.password,
      config.database.host,
      config.database.port,
      config.database.databaseName
    );

    context = ManagedContext(dataModel, psc);

    collectService = CollectService(messageHub);

    messageHub.listen((data) {
      collectService.broadcast(data);
    }, onDone: () {
      print("Message hub done");
    }, onError: (e) {
      print("Message hub error : $e");
    });

    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route("/register")
    .link(() => RegisterController(context));

    router.route("/login")
    .link(() => LoginController(context, config.secret));

    router.route("/collect")
    .link(() => TokenController(config.secret))
    .link(() => CollectController(collectService));

    return router;
  }
}