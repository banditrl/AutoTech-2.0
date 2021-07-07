import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:auto_tech/utils/Colors.dart';
import 'package:flutter/material.dart';

class ButtonLabel extends StatelessWidget with Responsive {
  final Function onTap;
  final String text;

  const ButtonLabel(this.text, {Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Text(
        text,
        style: TextStyle(
          color: defaultLightColor(),
          fontFamily: "Poppins-Bold",
        ),
      ),
    );
  }
}
