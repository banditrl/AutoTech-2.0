import 'package:auto_tech/classes/Car.dart';
import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:auto_tech/pages/DashBoard/DashBoard.dart';
import 'package:auto_tech/services/realtime/CarRealtime.dart';
import 'package:auto_tech/widgets/stateless/ButtonCTA.dart';
import 'package:auto_tech/widgets/stateless/Textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarRegister extends StatefulWidget {
  final String userKey;
  final Car car;

  const CarRegister({Key key, this.userKey, this.car}) : super(key: key);

  @override
  _CarRegisterState createState() => _CarRegisterState();
}

class _CarRegisterState extends State<CarRegister> with ResponsiveMixin {
  final _carRealtime = CarRealtime();
  final _key = GlobalKey<FormState>();
  final _teBrand = TextEditingController();
  final _teModel = TextEditingController();
  final _teDescription = TextEditingController();
  final _teYear = TextEditingController();
  final _teMileage = TextEditingController();
  final _nullValidation =
      (value) => value.isEmpty ? 'Please enter some text' : null;

  bool _hasCarRegistered = false;

  @override
  void initState() {
    super.initState();
    _carRealtime.initState();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    _carRealtime.dispose();
  }

  void _initData() {
    var car = widget.car;

    if (car != null) {
      _hasCarRegistered = true;
      _teBrand.text = car.brand;
      _teModel.text = car.model;
      _teDescription.text = car.description;
      _teYear.text = car.year.toString();
      _teMileage.text = car.mileage.toString();
    }
  }

  void _register(BuildContext context) {
    final form = _key.currentState;

    if (!form.validate()) return;

    var car = Car(
        widget.userKey,
        _teBrand.text,
        _teModel.text,
        _teDescription.text,
        int.parse(_teYear.text),
        int.parse(_teMileage.text));

    _carRealtime.add(car);

    _redirectToDashBoard(context, car);
  }

  void _redirectToDashBoard(BuildContext context, Car car) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (
          context,
        ) =>
            DashBoard(
          car: car,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => _hasCarRegistered,
      child: Scaffold(
        appBar: _hasCarRegistered
            ? AppBar(
                centerTitle: true,
                title: new Text(
                  'My Car',
                  style: new TextStyle(
                    fontFamily: "Poppins-Medium",
                  ),
                ),
              )
            : null,
        body: Form(
          key: _key,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: responsiveHeight(30),
                  ),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _hasCarRegistered
                              ? Container()
                              : Text(
                                  "Car Register",
                                  style: TextStyle(
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(45),
                                    fontFamily: "Poppins-Bold",
                                    letterSpacing: .6,
                                  ),
                                ),
                          Textbox(
                            textController: _teBrand,
                            spacing: 15,
                            textLabel: "Brand",
                            textHint: "ex: Audi",
                            enabled: !_hasCarRegistered,
                            validation: _nullValidation,
                          ),
                          Textbox(
                            textController: _teModel,
                            spacing: 15,
                            textLabel: "Model",
                            textHint: "ex: A5",
                            enabled: !_hasCarRegistered,
                            validation: _nullValidation,
                          ),
                          Textbox(
                            textController: _teDescription,
                            spacing: 15,
                            textLabel: "Description",
                            textHint: "ex: White 2.0 TURBO",
                            enabled: !_hasCarRegistered,
                            validation: _nullValidation,
                          ),
                          Textbox(
                            textController: _teYear,
                            spacing: 15,
                            textLabel: "Year",
                            enabled: !_hasCarRegistered,
                            validation: _nullValidation,
                          ),
                          Textbox(
                            textController: _teMileage,
                            spacing: 15,
                            textLabel: "Mileage",
                            textHint: "ex: 21500",
                            enabled: !_hasCarRegistered,
                            validation: _nullValidation,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: responsiveHeight(150),
                    alignment: Alignment.bottomCenter,
                    child: _hasCarRegistered
                        ? Container()
                        : ButtonCTA(
                            "REGISTER",
                            width: 500,
                            onTap: () => _register(context),
                          ),
                  ),
                  SizedBox(
                    height: responsiveHeight(30),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
