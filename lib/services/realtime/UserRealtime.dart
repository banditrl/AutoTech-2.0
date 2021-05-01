import 'package:auto_tech/classes/User.dart';

import 'common/CommonRealtime.dart';

class UserRealtime extends CommonRealtime {
  UserRealtime.internal() : super('user');
  static final UserRealtime _instance = UserRealtime.internal();

  factory UserRealtime() => _instance;

  List getUsers() {
    var lstUsers = [];
    get().once().then((onValue) {
      Map<dynamic, dynamic> values = onValue.value;
      values.forEach((key, values) {
        String user = values['Login'];
        lstUsers.add(user);
      });
    });
    return lstUsers;
  }

  Future<User> getUserByLoginKey(String loginKey) async {
    var user = await database
        .reference()
        .child('user')
        .orderByKey()
        .equalTo(loginKey)
        .once();

    return User.fromSnapshotSingle(user);
  }
}
