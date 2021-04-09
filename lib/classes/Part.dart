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