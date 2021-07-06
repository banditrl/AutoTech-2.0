import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:flutter/material.dart';

class RadioButton extends StatelessWidget with ResponsiveMixin {
  final bool checked;
  final String text;
  final Function onTap;

  const RadioButton({Key key, this.checked, this.text, this.onTap})
      : super(key: key);

 Container buildRadioInnerBall(bool checked) {
    if (checked) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
      );
    }
    return null;
  }

  buildRadioText(String text) {
    if (text != null)
      return Text(
        text,
        style: TextStyle(
          fontSize: responsiveFont(25),
          fontFamily: "Poppins-Medium",
        ),
      );
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 12.0,
        ),
        GestureDetector(
          onTap: () => onTap?.call(),
          child: Container(
            width: 16.0,
            height: 16.0,
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 2.0,
                color: Colors.black,
              ),
            ),
            child: buildRadioInnerBall(checked),
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        buildRadioText(text),
      ],
    );
  }
}
