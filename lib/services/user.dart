import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String login;
  String password;
  String email;

  User(this.login, this.password, this.email);

  User.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    login = snapshot.value['Login'];
    password = snapshot.value['Password'];
    email = snapshot.value['Email'];
  }

  User.fromSnapshotSingle(DataSnapshot snapshot) {
    String betaKey;
    Map<dynamic, dynamic> values = snapshot.value;
    values.forEach((key, values) {
      betaKey = key;
      login = values["Login"];
      password = values["Password"];
      email = values["Email"];
    });
    key = betaKey;
  }

  User.getKeyFromProfs(String loginKey) {
    key = loginKey;
  }
}

class UserUtilities {
  DatabaseReference _counterRef;
  DatabaseReference _userRef;
  StreamSubscription<Event> _counterSubscription;
  StreamSubscription<Event> _messagesSubscription;
  FirebaseDatabase database = new FirebaseDatabase();
  int _counter;
  DatabaseError error;

  static final UserUtilities _instance = new UserUtilities.internal();

  UserUtilities.internal();

  factory UserUtilities() {
    return _instance;
  }

  void initState() {
    // Demonstrates configuring to the database using a file
    _counterRef = FirebaseDatabase.instance.reference().child('counter');
    // Demonstrates configuring the database directly

    _userRef = database.reference().child('user');
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

  getUsers() {
    List<String> lstUsers = new List<String>();
    _userRef.once().then((onValue) {
      Map<dynamic, dynamic> values = onValue.value;
      values.forEach((key, values) {
        String user = values['Login'];
        lstUsers.add(user);
      });
    });
    return lstUsers;
  }

  DatabaseError getError() {
    return error;
  }

  int getCounter() {
    return _counter;
  }

  DatabaseReference getUser() {
    return _userRef;
  }

  addUser(User user) async {
    await _counterRef.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;

      return mutableData;
    });

    _userRef.push().set(<String, String>{
      "Login": "" + user.login,
      "Password": "" + user.password,
      "Email": "" + user.email,
    }).then((_) {
      print('Transaction  committed.');
    });
  }

  void deleteUser(User user) async {
    await _userRef.child(user.key).remove().then((_) {
      print('Transaction  committed.');
    });
  }

  void updateUser(User user) async {
    await _userRef.child(user.key).update({
      "Login": "" + user.login,
      "Password": "" + user.password,
      "Email": "" + user.email,
    }).then((_) {
      print('Transaction  committed.');
    });
  }

  void dispose() {
    _messagesSubscription.cancel();
    _counterSubscription.cancel();
  }
}
