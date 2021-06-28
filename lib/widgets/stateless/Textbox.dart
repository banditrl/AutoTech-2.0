import 'package:flutter/material.dart';

class Textbox extends StatelessWidget {
  final TextEditingController textController;
  final bool obscureText;
  final TextInputType inputType;
  final Function validation;
  final String textName;

  Textbox(
      {Key key,
      this.textController,
      this.obscureText = false,
      this.inputType = TextInputType.text,
      this.validation,
      this.textName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        obscureText: obscureText,
        controller: textController,
        keyboardType: inputType,
        validator: (value) {
          if (validation != null) return validation.call(value);
          return null;
        },
        decoration: new InputDecoration(
          hintText: textName,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
        ),
      ),
    );
  }
}
