import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Popup extends StatelessWidget {
  final String title;
  final List<Widget> content;

  const Popup({Key key, this.title, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: new Text(
        title,
        style: new TextStyle(fontFamily: "Poppins-Medium"),
      ),
      content: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content,
        ),
      ),
    );
  }
}
