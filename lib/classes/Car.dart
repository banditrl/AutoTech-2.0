import 'package:firebase_database/firebase_database.dart';

class Car {
  String key;
  String userKey;
  String brand;
  String model;
  String description;
  int year;
  int mileage;

  Car(this.userKey, this.brand, this.model, this.description, this.year,
      this.mileage);

  Car.fromSnapshot(DataSnapshot snapshot) {
    var value = snapshot.value;

    key = snapshot.key;
    userKey = value['userKey'];
    brand = value['brand'];
    model = value['model'];
    description = value['description'];
    year = value['year'];
    mileage = value['mileage'];
  }

  Car.fromSnapshotSingle(DataSnapshot snapshot) {
    String betaKey;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value;

      values.forEach((key, values) {
        betaKey = key;
        userKey = values['userKey'];
        brand = values['brand'];
        model = values['model'];
        description = values['description'];
        year = values['year'];
        mileage = values['mileage'];
      });

      key = betaKey;
    }
  }

  Map<String, dynamic> toMap() => {
        'key': key,
        'userKey': userKey,
        'brand': brand,
        'model': model,
        'description': description,
        'year': year,
        'mileage': mileage
      };
}
