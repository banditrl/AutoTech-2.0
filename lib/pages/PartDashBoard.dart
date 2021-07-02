import 'package:auto_tech/classes/Car.dart';
import 'package:auto_tech/classes/Part.dart';
import 'package:auto_tech/pages/CarRegister.dart';
import 'package:auto_tech/pages/UserLogin.dart';
import 'package:auto_tech/services/realtime/CarRealtime.dart';
import 'package:auto_tech/services/realtime/PartRealtime.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PartDashboard extends StatefulWidget {
  final Car car;

  const PartDashboard({Key key, this.car}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState(car);
}

class _MyHomePageState extends State<PartDashboard> {
  final Car car;
  final numberFormat = NumberFormat("#,###");
  final teName = TextEditingController();
  final teLifeSpam = TextEditingController();
  final teMileage = TextEditingController();
  final _key = GlobalKey<FormState>();

  Part part;
  bool _anchorToBottom = false;
  bool isFirstOpen;
  PartRealtime partRealtime;
  CarRealtime carRealtime;
  _MyHomePageState(this.car);

  @override
  void initState() {
    super.initState();
    partRealtime = new PartRealtime();
    partRealtime.initState();
    carRealtime = new CarRealtime();
    carRealtime.initState();
  }

  @override
  void dispose() {
    super.dispose();
    partRealtime.dispose();
    carRealtime.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //It will show new part icon
    List<Widget> _buildActions() {
      return <Widget>[
        new IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ), // display pop for new entry
            onPressed: () {
              showEditWidget(null, false);
              isFirstOpen = true;
            }),
      ];
    }

    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: AppDrawer(car: car),
        appBar: AppBar(
          centerTitle: true,
          title: new Text('Auto Tech',
              style: new TextStyle(fontFamily: "Poppins-Medium")),
          actions: _buildActions(),
        ),

        // Firebase predefile list widget. It will get part info from firebase database
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Expanded(
              //   flex: 1,
              //   child: SizedBox(
              //     child: Padding(
              //       padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              //       child: buildFireBaseCar(context),
              //     )
              //   ),
              // ),
              Expanded(
                flex: 2,
                child: SizedBox(
                  child: buildFireBasePartList(context),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showUpdateMileage(car),
          tooltip: 'Update your car mileage regularly!',
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          child: Icon(Icons.directions_car),
        ),
      ),
    );
  }

  Widget buildFireBaseCar(context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 1,
          child: Container(
            height: 200,
            width: 500,
            decoration: BoxDecoration(boxShadow: [
              new BoxShadow(
                color: Colors.black,
                blurRadius: 1.0,
              )
            ]),
            child: Card(
              child: Image.asset(
                'assets/images/dashboard_MyCar.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment(-0.5, 0),
          child: Text(
            'Meu Carro\n\n' + 'Audi A5\n' + '21.114 Km',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
            //fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  Widget buildFireBasePartList(context) {
    return FirebaseAnimatedList(
      key: new ValueKey<bool>(_anchorToBottom),
      query: partRealtime.getPartFromCar(car.key),
      reverse: _anchorToBottom,
      sort: _anchorToBottom
          ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
          : null,
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
          Animation<double> animation, int index) {
        return new SizeTransition(
          sizeFactor: animation,
          child: showPart(snapshot),
        );
      },
    );
  }

  void addPart(Part part) {
    setState(() {
      partRealtime.add(part);
    });
  }

  void update(Part part) {
    setState(() {
      partRealtime.update(part);
    });
  }

  void newMileage(Car car) {
    setState(() {
      carRealtime.update(car);
    });
  }

  //It will display a item in the list of parts.

  Widget showPart(DataSnapshot res) {
    Part part = Part.fromSnapshot(res);
    double kmLeft = double.parse(getKmLeft(part, true));
    bool isAlert = kmLeft > 10 ? false : true;
    var item = new Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: new Container(
        decoration: BoxDecoration(
            color: isAlert ? Colors.red[50] : Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              new BoxShadow(
                color: Colors.black,
                blurRadius: 5.0,
              )
            ]),
        child: new Center(
          child: new Row(
            children: <Widget>[
              new Container(
                child: new CircularPercentIndicator(
                  radius: 70.0,
                  lineWidth: 6.0,
                  percent: kmLeft / 100,
                  center: new Text(
                    kmLeft == 0 ? '0%' : kmLeft.toStringAsFixed(2) + '%',
                    style: new TextStyle(
                        color: Colors.black, fontFamily: "Poppins-Medium"),
                  ),
                  progressColor: kmLeft > 65
                      ? Colors.lightBlueAccent[400]
                      : kmLeft > 30
                          ? Colors.yellow
                          : kmLeft > 10 ? Colors.orange : Colors.red,
                ),
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                            new BorderSide(width: 1.0, color: Colors.black26))),
              ),
              new Expanded(
                child: new Padding(
                  padding: EdgeInsets.all(10.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        part.name,
                        // set some style to text
                        style: new TextStyle(
                            fontSize: 17.0,
                            color: Colors.black,
                            fontFamily: "Poppins-Bold"),
                      ),
                      new Text(
                        'LifeSpam: ' +
                            numberFormat
                                .format(part.lifeSpam)
                                .toString() +
                            'KM',
                        // set some style to text
                        style: new TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey,
                            fontFamily: "Poppins-Medium"),
                      ),
                      new Text(
                        'KM Remaining: ' +
                            numberFormat
                                .format(int.parse(getKmLeft(part, false)))
                                .toString() +
                            'KM',
                        // set some style to text
                        style: new TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey,
                            fontFamily: "Poppins-Medium"),
                      ),
                    ],
                  ),
                ),
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                    onPressed: () => showEditWidget(part, true),
                  ),
                  new IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    onPressed: () => showAlertDialog(
                        context, 'Really delete this part?', part),
                  ),
                ],
              ),
            ],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(10.0, 3.0, 0.0, 0.0),
      ),
    );

    return item;
  }

  showAlertDialog(BuildContext context, String message, Part part) {
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
              fontSize: 16.0,
              letterSpacing: 0.3,
              fontFamily: "Poppins-Medium"),
        ),
      );
      return loginBtn;
    }

    cancel(BuildContext context) {
      Navigator.of(context).pop();
    }

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      content: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(message),
            Container(
              child: Row(
                children: <Widget>[
                  new GestureDetector(
                    onTap: () => cancel(context),
                    child: new Container(
                      width: 96,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: getAppBorderButton(
                          'Cancel', EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
                    ),
                  ),
                  new GestureDetector(
                    onTap: () =>
                        part != null ? deletePart(part) : cancel(context),
                    child: new Container(
                      width: 96,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: getAppBorderButton(
                          'Ok', EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void logoff() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserLogin()));
  }

  //Get first letter from the name of part
  String getShortName(Part part) {
    String shortName = "";
    if (part.name.isNotEmpty) {
      shortName = part.name.substring(0, 1);
    }
    return shortName;
  }

  //Calcs KM left for next fix
  String getKmLeft(Part part, bool isPercentage) {
    int registeredKM = part.registeredKM;
    int lifeSpam = part.lifeSpam;
    int mileage = car.mileage;
    int result = ((registeredKM - mileage) + lifeSpam);
    if (result < 0) {
      return 0.toString();
    } else {
      return isPercentage
          ? result < lifeSpam
              ? ((result / lifeSpam) * 100).toString()
              : 100.toString()
          : result.toString();
    }
  }

  //Display popup in part info update mode.
  showEditWidget(Part part, bool isEdit) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          buildAboutDialog(context, isEdit, part, car),
    );
  }

  showUpdateMileage(Car car) {
    showDialog(
      context: context,
      builder: (BuildContext context) => buildUpdateMileage(context, car),
    );
  }

  //Delete a entry from the Firebase console.
  deletePart(Part part) {
    Navigator.of(context).pop();
    setState(() {
      partRealtime.delete(part);
    });
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget buildAboutDialog(
      BuildContext context, bool isEdit, Part part, Car car) {
    if (part != null) {
      this.part = part;
      teName.text = part.name;
      teLifeSpam.text = part.lifeSpam.toString();
    } else if (isFirstOpen) {
      teName.text = '';
      teLifeSpam.text = '';
      isFirstOpen = false;
    }
    return new Form(
      key: _key,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: new Text(
          isEdit ? 'Edit part' : 'Add new part',
          style: new TextStyle(fontFamily: "Poppins-Medium"),
        ),
        content: new SingleChildScrollView(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Part Name",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              getTextField("name", teName, false),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text("LifeSpam",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              getTextField("lifespam", teLifeSpam, true),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              new GestureDetector(
                onTap: () => onTap(isEdit, context),
                child: new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: getAppBorderButton(isEdit ? "Edit" : "Add",
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUpdateMileage(BuildContext context, Car car) {
    teMileage.text = '';
    return new Form(
      key: _key,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: new Text(
          'Update Mileage',
          style: new TextStyle(fontFamily: "Poppins-Medium"),
        ),
        content: new SingleChildScrollView(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Mileage",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              getTextField(car.mileage.toString(), teMileage, true),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              new GestureDetector(
                onTap: () => updateMileage(context),
                child: new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: getAppBorderButton('Update Mileage :)',
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTextField(String inputBoxName,
      TextEditingController inputBoxController, bool isNumberOnly) {
    var btnAdd = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        validator: (value) {
          if (value.isEmpty) return 'Please enter some text';
          if (inputBoxName == "name") {
            if (teName.text.length > 100) return 'Maximum characters exceeded';
          }
          if (inputBoxName == "lifespam") {
            if (teLifeSpam.text.contains('-') || teLifeSpam.text.contains('.'))
              return 'Please insert numbers only';
          }
          return null;
        },
        style: TextStyle(fontSize: 12.0, fontFamily: "Poppins-Medium"),
        keyboardType: isNumberOnly ? TextInputType.number : TextInputType.text,
        controller: inputBoxController,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
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
            fontSize: 16.0,
            letterSpacing: 0.3,
            fontFamily: "Poppins-Medium"),
      ),
    );
    return loginBtn;
  }

  Part getData() => new Part(car.key, teName.text, car.mileage, int.parse(teLifeSpam.text));

  Part updateData(Part part) {
    part.name = teName.text;
    part.lifeSpam = int.parse(teLifeSpam.text);
    return part;
  }

  Car updateMileageData(Car car) {
    car.mileage = int.parse(teMileage.text);
    return car;
  }

  onTap(bool isEdit, BuildContext context) {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      if (isEdit) {
        update(updateData(part));
      } else {
        addPart(getData());
      }
      Navigator.of(context).pop();
    }
  }

  updateMileage(BuildContext context) {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      newMileage(updateMileageData(car));
      Navigator.of(context).pop();
      showFloatingFlushbar(context, true, 'Mileage updated!');
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

class AppDrawer extends StatefulWidget {
  final Car car;
  const AppDrawer({Key key, this.car}) : super(key: key);
  @override
  _AppDrawerState createState() => new _AppDrawerState(car);
}

class _AppDrawerState extends State<AppDrawer> {
  final Car car;
  _AppDrawerState(this.car);

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
          children: ListTile.divideTiles(
        context: context,
        tiles: [
          new Stack(children: <Widget>[
            Container(
              child: FittedBox(
                child: Image.asset('assets/images/bluedrawer.png'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(50,80,0,0),
                child: Text("AUTO TECH",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins-Medium",
                        fontSize: ScreenUtil.getInstance().setSp(46),
                        letterSpacing: .6,
                        fontWeight: FontWeight.bold)))
          ]),
          new ListTile(
            title: new Text('My Car'),
            onTap: () => openMyCar(),
          ),
          // new ListTile(
          //   title: new Text('My Account'),
          //   //onTap: openMyCar(),
          // ),
          new ListTile(
            title: new Text('Auto Tech help'),
            //onTap: openMyCar(),
          ),
          new ListTile(
            title: new Text('Logoff'),
            onTap: () =>
                showAlertDialog(context, 'Do you really want to log off?'),
          ),
        ],
      ).toList()),
    );
  }

  showAlertDialog(BuildContext context, String message) {
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
              fontSize: 16.0,
              letterSpacing: 0.3,
              fontFamily: "Poppins-Medium"),
        ),
      );
      return loginBtn;
    }

    cancel(BuildContext context) {
      Navigator.of(context).pop();
    }

    confirm(BuildContext context) {
      Navigator.of(context).pop();
      logoff();
    }

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      content: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(message),
            Container(
              child: Row(
                children: <Widget>[
                  new GestureDetector(
                    onTap: () => cancel(context),
                    child: new Container(
                      width: ScreenUtil.getInstance().setWidth(185),
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: getAppBorderButton(
                          'Cancel', EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
                    ),
                  ),
                  new GestureDetector(
                    onTap: () => confirm(context),
                    child: new Container(
                      width: ScreenUtil.getInstance().setWidth(170),
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: getAppBorderButton(
                          'Ok', EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void openMyCar() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CarRegister(isEdit: true, car: car)));
  }

  void logoff() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserLogin()));
  }
}
