import 'package:auto_tech/classes/User.dart';

import 'common/CommonRealtime.dart';

class UserRealtime extends CommonRealtime {
  UserRealtime.internal() : super('user');
  static final UserRealtime _instance = UserRealtime.internal();

  factory UserRealtime() => _instance;

  List<String> getUsers() {
    List<String> lstUsers = [];
    get().once().then((onValue) {
      Map<dynamic, dynamic> values = onValue.value;
      values.forEach((key, values) {
        String user = values['Login'];
        lstUsers.add(user);
      });
    });
    return lstUsers;     
  }

  Future<User> getUserByUserKey(String key) async {
    var user = await database
        .reference()
        .child('user')
        .orderByKey()
        .equalTo(key)
        .once();

    return User.fromSnapshotSingle(user);
  }

  Future<User> getUserByLogin(String login) async {
    var user = await database
        .reference()
        .child('user')
        .orderByChild('login')
        .equalTo(login)
        .once();

    return User.fromSnapshotSingle(user);
  }
}
