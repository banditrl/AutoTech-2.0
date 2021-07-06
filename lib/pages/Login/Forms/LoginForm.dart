import 'package:auto_tech/classes/Car.dart';
import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:auto_tech/pages/CarRegister/CarRegister.dart';
import 'package:auto_tech/pages/DashBoard/DashBoard.dart';
import 'package:auto_tech/pages/Login/Login.dart';
import 'package:auto_tech/services/realtime/CarRealtime.dart';
import 'package:auto_tech/services/realtime/UserRealtime.dart';
import 'package:auto_tech/utils/enums/LoginFormsEnum.dart';
import 'package:auto_tech/utils/validations/MessageFlushbar.dart';
import 'package:auto_tech/widgets/stateless/RadioButton.dart';
import 'package:auto_tech/widgets/stateless/ButtonCTA.dart';
import 'package:auto_tech/widgets/stateless/ButtonLabel.dart';
import 'package:auto_tech/widgets/stateless/DivisorLabel.dart';
import 'package:auto_tech/widgets/stateless/FormCard.dart';
import 'package:auto_tech/widgets/stateless/Textbox.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with ResponsiveMixin {
  final _userRealtime = UserRealtime();
  final _carRealtime = CarRealtime();
  final _key = GlobalKey<FormState>();
  final _teLogin = TextEditingController();
  final _tePassword = TextEditingController();
  final _nullValidation =
      (value) => value.isEmpty ? 'Please enter some text' : null;

  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _userRealtime.initState();
    _carRealtime.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _userRealtime.dispose();
    _carRealtime.dispose();
  }

  void _login(BuildContext context) async {
    var form = _key.currentState;

    if (!form.validate()) return;

    var user = await _userRealtime.getUserByLogin(_teLogin.text);

    if (user.key == null) {
      showErrorFloatingFlushbar(context, 'User not found');
      return;
    }

    if (user.password != _tePassword.text) {
      showErrorFloatingFlushbar(context, 'Incorrect Password');
      return;
    }

    if (_rememberMe) {
      var cache = await SharedPreferences.getInstance();
      cache.setString('userKey', user.key);
    }

    var car = await _carRealtime.getCarByUserKey(user.key);

    if (car.key == null) {
      _redirectToCarRegister(context, user.key);
      return;
    }

    _redirectToDashBoard(context, car);
  }

  void _redirectToCarRegister(BuildContext context, String userKey) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarRegister(
          userKey: userKey,
        ),
      ),
    );
  }

  void _redirectToDashBoard(BuildContext context, Car car) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DashBoard(car: car),
      ),
    );
  }

  void _redirectToUserRegister(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Login(
          formToBuild: LoginFormsEnum.registerForm,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 28.0,
        right: 28.0,
        top: 60.0,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "AUTO TECH",
                style: TextStyle(
                  fontFamily: "Poppins-Bold",
                  fontSize: responsiveFont(45),
                  letterSpacing: .6,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: responsiveHeight(180),
          ),
          FormCard(
            formKey: _key,
            title: "Login",
            content: [
              Textbox(
                textController: _teLogin,
                validation: _nullValidation,
                textLabel: "Username",
              ),
              Textbox(
                textController: _tePassword,
                validation: _nullValidation,
                textLabel: "Password",
              ),
            ],
          ),
          SizedBox(height: responsiveHeight(40)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RadioButton(
                text: "Keep signed in",
                checked: _rememberMe,
                onTap: () => setState(
                  () => _rememberMe = !_rememberMe,
                ),
              ),
              ButtonCTA(
                "SIGNIN",
                onTap: () => _login(context),
              ),
            ],
          ),
          SizedBox(
            height: responsiveHeight(40),
          ),
          DivisorLabel(
            "New User?",
            lineWidth: 120,
          ),
          SizedBox(
            height: responsiveHeight(70),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonLabel(
                "SignUp",
                onTap: () => _redirectToUserRegister(context),
              )
            ],
          ),
        ],
      ),
    );
  }
}
