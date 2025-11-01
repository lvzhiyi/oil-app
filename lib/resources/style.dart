import 'package:flutter/material.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/pt.dart';

extension SportsTextStyle on TextStyle {
  static const fontFamily = 'PingFang SC';

  static final TextStyle baseNormal = TextStyle(
      fontFamily: SportsTextStyle.fontFamily,
      color: AppColor.txtWhite,
      fontSize: pt(14));

  static final TextStyle baseBold = TextStyle(
      fontFamily: SportsTextStyle.fontFamily,
      fontWeight: FontWeight.w600,
      color: AppColor.txtWhite,
      fontSize: pt(14));

  static final TextStyle grayNormal = TextStyle(
      fontFamily: SportsTextStyle.fontFamily,
      color: AppColor.textFieldBorder,
      fontSize: pt(14));

  static final TextStyle grayBold = TextStyle(
      fontFamily: SportsTextStyle.fontFamily,
      fontWeight: FontWeight.w600,
      color: AppColor.textFieldBorder,
      fontSize: pt(14));

  static final TextStyle blueNormal = TextStyle(
      fontFamily: SportsTextStyle.fontFamily,
      color: AppColor.btnPurple,
      fontSize: pt(14));

  static final TextStyle blueBold = TextStyle(
      fontFamily: SportsTextStyle.fontFamily,
      fontWeight: FontWeight.w600,
      color: AppColor.btnPurple,
      fontSize: pt(14));
}
