import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

mixin Notifications {
  void showSuccessFloatingFlushbar(BuildContext context, String message) {
    var green = [Colors.green.shade800, Colors.greenAccent.shade700];

    _buildFlushBar(Icons.check, green, message)..show(context);
  }

  void showErrorFloatingFlushbar(BuildContext context, String message) {
    var red = [Colors.red.shade800, Colors.redAccent.shade200];

    _buildFlushBar(Icons.clear, red, message)..show(context);
  }

  void showWarningFloatingFlushbar(BuildContext context, String message) {
    var orange = [Colors.orange.shade700, Colors.orangeAccent.shade400];

    _buildFlushBar(Icons.clear, orange, message)..show(context);
  }

  void showInformationFloatingFlushbar(BuildContext context, String message) {
    var colors = [Colors.grey.shade400, Colors.blueGrey.shade100];

    _buildFlushBar(Icons.clear, colors, message)..show(context);
  }

  Flushbar _buildFlushBar(IconData icon, List<Color> colors, String message) {
    return Flushbar(
      margin: EdgeInsets.all(10),
      borderRadius: BorderRadius.all(Radius.circular(8)),
      icon: Icon(icon, size: 20),
      backgroundGradient: LinearGradient(
        colors: colors,
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      message: message,
      duration: Duration(seconds: 3),
    );
  }
}
