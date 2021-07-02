import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:flutter/material.dart';

class RadioButton extends StatefulWidget {
  final bool checked;
  final String text;

  const RadioButton({Key key, this.checked = false, this.text})
      : super(key: key);

  @override
  _RadioButtonState createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> with ResponsiveMixin {
  var _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.checked;
  }

  @override
  void dispose() {
    super.dispose();
  }

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
          onTap: () => setState(() => _checked = !_checked),
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
            child: buildRadioInnerBall(_checked),
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        buildRadioText(widget.text),
      ],
    );
  }
}
