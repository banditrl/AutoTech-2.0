import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget with Responsive {
  final double width;
  final double height;
  final double horizontalPadding;

  const HorizontalLine({Key key, this.width, this.height = 1, this.horizontalPadding = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        width: responsiveWidth(width),
        height: height,
        color: Colors.black26.withOpacity(.2),
      ),
    );
  }
}
