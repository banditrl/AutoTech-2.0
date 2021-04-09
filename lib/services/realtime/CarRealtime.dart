import 'common/CommonRealtime.dart';

 class CarRealtime extends CommonRealtime {
  CarRealtime.internal() : super('car');
  static final CarRealtime _instance = CarRealtime.internal();

  factory CarRealtime() => _instance;
}