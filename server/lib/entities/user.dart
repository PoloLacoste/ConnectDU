import 'package:server/server.dart';

class User extends ManagedObject<_User> implements _User { } 

class _User {
  @primaryKey
  int id;

  @Column(unique: true, indexed: true)
  String username;

  String password;
}