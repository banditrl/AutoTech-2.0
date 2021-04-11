import 'package:flutter/material.dart';

import 'pages/SplashScreen.dart';
import 'widgets/stateless/PortraitMode.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget with PortraitModeMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      title: 'Auto Tech',
      theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
      home: SplashScreen(),
    );
  }
}
