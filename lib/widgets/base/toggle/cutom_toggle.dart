import 'package:flutter/material.dart';
import 'package:oil_business_app/utils/utils.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import '../text/common_text.dart';

class ToggleButtonWidget extends StatefulWidget {
  const ToggleButtonWidget({super.key});

  @override
  ToggleButtonWidgetState createState() => ToggleButtonWidgetState();
}

class ToggleButtonWidgetState extends State<ToggleButtonWidget> {
  bool isEmailSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(8)),
      width: AppSizes.setWidth(281),
      height: AppSizes.setHeight(48),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).btnPurple.withOpacityPercent(0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isEmailSelected = true;
                });
              },
              child: Container(
                width: AppSizes.setWidth(134),
                height: AppSizes.setHeight(36),
                decoration: BoxDecoration(
                  color: isEmailSelected
                      ? CustomAppColor.of(context).btnPurple
                      : CustomAppColor.of(context).transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: CommonText(
                  text: 'eMail',
                  textColor: isEmailSelected
                      ? CustomAppColor.of(context).txtWhite
                      : CustomAppColor.of(context).txtPurple,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Mobile Number Button
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isEmailSelected = false;
                });
              },
              child: Container(
                width: AppSizes.setWidth(134),
                height: AppSizes.setHeight(36),
                decoration: BoxDecoration(
                  color: !isEmailSelected
                      ? const Color(0xFF7A58FF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: CommonText(
                  text: 'mobileNumber',
                  textColor: isEmailSelected
                      ? CustomAppColor.of(context).txtPurple
                      : CustomAppColor.of(context).txtWhite,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
