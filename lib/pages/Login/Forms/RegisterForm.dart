import 'package:auto_tech/classes/User.dart';
import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:auto_tech/pages/Login/Login.dart';
import 'package:auto_tech/services/realtime/CarRealtime.dart';
import 'package:auto_tech/services/realtime/UserRealtime.dart';
import 'package:auto_tech/utils/enums/LoginFormsEnum.dart';
import 'package:auto_tech/utils/validations/MessageFlushbar.dart';
import 'package:auto_tech/widgets/stateless/ButtonCTA.dart';
import 'package:auto_tech/widgets/stateless/DivisorLabel.dart';
import 'package:auto_tech/widgets/stateless/FormCard.dart';
import 'package:auto_tech/widgets/stateless/Textbox.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> with ResponsiveMixin {
  final _userRealtime = UserRealtime();
  final _carRealtime = CarRealtime();
  final _key = GlobalKey<FormState>();
  final _teLogin = TextEditingController();
  final _tePassword = TextEditingController();
  final _teEmail = TextEditingController();
  List<String> _users;

  @override
  void initState() {
    super.initState();
    _userRealtime.initState();
    _carRealtime.initState();
    _users = _userRealtime.getUsers();
  }

  @override
  void dispose() {
    super.dispose();
    _userRealtime.dispose();
    _carRealtime.dispose();
  }

  _loginValidation(value) {
    if (value.isEmpty) return 'Please enter some text';

    if (_users.any((user) => user == value))
      return 'Please choose another username';
  }

  _passwordValidation(value) {
    if (8 > value.length) return 'Password must have 8 characters';
  }

  _emailValidation(value) {
    if (!value.contains('@') || !value.contains('.com'))
      return 'Please insert a valid E-mail';
  }

  void _register(BuildContext context) {
    var form = _key.currentState;

    if (!form.validate()) return;

    var user = _buildUser();

    _userRealtime.add(user);

    _redirectToUserLogin(context);

    showSuccessFloatingFlushbar(context, 'User Created Successfully!');
  }

  User _buildUser() {
    return User(
      _teLogin.text,
      _tePassword.text,
      _teEmail.text,
    );
  }

  void _redirectToUserLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context,) => Login(
          formToBuild: LoginFormsEnum.loginForm,
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
                  _redirectToUserLogin(context);
                },
              ),
            ],
          ),
          SizedBox(
            height: responsiveHeight(150),
          ),
          FormCard(
            formKey: _key,
            title: "Register",
            height: 850,
            content: [
              Textbox(
                textController: _teLogin,
                validation: (value) => _loginValidation(value),
                textLabel: "Login",
              ),
              Textbox(
                textController: _tePassword,
                validation: (value) => _passwordValidation(value),
                textLabel: "Password",
              ),
              Textbox(
                textController: _teEmail,
                validation: (value) => _emailValidation(value),
                textLabel: "Email",
              ),
              Container(
                height: responsiveHeight(150),
                alignment: Alignment.bottomCenter,
                child: ButtonCTA(
                  "CREATE USER",
                  width: 500,
                  onTap: () => _register(context),
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
