import 'package:auto_tech/services/realtime/CarRealtime.dart';
import 'package:auto_tech/services/realtime/UserRealtime.dart';
import 'package:auto_tech/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/Car.dart';
import '../classes/User.dart';
import 'CarRegister.dart';
import 'PartDashBoard.dart';
import 'UserLogin.dart';

enum PageEnum { userLogin, carRegister, partDashboard }

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  UserRealtime userRealtime;
  CarRealtime carRealtime;
  AnimationController _animationController;
  User _user;
  Car _car;
  var _page;

  @override
  void initState() {
    super.initState();

    userRealtime = UserRealtime();
    userRealtime.initState();

    carRealtime = CarRealtime();
    carRealtime.initState();

    initData();
  }

  void initData() async {
    try {
      var pageToRedirect = await retrieveCorrectPage();
      preLoad(pageToRedirect);

      await Future.delayed(Duration(seconds: 5), () => redirect());
    } catch (error) {
      print(error);
    }
  }

  Future<PageEnum> retrieveCorrectPage() async {
    var pageToRedirect = PageEnum.userLogin;
    var prefs = await SharedPreferences.getInstance();
    var loginKey = prefs.getString('loginKey');

    if (loginKey == null) return pageToRedirect;

    _user = await userRealtime.getUserByLoginKey(loginKey);

    if (_user == null) return pageToRedirect;

    pageToRedirect = PageEnum.carRegister;
    prefs.setString('loginKey', _user.key);

    _car = await carRealtime.getCarByUserKey(_user.key);

    if (_car == null) return pageToRedirect;

    pageToRedirect = PageEnum.partDashboard;
    prefs.setString('carKey', _car.key);

    return pageToRedirect;
  }

  void preLoad(PageEnum pageToRedirect) {
    switch (pageToRedirect) {
      case PageEnum.userLogin:
        _page = UserLogin();
        break;
      case PageEnum.carRegister:
        _page = CarRegister(isEdit: false, userKey: _user.key);
        break;
      case PageEnum.partDashboard:
        _page = PartDashboard(car: _car);
        break;
      default:
        _page = UserLogin();
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
      duration: const Duration(seconds: 2),
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
            child: Image.asset(
              'assets/images/autotech-logo-white.png',
              height: 150,
              width: 150,
            ),
          ),
        ),
      ),
    );
  }
}
