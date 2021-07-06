import 'package:auto_tech/mixins/ResponsiveScreen.dart';
import 'package:auto_tech/widgets/stateless/Textbox.dart';
import 'package:flutter/material.dart';

class CarRegisterForm extends StatelessWidget with ResponsiveMixin {
  final TextEditingController teBrand;
  final TextEditingController teModel;
  final TextEditingController teDescription;
  final TextEditingController teYear;
  final TextEditingController teMileage;
  final bool hasCarRegistered;

  const CarRegisterForm(
      {Key key,
      this.teBrand,
      this.teModel,
      this.teDescription,
      this.teYear,
      this.teMileage,
      this.hasCarRegistered})
      : super(key: key);
  
  static final _nullValidation = (value) => value.isEmpty ? 'Please enter some text' : null;

  Widget _buildFormTitle() {
    if (hasCarRegistered) return Container();

    return Text(
      "Car Register",
      style: TextStyle(
        fontSize: responsiveFont(45),
        fontFamily: "Poppins-Bold",
        letterSpacing: .6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildFormTitle(),
            Textbox(
              textController: teBrand,
              spacing: 15,
              textLabel: "Brand",
              textHint: "ex: Audi",
              enabled: !hasCarRegistered,
              validation: _nullValidation,
            ),
            Textbox(
              textController: teModel,
              spacing: 15,
              textLabel: "Model",
              textHint: "ex: A5",
              enabled: !hasCarRegistered,
              validation: _nullValidation,
            ),
            Textbox(
              textController: teDescription,
              spacing: 15,
              textLabel: "Description",
              textHint: "ex: White 2.0 TURBO",
              enabled: !hasCarRegistered,
              validation: _nullValidation,
            ),
            Textbox(
              textController: teYear,
              spacing: 15,
              textLabel: "Year",
              enabled: !hasCarRegistered,
              inputType: TextInputType.number,
              validation: _nullValidation,
            ),
            Textbox(
              textController: teMileage,
              spacing: 15,
              textLabel: "Mileage",
              textHint: "ex: 21500",
              enabled: !hasCarRegistered,
              inputType: TextInputType.number,
              validation: _nullValidation,
            ),
          ],
        ),
      ),
    );
  }
}
