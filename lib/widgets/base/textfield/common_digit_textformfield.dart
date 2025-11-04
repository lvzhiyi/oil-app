import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oil_business_app/utils/utils.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/constant.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';

class SingleDigitTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  const SingleDigitTextField(
      {super.key, required this.controller, this.focusNode});

  @override
  SingleDigitTextFieldState createState() => SingleDigitTextFieldState();
}

class SingleDigitTextFieldState extends State<SingleDigitTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = widget.focusNode?.hasFocus ?? false
        ? CustomAppColor.of(context).borderGrey
        : CustomAppColor.of(context).borderGrey;

    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      // obscuringCharacter: '●',
      // obscureText: true,
      style: TextStyle(
          fontSize: AppSizes.setFontSize(24),
          fontWeight: FontWeight.w700,
          fontFamily: Constant.fontFamilyUrbanist,
          color: CustomAppColor.of(context).txtPurple),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(1),
      ],
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.focusNode?.hasFocus ?? false
            ? AppColor.white.withOpacityPercent(0.2)
            : CustomAppColor.of(context).bgScaffold,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: CustomAppColor.of(context).bgContainer),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
              color: CustomAppColor.of(context).bgContainer, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: AppSizes.setHeight(10),
            horizontal: AppSizes.setWidth(10)),
      ),
    );
  }
}
