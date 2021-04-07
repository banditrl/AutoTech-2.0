import 'dart:async';
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

class CarUtilities {
  DatabaseReference _counterRef;
  DatabaseReference _carRef;
  StreamSubscription<Event> _counterSubscription;
  StreamSubscription<Event> _messagesSubscription;
  FirebaseDatabase database = new FirebaseDatabase();
  int _counter;
  DatabaseError error;

  static final CarUtilities _instance = new CarUtilities.internal();

  CarUtilities.internal();

  factory CarUtilities() {
    return _instance;
  }

  void initState() {
    // Demonstrates configuring to the database using a file
    _counterRef = FirebaseDatabase.instance.reference().child('counter');
    // Demonstrates configuring the database directly

    _carRef = database.reference().child('car');
    database.reference().child('counter').once().then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
    });
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    _counterRef.keepSynced(true);

    _counterSubscription = _counterRef.onValue.listen((Event event) {
      error = null;
      _counter = event.snapshot.value ?? 0;
    }, onError: (Object o) {
      error = o;
    });
  }

  DatabaseError getError() {
    return error;
  }

  int getCounter() {
    return _counter;
  }

  DatabaseReference getCar() {
    return _carRef;
  }

  addCar(Car car) async {
    await _counterRef.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;

      return mutableData;
    });

    _carRef.push().set(<String, String>{
      "UserKey": "" + car.userKey,
      "Brand": "" + car.brand,
      "Model": "" + car.model,
      "Description": "" + car.description,
      "Year": "" + car.year.toString(),
      "Mileage": "" + car.mileage.toString(),
    }).then((_) {
      print('Transaction  committed.');
    });
  }

  void deleteCar(Car car) async {
    await _carRef.child(car.key).remove().then((_) {
      print('Transaction  committed.');
    });
  }

  void updateCar(Car car) async {
    await _carRef.child(car.key).update({
      "UserKey": "" + car.userKey,
      "Brand": "" + car.brand,
      "Model": "" + car.model,
      "Description": "" + car.description,
      "Year": "" + car.year.toString(),
      "Mileage": "" + car.mileage.toString(),
    }).then((_) {
      print('Transaction  committed.');
    });
  }

  void dispose() {
    _messagesSubscription.cancel();
    _counterSubscription.cancel();
  }
}
