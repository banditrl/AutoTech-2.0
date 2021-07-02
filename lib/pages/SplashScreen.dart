import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:auto_tech/pages/PartDashBoard.dart';
import 'package:auto_tech/services/realtime/CarRealtime.dart';
import 'package:auto_tech/services/realtime/UserRealtime.dart';
import 'package:auto_tech/utils/Colors.dart';
import 'package:auto_tech/utils/enums/PagesEnum.dart';
import 'package:auto_tech/widgets/stateless/ShadowedText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/Car.dart';
import '../classes/User.dart';
import 'CarRegister.dart';
import 'UserLogin.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin, ResponsiveMixin {
  UserRealtime _userRealtime;
  CarRealtime _carRealtime;
  AnimationController _animationController;
  User _user;
  Car _car;
  var _page;

  @override
  void initState() {
    super.initState();

    _userRealtime = UserRealtime();
    _userRealtime.initState();

    _carRealtime = CarRealtime();
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
    var loginKey = prefs.getString('loginKey');

    if (loginKey == null) return PagesEnum.userLogin;

    _user = await _userRealtime.getUserByLoginKey(loginKey);

    if (_user == null) return PagesEnum.userLogin;

    prefs.setString('loginKey', _user.key);
    _car = await _carRealtime.getCarByUserKey(_user.key);

    if (_car == null) return PagesEnum.carRegister;

    prefs.setString('carKey', _car.key);

    return PagesEnum.partDashboard;
  }

  void preLoad(PagesEnum pageToRedirect) {
    switch (pageToRedirect) {
      case PagesEnum.userLogin:
        _page = UserLogin();
        break;
      case PagesEnum.carRegister:
        _page = CarRegister(isEdit: false, userKey: _user.key);
        break;
      case PagesEnum.partDashboard:
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
