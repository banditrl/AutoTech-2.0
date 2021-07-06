import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String login;
  String password;
  String email;

  User(this.login, this.password, this.email);

  User.fromSnapshot(DataSnapshot snapshot) {
    var value = snapshot.value;

    key = snapshot.key;
    login = value['login'];
    password = value['password'];
    email = value['email'];
  }

  User.fromSnapshotSingle(DataSnapshot snapshot) {
    String betaKey;
    Map<dynamic, dynamic> values = snapshot.value;

    values?.forEach((key, values) {
      betaKey = key;
      login = values["login"];
      password = values["password"];
      email = values["email"];
    });

    key = betaKey;
  }

  User.getKeyFromProfs(String loginKey) {
    key = loginKey;
  }

  Map<String, dynamic> toMap() =>
      {'key': key, 'login': login, 'password': password, 'email': email};
}
