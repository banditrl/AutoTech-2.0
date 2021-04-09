import 'package:firebase_database/firebase_database.dart';

import 'common/CommonRealtime.dart';

class PartRealtime extends CommonRealtime {
  PartRealtime.internal() : super('part');
  static final PartRealtime _instance = PartRealtime.internal();

  factory PartRealtime() => _instance;

  Query getPartFromCar(String carKey) {
    return database.reference().child('part').orderByChild('CarKey').equalTo(carKey);
  }
}

