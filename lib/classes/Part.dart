import 'package:firebase_database/firebase_database.dart';

class Part {
  String key;
  String carKey;
  String name;
  int registeredKM;
  int lifeSpam;

  Part(this.carKey, this.name, this.registeredKM, this.lifeSpam);

  Part.fromSnapshot(DataSnapshot snapshot) {
    var value = snapshot.value;
    
    key = snapshot.key;
    carKey = value['CarKey'];
    name = value['Name'];
    registeredKM = value['RegisteredKM'];
    lifeSpam = value['LifeSpam'];
  }

  Map<String, dynamic> toMap() => {
        'key': key,
        'carKey': carKey,
        'name': name,
        'registeredKM': registeredKM,
        'lifeSpam': lifeSpam
      };
}
