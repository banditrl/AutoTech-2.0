import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:auto_tech/widgets/stateless/ButtonCTA.dart';
import 'package:auto_tech/widgets/stateless/DivisorLabel.dart';
import 'package:auto_tech/widgets/stateless/FormCard.dart';
import 'package:auto_tech/widgets/stateless/Textbox.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget with ResponsiveMixin {
  final teLogin = TextEditingController();
  final tePassword = TextEditingController();
  final teEmail = TextEditingController();

  formCard() {
    var loginValidation =
        (value) => value.isEmpty ? 'Please enter some text' : null;

    var passwordValidation =
        (value) => value.isEmpty ? 'Please enter some text' : null;

    var emailValidation =
        (value) => value.isEmpty ? 'Please enter some text' : null;

    return FormCard(
      title: "Register",
      height: 750,
      content: [
        Textbox(
          textController: teLogin,
          validation: loginValidation,
          textLabel: "Login",
        ),
        Textbox(
          textController: tePassword,
          validation: passwordValidation,
          textLabel: "Password",
        ),
        Textbox(
          textController: teEmail,
          validation: emailValidation,
          textLabel: "Email",
        ),
        SizedBox(
          height: responsiveHeight(60),
        ),
        Center(
          child: ButtonCTA(
            "CREATE USER",
            width: 500,
            onTap: () => register(),
          ),
        ),
      ],
    );
  }

  navigateBack() => null;

  register() => null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 28.0,
        right: 28.0,
        top: 30.0,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left_outlined,
                  color: Colors.grey,
                  size: 50,
                ),
                onPressed: () {
                  navigateBack();
                },
              ),
            ],
          ),
          SizedBox(
            height: responsiveHeight(180),
          ),
          formCard(),
          SizedBox(
            height: responsiveHeight(80),
          ),
          DivisorLabel(
            "Welcome to Auto Tech",
            lineWidth: 100,
          ),
          SizedBox(
            height: responsiveHeight(70),
          ),
        ],
      ),
    );
  }
}
