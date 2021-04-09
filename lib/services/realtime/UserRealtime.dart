import 'common/CommonRealtime.dart';

class UserRealtime extends CommonRealtime {
  UserRealtime.internal() : super('user');
  static final UserRealtime _instance = UserRealtime.internal();

  factory UserRealtime() => _instance;

  getUsers() {
    List<String> lstUsers = new List<String>();
    get().once().then((onValue) {
      Map<dynamic, dynamic> values = onValue.value;
      values.forEach((key, values) {
        String user = values['Login'];
        lstUsers.add(user);
      });
    });
    return lstUsers;
  }
}


