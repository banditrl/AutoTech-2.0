import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class Part {
  String key;
  String carKey;
  String name;
  int registeredKM;
  int lifeSpam;

  Part(this.carKey, this.name, this.registeredKM, this.lifeSpam);

  Part.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    carKey = snapshot.value['CarKey'];
    name = snapshot.value['Name'];
    registeredKM = int.parse(snapshot.value['RegisteredKM']);
    lifeSpam = int.parse(snapshot.value['LifeSpam']);
  }
}

class PartUtilities {
  DatabaseReference _counterRef;
  DatabaseReference _partRef;
  StreamSubscription<Event> _counterSubscription;
  StreamSubscription<Event> _messagesSubscription;
  FirebaseDatabase database = new FirebaseDatabase();
  int _counter;
  DatabaseError error;

  static final PartUtilities _instance = new PartUtilities.internal();

  PartUtilities.internal();

  factory PartUtilities() {
    return _instance;
  }

  void initState() {
    // Demonstrates configuring to the database using a file
    _counterRef = FirebaseDatabase.instance.reference().child('counter');
    // Demonstrates configuring the database directly

    _partRef = database.reference().child('part');
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

  DatabaseReference getPart() {
    return _partRef;
  }

    Query getPartFromCar(String carKey) {
    return database.reference().child('part').orderByChild('CarKey').equalTo(carKey);
  }

  addPart(Part part) async {
    await _counterRef.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;

      return mutableData;
    });

    _partRef.push().set(<String, String>{
      "CarKey": "" + part.carKey,
      "Name": "" + part.name,
      "LifeSpam": "" + part.lifeSpam.toString(),
      "RegisteredKM": "" + part.registeredKM.toString(),
    }).then((_) {
      print('Transaction  committed.');
    });
  }

  void deletePart(Part part) async {
    await _partRef.child(part.key).remove().then((_) {
      print('Transaction  committed.');
    });
  }

  void updatePart(Part part) async {
    await _partRef.child(part.key).update({
      "CarKey": "" + part.carKey,
      "Name": "" + part.name,
      "LifeSpam": "" + part.lifeSpam.toString(),
      "RegisteredKM": "" + part.registeredKM.toString(),
    }).then((_) {
      print('Transaction  committed.');
    });
  }

  void dispose() {
    _messagesSubscription.cancel();
    _counterSubscription.cancel();
  }
}
