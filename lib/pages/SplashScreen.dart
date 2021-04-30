import 'package:auto_tech/classes/Car.dart';
import 'package:auto_tech/classes/User.dart';
import 'package:auto_tech/utils/Colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CarRegister.dart';
import 'PartDashBoard.dart';
import 'UserLogin.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  var _screenToRedirect;

  @override
  void initState() {
    super.initState();
    initData().then((value) {
      navigateToHomeScreen();
    });
  }

  Future initData() async {
    redirectUser();
    await Future.delayed(Duration(seconds: 5));
  }

    redirectUser() async {
    var prefs = await SharedPreferences.getInstance();
    var loginKey = prefs.getString('loginKey');
    if (loginKey != null) {
      FirebaseDatabase.instance
          .reference()
          .child('user')
          .orderByKey()
          .equalTo(loginKey)
          .once()
          .then((onValue) {
        validateRedirect(onValue);
      });
    } else
      _screenToRedirect = UserLogin();
  }

  
  validateRedirect(DataSnapshot snapshot) async {
    try {
      var user = User.fromSnapshotSingle(snapshot);
      if (user != null) {
        var prefs = await SharedPreferences.getInstance();
        prefs.setString('loginKey', user.key.toString());
        redirectToScreen(user, prefs);
      }
    } catch (error) {
      print(error);
    }
  }

    redirectToScreen(User user, SharedPreferences prefs) {
    FirebaseDatabase.instance
        .reference()
        .child('car')
        .orderByChild('userKey')
        .equalTo(user.key)
        .once()
        .then((onValue) async {
      var car = Car.fromSnapshotSingle(onValue);
      if (car.key != null) {
        prefs.setString('carKey', car.key);
        _screenToRedirect = PartDashboard(car: car);
      } else {
        _screenToRedirect = CarRegister(
          isEdit: false,
          userKey: user.key,
        );
      }
    });
  }

  void navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _screenToRedirect),
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
