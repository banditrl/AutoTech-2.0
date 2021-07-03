import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:auto_tech/widgets/stateful/RadioButton.dart';
import 'package:auto_tech/widgets/stateless/ButtonCTA.dart';
import 'package:auto_tech/widgets/stateless/ButtonLabel.dart';
import 'package:auto_tech/widgets/stateless/DivisorLabel.dart';
import 'package:auto_tech/widgets/stateless/FormCard.dart';
import 'package:auto_tech/widgets/stateless/Textbox.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget with ResponsiveMixin {
  final teLogin = TextEditingController();
  final tePassword = TextEditingController();

  formCard() {
    var nullValidation =
        (value) => value.isEmpty ? 'Please enter some text' : null;

    return FormCard(
      title: "Login",
      content: [
        Textbox(
          textController: teLogin,
          validation: nullValidation,
          textLabel: "Username",
        ),
        Textbox(
          textController: tePassword,
          validation: nullValidation,
          textLabel: "Password",
        ),
      ],
    );
  }

  login() => null;

  registerNewUser() => null;

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
          formCard(),
          SizedBox(height: responsiveHeight(40)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RadioButton(text: "Keep signed in"),
              ButtonCTA(
                "SIGNIN",
                onTap: () => login(),
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
                onTap: () => registerNewUser(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
