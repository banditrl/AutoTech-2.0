import 'package:auto_tech/classes/Car.dart';
import 'package:auto_tech/services/realtime/CarRealtime.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'PartDashBoard.dart';

class CarRegister extends StatefulWidget {
  final bool isEdit;
  final String userKey;
  final Car car;

  const CarRegister({Key key, this.isEdit, this.userKey, this.car})
      : super(key: key);

  @override
  _CarRegisterState createState() =>
      new _CarRegisterState(isEdit, userKey, car);
}

class _CarRegisterState extends State<CarRegister> {
  final bool isEdit;
  final String userKey;
  final Car car;

  _CarRegisterState(this.isEdit, this.userKey, this.car);

  final teBrand = TextEditingController();
  final teModel = TextEditingController();
  final teDescription = TextEditingController();
  final teYear = TextEditingController();
  final teMileage = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  CarRealtime carRealtime;

  @override
  void initState() {
    super.initState();
    carRealtime = new CarRealtime();
    carRealtime.initState();
    populateFields();
  }

  @override
  void dispose() {
    super.dispose();
    carRealtime.dispose();
  }

  populateFields() {
    if (car != null) {
      teBrand.text = car.brand;
      teModel.text = car.model;
      teDescription.text = car.description;
      teYear.text = car.year.toString();
      teMileage.text = car.mileage.toString();
    }
  }

  void submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      if (isEdit) {
        updateCar();
      } else {
        registerCar();
      }
    }
  }

  void registerCar() {
    Car car = Car(userKey, teBrand.text, teModel.text, teDescription.text,
        int.parse(teYear.text), int.parse(teMileage.text));
    setState(() {
      carRealtime.add(car);
    });
    FirebaseDatabase.instance
        .reference()
        .child('car')
        .orderByChild('UserKey')
        .equalTo(userKey)
        .once()
        .then((onValue) {
      car = Car.fromSnapshotSingle(onValue);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PartDashboard(car: car)));
    });
  }

  void updateCar() {
    print('sucess');
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: isEdit ? () async => true : () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: isEdit
            ? AppBar(
                centerTitle: true,
                title: new Text('My Car',
                    style: new TextStyle(fontFamily: "Poppins-Medium")),
              )
            : null,
        body: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(30),
                  ),
                  formCard(context),
                  isEdit
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                width: ScreenUtil.getInstance().setWidth(330),
                                height: ScreenUtil.getInstance().setHeight(100),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(58, 66, 86, 1.0),
                                      Color(0xFF6078ea)
                                    ]),
                                    borderRadius: BorderRadius.circular(6.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color(0xFF6078ea).withOpacity(.3),
                                          offset: Offset(0.0, 8.0),
                                          blurRadius: 8.0)
                                    ]),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => submit(),
                                    child: Center(
                                      child: Text("REGISTER",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Poppins-Bold",
                                              fontSize: 18,
                                              letterSpacing: 1.0)),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(30),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget formCard(BuildContext context) {
    return new Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isEdit
                ? Container()
                : Text("Car Register",
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(45),
                        fontFamily: "Poppins-Bold",
                        letterSpacing: .6)),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("Brand",
                style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            getTextField('ex: Audi', teBrand, false, context),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(30),
            ),
            Text("Model",
                style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            getTextField('ex: A5', teModel, false, context),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(35),
            ),
            Text("Description",
                style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            getTextField('ex: White 2.0 TURBO', teDescription, false, context),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(35),
            ),
            Text("Year",
                style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            getTextField('year', teYear, true, context),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(35),
            ),
            Text("Mileage",
                style: TextStyle(
                    fontFamily: "Poppins-Medium",
                    fontSize: ScreenUtil.getInstance().setSp(26))),
            getTextField('ex: 21500', teMileage, true, context),
            SizedBox(
              height: ScreenUtil.getInstance().setHeight(35),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextField(String inputBoxName,
      TextEditingController inputBoxController, bool isNumberOnly, context) {
    var btnAdd = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        validator: (value) {
          if (value.isEmpty) return 'Please enter some text';
          return null;
        },
        controller: inputBoxController,
        enabled: isEdit ? false : true,
        keyboardType: isNumberOnly ? TextInputType.number : TextInputType.text,
        decoration: new InputDecoration(
          hintText: inputBoxName,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
        ),
      ),
    );
    return btnAdd;
  }
}
