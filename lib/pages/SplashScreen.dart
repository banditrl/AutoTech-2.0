import 'package:auto_tech/classes/Car.dart';
import 'package:auto_tech/classes/User.dart';
import 'package:auto_tech/widgets/stateless/Loading.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'CarRegister.dart';
import 'PartDashBoard.dart';
import 'UserLogin.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var screenToRedirect;

  @override
  void initState() {
    super.initState();
    redirectUser();
    initData().then((value) {
      navigateToHomeScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(100),
                        child: Image.asset('assets/images/autotech.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Loading(text: 'Preparing your car helper...',)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future initData() async {
    await Future.delayed(Duration(seconds: 5));
  }

  void navigateToHomeScreen() {
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => screenToRedirect));
  }

  redirectUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loginKey = prefs.getString('loginKey');
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
      screenToRedirect = UserLogin();
  }

  validateRedirect(DataSnapshot snapshot) async {
    try {
      User user = User.fromSnapshotSingle(snapshot);
      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
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
      Car car = Car.fromSnapshotSingle(onValue);
      if (car.key != null) {
        prefs.setString('carKey', car.key);
        screenToRedirect = PartDashboard(car: car);
      } else {
        screenToRedirect = CarRegister(
          isEdit: false,
          userKey: user.key,
        );
      }
    });
  }
}