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
    key = snapshot.key;
    userKey = snapshot.value['UserKey'];
    brand = snapshot.value['Brand'];
    model = snapshot.value['Model'];
    description = snapshot.value['Description'];
    year = int.parse(snapshot.value['Year']);
    mileage = int.parse(snapshot.value['Mileage']);
  }

  Car.fromSnapshotSingle(DataSnapshot snapshot) {
    String betaKey;
    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        betaKey = key;
        userKey = values['UserKey'];
        brand = values['Brand'];
        model = values['Model'];
        description = values['Description'];
        year = int.parse(values['Year']);
        mileage = int.parse(values['Mileage']);
      });
      key = betaKey;
    }
  }
}