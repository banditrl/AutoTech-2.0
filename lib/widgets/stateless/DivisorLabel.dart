import 'package:flutter/material.dart';

import 'HorizontalLine.dart';

class DivisorLabel extends StatelessWidget {
  final String text;
  final double lineWidth;

  const DivisorLabel(this.text, {Key key, this.lineWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        HorizontalLine(
          width: lineWidth,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: "Poppins-Medium",
          ),
        ),
        HorizontalLine(
          width: lineWidth,
        ),
      ],
    );
  }
}
