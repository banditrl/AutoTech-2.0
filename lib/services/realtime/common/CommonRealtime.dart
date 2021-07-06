import 'dart:async';
import 'package:auto_tech/utils/Converters.dart';
import 'package:firebase_database/firebase_database.dart';

class CommonRealtime with Converters {
  String _colletion;
  int _counter;
  DatabaseError _error;
  DatabaseReference _counterRef;
  DatabaseReference _dbRef;
  StreamSubscription<Event> _counterSubscription;
  FirebaseDatabase database = FirebaseDatabase();

  CommonRealtime(this._colletion);

  void initState() {
    _counterRef = FirebaseDatabase.instance.reference().child('counter');
    _dbRef = database.reference().child(_colletion);

    database.reference().child('counter').once().then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
    });

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    _counterRef.keepSynced(true);

    _counterSubscription = _counterRef.onValue.listen((Event event) {
      _error = null;
      _counter = event.snapshot.value ?? 0;
    }, onError: (Object o) {
      _error = o;
    });
  }

  DatabaseError getError() {
    return _error;
  }

  int getCounter() {
    return _counter;
  }

  DatabaseReference get() {
    return _dbRef;
  }

  void add(dynamic entity) async {
    await _counterRef.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;

      return mutableData;
    });

    _dbRef.push().set(convertDynamicToMap(entity)).then((_) {
      print('Transaction  committed.');
    });
  }

  void delete(dynamic entity) async {
    await _dbRef.child(entity.key).remove().then((_) {
      print('Transaction  committed.');
    });
  }

  void update(dynamic entity) async {
    await _dbRef.child(entity.key).update(convertDynamicToMap(entity)).then((_) {
      print('Transaction  committed.');
    });
  }

  void dispose() {
    _counterSubscription.cancel();
  }
}
