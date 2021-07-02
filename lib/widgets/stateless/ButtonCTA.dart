import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:auto_tech/utils/Colors.dart';
import 'package:flutter/material.dart';

import 'ShadowedText.dart';

class ButtonCTA extends StatelessWidget with ResponsiveMixin {
  final Function onTap;
  final String text;
  final double width;
  final double height;

  const ButtonCTA(this.text, {Key key, this.onTap, this.width = 330, this.height = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: responsiveWidth(width),
        height: responsiveHeight(height),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              defaultDarkColor(),
              defaultLightColor(),
            ],
          ),
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF6078ea).withOpacity(.3),
              offset: Offset(0.0, 8.0),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap?.call(),
            child: Center(
              child: ShadowedText(text),
            ),
          ),
        ),
      ),
    );
  }
}
