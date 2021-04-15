import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final Color color;
  final double size;
  final String text;
  final Color textColor;
  final Axis textAxis;

  const Loading(
      {Key key,
      this.color = Colors.black87,
      this.size = 50.0,
      this.text,
      this.textColor = Colors.black87,
      this.textAxis = Axis.vertical})
      : super(key: key);

  List<Widget> _buildWidgets() {
    var widgets = new List<Widget>();

    widgets.add(
      SpinKitRing(
        color: color,
        size: size,
        lineWidth: 3.0,
      ),
    );

    if (text != null) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(top: 20.0, right: 50.0),
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
    return textAxis == Axis.vertical
        ? Column(
            children: _buildWidgets(),
          )
        : Row(
            children: _buildWidgets(),
          );
  }
}
