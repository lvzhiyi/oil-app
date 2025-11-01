import 'package:flutter/material.dart';

import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/constant.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';

class CommonRichText extends StatelessWidget {
  final String firstText;
  final String middleText;
  final String lastText;

  const CommonRichText({
    super.key,
    required this.firstText,
    required this.middleText,
    required this.lastText,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        style: TextStyle(
          fontFamily: Constant.fontFamilyUrbanist,
          color: CustomAppColor.of(context).txtPurple,
          fontSize: AppSizes.setFontSize(15),
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(text: firstText),
          TextSpan(
            text: middleText,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: AppSizes.setFontSize(15),
              color: CustomAppColor.of(context).txtGrey,
            ),
          ),
          TextSpan(text: lastText),
        ],
      ),
    );
  }
}
