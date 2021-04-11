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
    login = value['Login'];
    password = value['Password'];
    email = value['Email'];
  }

  User.fromSnapshotSingle(DataSnapshot snapshot) {
    String betaKey;
    Map<dynamic, dynamic> values = snapshot.value;

    values.forEach((key, values) {
      betaKey = key;
      login = values["Login"];
      password = values["Password"];
      email = values["Email"];
    });

    key = betaKey;
  }

  User.getKeyFromProfs(String loginKey) {
    key = loginKey;
  }

  Map<String, dynamic> toMap() =>
      {'key': key, 'login': login, 'password': password, 'email': email};
}
