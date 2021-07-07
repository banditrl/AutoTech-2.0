import 'package:auto_tech/classes/Car.dart';
import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:auto_tech/pages/CarRegister/Forms/CarRegisterForm.dart';
import 'package:auto_tech/pages/DashBoard/DashBoard.dart';
import 'package:auto_tech/services/realtime/CarRealtime.dart';
import 'package:auto_tech/widgets/stateless/ButtonCTA.dart';
import 'package:flutter/material.dart';

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
        builder: (context) => DashBoard(
          car: car,
        ),
      ),
    );
  }

  Widget _addAppBar() {
    if (!_hasCarRegistered) return null;

    return AppBar(
      centerTitle: true,
      title: new Text(
        'My Car',
        style: new TextStyle(
          fontFamily: "Poppins-Medium",
        ),
      ),
    );
  }

  Widget _addCtaButton() {
    if (_hasCarRegistered) return Container();

    return Container(
      height: responsiveHeight(150),
      alignment: Alignment.bottomCenter,
      child: ButtonCTA(
        "REGISTER",
        width: 500,
        onTap: () => _register(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: _addAppBar(),
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
                  CarRegisterForm(
                    teBrand: _teBrand,
                    teDescription: _teDescription,
                    teMileage: _teMileage,
                    teModel: _teModel,
                    teYear: _teYear,
                    hasCarRegistered: _hasCarRegistered,
                  ),
                  _addCtaButton(),
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
