import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:flutter/material.dart';

class Textbox extends StatelessWidget with ResponsiveMixin {
  final TextEditingController textController;
  final bool enabled;
  final bool obscureText;
  final TextInputType inputType;
  final Function validation;
  final String textLabel;
  final String textHint;
  final double spacing;

  const Textbox({
    Key key,
    this.textController,
    this.enabled = true,
    this.obscureText = false,
    this.inputType = TextInputType.text,
    this.validation,
    this.textLabel,
    this.textHint,
    this.spacing = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: [
        SizedBox(
          height: responsiveHeight(spacing),
        ),
        Text(
          textLabel,
          style: TextStyle(
            fontFamily: "Poppins-Medium",
            fontSize: responsiveFont(26),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: new TextFormField(
            controller: textController,
            enabled: enabled,
            obscureText: obscureText,
            keyboardType: inputType,
            validator: (value) => validation?.call(value),
            decoration: new InputDecoration(
              hintText: textHint != null ? textHint : textLabel.toLowerCase(),
              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
            ),
          ),
        ),
        SizedBox(
          height: responsiveHeight(spacing),
        ),
      ],
    );
  }
}
