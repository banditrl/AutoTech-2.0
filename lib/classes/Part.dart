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
    carKey = value['carKey'];
    name = value['name'];
    registeredKM = value['registeredKM'];
    lifeSpam = value['lifeSpam'];
  }

  Map<String, dynamic> toMap() => {
        'key': key,
        'carKey': carKey,
        'name': name,
        'registeredKM': registeredKM,
        'lifeSpam': lifeSpam
      };
}
