import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({
    this.color = Colors.black87,
    this.text,
    this.textColor = Colors.black87,
  });
  final Color color;
  final String text;
  final Color textColor;

  List<Widget> buildWidgets() {
    var widgets = new List<Widget>();

    widgets.add(
      SpinKitRing(
        color: color,
        size: 50.0,
        lineWidth: 3.0,
      ),
    );

    if (text != null) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(top: 70.0),
        ),
      );

      widgets.add(
        Center(
          child: Text(
            text,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Poppins-Bold", fontSize: 14.0, color: textColor),
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: buildWidgets(),
    );
  }
}