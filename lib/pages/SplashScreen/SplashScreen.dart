import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:auto_tech/pages/DashBoard/DashBoard.dart';
import 'package:auto_tech/services/realtime/CarRealtime.dart';
import 'package:auto_tech/services/realtime/UserRealtime.dart';
import 'package:auto_tech/utils/Colors.dart';
import 'package:auto_tech/utils/enums/PagesEnum.dart';
import 'package:auto_tech/widgets/stateless/ShadowedText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../classes/Car.dart';
import '../../classes/User.dart';
import '../CarRegister/CarRegister.dart';
import '../Login/Login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin, ResponsiveMixin {
  final _userRealtime = UserRealtime();
  final _carRealtime = CarRealtime();
  AnimationController _animationController;
  User _user;
  Car _car;
  var _page;

  @override
  void initState() {
    super.initState();
    _userRealtime.initState();
    _carRealtime.initState();
    initData();
  }

  void initData() async {
    try {
      var pageToRedirect = await retrieveCorrectPage();
      preLoad(pageToRedirect);

      await Future.delayed(Duration(seconds: 3), () => redirect());
    } catch (error) {
      print(error);
    }
  }

  Future<PagesEnum> retrieveCorrectPage() async {
    var prefs = await SharedPreferences.getInstance();

    var userKey = prefs.getString('userKey');

    if (userKey == null) return PagesEnum.login;

    _user = await _userRealtime.getUserByUserKey(userKey);

    if (_user == null) return PagesEnum.login;

    prefs.setString('userKey', _user.key);
    
    _car = await _carRealtime.getCarByUserKey(_user.key);

    if (_car == null) return PagesEnum.carRegister;

    prefs.setString('carKey', _car.key);

    return PagesEnum.dashboard;
  }

  void preLoad(PagesEnum pageToRedirect) {
    switch (pageToRedirect) {
      case PagesEnum.login:
        _page = Login();
        break;
      case PagesEnum.carRegister:
        _page = CarRegister(userKey: _user.key);
        break;
      case PagesEnum.dashboard:
        _page = DashBoard(car: _car);
        break;
      default:
        _page = Login();
    }
  }

  void redirect() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _page),
    );
  }

  Animation<double> animate() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward(from: 0);

    return CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.responsiveInit(context);
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          gradient: defaultVerticalGradient(),
        ),
        child: Center(
          child: FadeTransition(
            opacity: animate(),
            child: new ShadowedText(
              "AutoTech",
              size: 40,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
      ),
    );
  }
}
