import 'package:auto_tech/classes/Car.dart';

import 'common/CommonRealtime.dart';

class CarRealtime extends CommonRealtime {
  CarRealtime.internal() : super('car');
  static final CarRealtime _instance = CarRealtime.internal();

  factory CarRealtime() => _instance;

  Future<Car> getCarByUserKey(String userKey) async {
    var car = await database
        .reference()
        .child('car')
        .orderByChild('userKey')
        .equalTo(userKey)
        .once();
        
    return Car.fromSnapshotSingle(car);
  }
}
