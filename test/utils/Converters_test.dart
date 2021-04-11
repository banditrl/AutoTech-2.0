import 'package:auto_tech/classes/User.dart';
import 'package:auto_tech/services/realtime/common/CommonRealtime.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Tests mapping from class to map', () {
    var user = new User('testUser', 'testUser123', 'test@test.com');
    dynamic obj = user;
    var result = new CommonRealtime('user').convertDynamicToMap(obj);

    expect(result, user.toMap());   
  });
}
