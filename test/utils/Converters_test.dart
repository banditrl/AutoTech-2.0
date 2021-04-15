import 'package:auto_tech/classes/User.dart';
import 'package:auto_tech/services/realtime/common/CommonRealtime.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();

  test('To map converter - Expects to convert User to Map', () {

    final user = new User('testUser', 'testUser123', 'test@test.com');

    dynamic obj = user;
    
    final result = new CommonRealtime('user').convertDynamicToMap(obj);

    expect(result, user.toMap());   
  });
}
