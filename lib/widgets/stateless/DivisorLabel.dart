import 'package:flutter/material.dart';

import 'HorizontalLine.dart';

class DivisorLabel extends StatelessWidget {
  final String text;

  const DivisorLabel(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        HorizontalLine(),
        Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: "Poppins-Medium",
          ),
        ),
        HorizontalLine(),
      ],
    );
  }
}
