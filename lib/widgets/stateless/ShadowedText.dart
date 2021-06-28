import 'package:flutter/material.dart';

class ShadowedText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;

  const ShadowedText(
    this.text, {
    Key key,
    this.size = 18.0,
    this.fontWeight = FontWeight.w400,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: size,
        fontWeight: fontWeight,
        letterSpacing: 2,
        shadows: [
          Shadow(
            offset: Offset.fromDirection(5),
            color: Colors.black,
            blurRadius: 3,
          ),
        ],
      ),
    );
  }
}
