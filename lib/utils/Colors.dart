import 'package:flutter/cupertino.dart';

LinearGradient defaultHorizontalGradient() => LinearGradient(
      colors: [
        defaultDarkColor(),
        defaultLightColor(),
      ],
    );

LinearGradient defaultVerticalGradient() => LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        defaultDarkColor(),
        defaultLightColor(),
      ],
    );

Color defaultLightColor() => Color.fromRGBO(96, 120, 234, 1.0);

Color defaultDarkColor() => Color.fromRGBO(58, 66, 86, 1.0);
