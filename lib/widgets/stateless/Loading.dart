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
    return [
      SpinKitRing(
        color: color,
        size: size,
        lineWidth: 3.0,
      ),
      _addText(),
    ];
  }

  Widget _addText() {
    if (text == null) return null;

    return Container(
      padding: EdgeInsets.only(top: 20.0, right: 50.0),
      child: Center(
        child: Text(
          text,
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Poppins-Bold",
            fontSize: 14.0,
            color: textColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (textAxis == Axis.vertical)
      return Column(
        children: _buildWidgets(),
      );

    return Row(
      children: _buildWidgets(),
    );
  }
}
