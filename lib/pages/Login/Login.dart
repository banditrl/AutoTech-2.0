import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:auto_tech/pages/Login/Forms/ForgotForm.dart';
import 'package:auto_tech/pages/Login/Forms/LoginForm.dart';
import 'package:auto_tech/pages/Login/Forms/RegisterForm.dart';
import 'package:auto_tech/utils/enums/LoginFormsEnum.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final LoginFormsEnum formToBuild;

  const Login({Key key, this.formToBuild = LoginFormsEnum.loginForm})
      : super(key: key);

  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> with Responsive {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _loadFormCard() {
    switch (widget.formToBuild) {
      case LoginFormsEnum.forgotForm:
        return ForgotForm();
        break;
      case LoginFormsEnum.loginForm:
        return LoginForm();
        break;
      case LoginFormsEnum.registerForm:
        return RegisterForm();
        break;
      default:
        return LoginForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Image.asset(
                    "assets/images/carsketch.png",
                    width: responsiveWidth(500),
                    height: responsiveHeight(500),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
            SingleChildScrollView(
              child: _loadFormCard(),
            ),
          ],
        ),
      ),
    );
  }
}
