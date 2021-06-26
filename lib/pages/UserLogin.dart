import 'package:auto_tech/classes/Car.dart';
import 'package:auto_tech/classes/User.dart';
import 'package:auto_tech/services/realtime/UserRealtime.dart';
import 'package:auto_tech/widgets/stateless/ShadowedText.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CarRegister.dart';
import 'PartDashBoard.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => new _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  bool _isSelected = false;
  final teLogin = TextEditingController();
  final tePassword = TextEditingController();
  final teLoginRegister = TextEditingController();
  final tePasswordRegister = TextEditingController();
  final teEmail = TextEditingController();
  final _key = GlobalKey<FormState>();
  final _keyRegister = GlobalKey<FormState>();
  User user;
  UserRealtime userRealtime;
  List lstUsers;

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  @override
  void initState() {
    super.initState();
    userRealtime = new UserRealtime();
    userRealtime.initState();
    loadUsers();
  }

  @override
  void dispose() {
    super.dispose();
    userRealtime.dispose();
  }

  loadUsers() => lstUsers = userRealtime.getUsers();

  registerNewUser(bool isEdit) {
    // registerNewUser(User user, bool isEdit) {
    showDialog(
      context: context,
      builder: (BuildContext context) => buildAboutDialog(context, isEdit),
    );
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

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
                    width: ScreenUtil.getInstance().setWidth(500),
                    height: ScreenUtil.getInstance().setHeight(500),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "AUTO TECH",
                          style: TextStyle(
                            fontFamily: "Poppins-Bold",
                            fontSize: ScreenUtil.getInstance().setSp(46),
                            letterSpacing: .6,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(180),
                    ),
                    formCard(context),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 12.0,
                            ),
                            GestureDetector(
                              onTap: _radio,
                              child: radioButton(_isSelected),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "Keep signed in",
                              style: TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(25),
                                fontFamily: "Poppins-Medium",
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          child: Container(
                            width: ScreenUtil.getInstance().setWidth(330),
                            height: ScreenUtil.getInstance().setHeight(100),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(58, 66, 86, 1.0),
                                  Color(0xFF6078ea),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(6.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF6078ea).withOpacity(.3),
                                  offset: Offset(0.0, 8.0),
                                  blurRadius: 8.0,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => login(),
                                child: Center(
                                  child: ShadowedText("SIGNIN"),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        horizontalLine(),
                        Text(
                          "New User?",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: "Poppins-Medium",
                          ),
                        ),
                        horizontalLine(),
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () => registerNewUser(false),
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                              color: Color(0xFF5d74e3),
                              fontFamily: "Poppins-Bold",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addUser(User user) {
    userRealtime.add(user);
  }

  void update(User user) {
    userRealtime.update(user);
  }

  Widget getTextField(String inputBoxName,
      TextEditingController inputBoxController, bool isObscure, context) {
    var btnAdd = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        validator: (value) {
          if (value.isEmpty) return 'Please enter some text';
          return null;
        },
        obscureText: isObscure ? true : false,
        controller: inputBoxController,
        decoration: new InputDecoration(
          hintText: inputBoxName,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
        ),
      ),
    );
    return btnAdd;
  }

  login() {
    FirebaseDatabase.instance
        .reference()
        .child('user')
        .orderByChild('login')
        .startAt(teLogin.text)
        .endAt(teLogin.text)
        .once()
        .then((onValue) {
      validateLogin(onValue);
    });
  }

  validateLogin(DataSnapshot snapshot) async {
    try {
      User user = User.fromSnapshotSingle(snapshot);
      if (user != null) {
        if (user.password == tePassword.text) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (_isSelected) {
            prefs.setString('loginKey', user.key.toString());
          }
          redirectToApp(user, prefs);
        } else
          showFloatingFlushbar(context, false, 'Incorrect Password');
      }
    } catch (error) {
      showFloatingFlushbar(context, false, 'User not found');
    }
  }

  redirectToApp(User user, SharedPreferences prefs) {
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PartDashboard(car: car)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CarRegister(
                      isEdit: false,
                      userKey: user.key,
                    )));
      }
    });
  }

  Widget formCard(BuildContext context) {
    return new Form(
      key: _key,
      child: Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(510),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(58, 66, 86, 1.0),
                  offset: Offset(0.0, 15.0),
                  blurRadius: 15.0),
              BoxShadow(
                  color: Color.fromRGBO(58, 66, 86, 1.0),
                  offset: Offset(0.0, -10.0),
                  blurRadius: 10.0),
            ]),
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Login",
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(45),
                      fontFamily: "Poppins-Bold",
                      letterSpacing: .6)),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(10),
              ),
              Text("Username",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              getTextField('username', teLogin, false, context),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(10),
              ),
              Text("Password",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              getTextField('password', tePassword, true, context),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAboutDialog(BuildContext context, bool isEdit) {
    return new Form(
      key: _keyRegister,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: new Text(
          isEdit ? 'Edit user' : 'Add new user',
          style: new TextStyle(fontFamily: "Poppins-Medium"),
        ),
        content: new SingleChildScrollView(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Login",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              getTextFieldRegister("login", teLoginRegister, false),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text("Password",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              getTextFieldRegister("password", tePasswordRegister, false),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text("Email",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              getTextFieldRegister("email", teEmail, false),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              new GestureDetector(
                onTap: () => onTap(isEdit, context),
                child: new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: getAppBorderButton(
                      isEdit ? "Edit User" : "Register User",
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTextFieldRegister(String inputBoxName,
      TextEditingController inputBoxController, bool isNumberOnly) {
    var btnAdd = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        validator: (value) {
          if (value.isEmpty) return 'Please enter some text';
          if (inputBoxName == "login") {
            bool match = false;
            lstUsers.any((user) {
              if (user == value) match = true;
              return match;
            });
            if (match) return 'Please choose another username';
          }
          if (inputBoxName == "password") {
            if (value.length < 8) return 'Password must have 8 characters';
          }
          if (inputBoxName == "email") {
            if (!value.contains('@') || !value.contains('.com'))
              return 'Please insert a valid E-mail';
          }

          return null;
        },
        style: TextStyle(fontSize: 12.0, fontFamily: "Poppins-Medium"),
        controller: inputBoxController,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
        //keyboardType: isNumberOnly ? TextInputType.number : TextInputType.text,
      ),
    );
    return btnAdd;
  }

  Widget getAppBorderButton(String buttonLabel, EdgeInsets margin) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(8.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        border: Border.all(color: const Color(0xFF28324E)),
        borderRadius: new BorderRadius.all(const Radius.circular(6.0)),
      ),
      child: new Text(
        buttonLabel,
        style: new TextStyle(
            color: const Color(0xFF28324E),
            fontSize: 18.0,
            letterSpacing: 0.3,
            fontFamily: "Poppins-Medium"),
      ),
    );
    return loginBtn;
  }

  User getData() {
    return new User(
        teLoginRegister.text, tePasswordRegister.text, teEmail.text);
  }

  User updateData(User user) {
    user.login = teLoginRegister.text;
    user.password = tePasswordRegister.text;
    user.email = teEmail.text;
    return user;
  }

  onTap(bool isEdit, BuildContext context) {
    final form = _keyRegister.currentState;
    if (form.validate()) {
      form.save();
      if (!isEdit) addUser(getData());
      Navigator.of(context).pop();
      showFloatingFlushbar(context, true, 'User Created Successfully!');
      loadUsers();
    }
  }

  void showFloatingFlushbar(
      BuildContext context, bool success, String message) {
    Flushbar(
      margin: EdgeInsets.all(10),
      borderRadius: 8,
      icon: Icon(success ? Icons.check : Icons.clear, size: 20),
      backgroundGradient: LinearGradient(
        colors: success
            ? [Colors.green.shade800, Colors.greenAccent.shade700]
            : [Colors.red.shade800, Colors.redAccent.shade200],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      // All of the previous Flushbars could be dismissed by swiping down
      // now we want to swipe to the sides
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      // The default curve is Curves.easeOut
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      message: message,
      duration: Duration(seconds: 3),
    )..show(context);
  }
}
