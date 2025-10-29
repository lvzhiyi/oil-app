import 'package:flutter/material.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/pt.dart';

extension SportsTextStyle on TextStyle {
  static const fontFamily = 'PingFang SC';

  static final TextStyle baseNormal = TextStyle(
      fontFamily: SportsTextStyle.fontFamily,
      color: AppColors.appText,
      fontSize: pt(14));

  static final TextStyle baseBold = TextStyle(
      fontFamily: SportsTextStyle.fontFamily,
      fontWeight: FontWeight.w600,
      color: AppColors.appText,
      fontSize: pt(14));

  static final TextStyle grayNormal = TextStyle(
      fontFamily: SportsTextStyle.fontFamily,
      color: AppColors.inputText,
      fontSize: pt(14));

  static final TextStyle grayBold = TextStyle(
      fontFamily: SportsTextStyle.fontFamily,
      fontWeight: FontWeight.w600,
      color: AppColors.inputText,
      fontSize: pt(14));

  static final TextStyle blueNormal = TextStyle(
      fontFamily: SportsTextStyle.fontFamily,
      color: AppColors.darkBlue,
      fontSize: pt(14));

  static final TextStyle blueBold = TextStyle(
      fontFamily: SportsTextStyle.fontFamily,
      fontWeight: FontWeight.w600,
      color: AppColors.darkBlue,
      fontSize: pt(14));
}
