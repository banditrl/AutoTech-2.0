import 'package:flutter/material.dart';

final _responsive = _ResponsiveScreen();

class _ResponsiveScreen {
  int width;
  int height;
  bool allowFontScaling;

  static double _screenWidth;
  static double _screenHeight;
  static double _pixelRatio;
  static double _statusBarHeight;
  static double _bottomBarHeight;
  static double _textScaleFactor;

  _ResponsiveScreen({
    this.width = 750,
    this.height = 1334,
    this.allowFontScaling = true,
  });

  void init(BuildContext context) {
    MediaQueryData _mediaQuery = MediaQuery.of(context);
    _pixelRatio = _mediaQuery.devicePixelRatio;
    _screenWidth = _mediaQuery.size.width;
    _screenHeight = _mediaQuery.size.height;
    _statusBarHeight = _mediaQuery.padding.top;
    _bottomBarHeight = _mediaQuery.padding.bottom;
    _textScaleFactor = _mediaQuery.textScaleFactor;
  }

  double get pixelRatio => _pixelRatio;

  double get screenWidthDp => _screenWidth;

  double get screenHeightDp => _screenHeight;

  double get screenWidth => _screenWidth * _pixelRatio;

  double get screenHeight => _screenHeight * _pixelRatio;

  double get statusBarHeight => _statusBarHeight * _pixelRatio;

  double get bottomBarHeight => _bottomBarHeight * _pixelRatio;

  double get scaleWidth => _screenWidth / this.width;

  double get scaleHeight => _screenHeight / this.height;

  double get textScaleFactor => _textScaleFactor;
}

mixin ResponsiveMixin {
  void responsiveInit(BuildContext context) => _responsive.init(context);

  double responsiveWidth(double width) => width * _responsive.scaleWidth;

  double responsiveHeight(double height) => height * _responsive.scaleHeight;

  double responsiveFont(double fontSize) {
    if (_responsive.allowFontScaling) return responsiveWidth(fontSize);
    return responsiveWidth(fontSize) / _responsive.textScaleFactor;
  }
}
