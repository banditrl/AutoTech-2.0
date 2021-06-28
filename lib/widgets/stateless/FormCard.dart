import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final ScreenUtil screenUtil = ScreenUtil.getInstance();

class FormCard extends StatelessWidget with ResponsiveMixin {
  final List<Widget> content;
  final double height;

  const FormCard({Key key, this.content, this.height = 500}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: Container(
        width: double.infinity,
        height: responsiveHeight(height),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(58, 66, 86, 1.0),
              offset: Offset(0.0, 15.0),
              blurRadius: 15.0,
            ),
            BoxShadow(
              color: Color.fromRGBO(58, 66, 86, 1.0),
              offset: Offset(0.0, -10.0),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content,
          ),
        ),
      ),
    );
  }
}
