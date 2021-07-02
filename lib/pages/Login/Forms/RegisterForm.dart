import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:auto_tech/widgets/stateful/RadioButton.dart';
import 'package:auto_tech/widgets/stateless/ButtonCTA.dart';
import 'package:auto_tech/widgets/stateless/ButtonLabel.dart';
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
        ButtonCTA(
          "CREATE USER",
          onTap: () => register(),
        ),
      ],
    );
  }

  navigateBack() => null;

  register() => null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  navigateBack();
                }),
          ],
        ),
        SizedBox(
          height: responsiveHeight(180),
        ),
        formCard(),
        SizedBox(
          height: responsiveHeight(80),
        ),
        DivisorLabel("Welcome to Auto Tech"),
        SizedBox(
          height: responsiveHeight(70),
        ),
      ],
    );
  }
}
