import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:auto_tech/widgets/stateless/ButtonCTA.dart';
import 'package:auto_tech/widgets/stateless/DivisorLabel.dart';
import 'package:auto_tech/widgets/stateless/FormCard.dart';
import 'package:auto_tech/widgets/stateless/Textbox.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget with ResponsiveMixin {
  final List users;

  RegisterForm({Key key, this.users}) : super(key: key);

  final teLogin = TextEditingController();
  final tePassword = TextEditingController();
  final teEmail = TextEditingController();

  navigateToLogin() => null;

  register() => null;

  loginValidation(value) {
    if (value.isEmpty) return 'Please enter some text';

    if (users.any((user) => user == value))
      return 'Please choose another username';
  }

  passwordValidation(value) {
    if (8 > value.length) return 'Password must have 8 characters';
  }

  emailValidation(value) {
    if (!value.contains('@') || !value.contains('.com'))
      return 'Please insert a valid E-mail';
  }

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
                  navigateToLogin();
                },
              ),
            ],
          ),
          SizedBox(
            height: responsiveHeight(180),
          ),
          FormCard(
            title: "Register",
            height: 750,
            content: [
              Textbox(
                textController: teLogin,
                validation: (value) => loginValidation(value),
                textLabel: "Login",
              ),
              Textbox(
                textController: tePassword,
                validation: (value) => passwordValidation(value),
                textLabel: "Password",
              ),
              Textbox(
                textController: teEmail,
                validation: (value) => emailValidation(value),
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
          ),
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
