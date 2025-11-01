import 'package:flutter/material.dart';

import '../../../resources/colors.dart';
import '../../../utils/sizer_utils.dart';
import '../../../widgets/base/button/common_button.dart';
import '../../../widgets/base/text/common_text.dart';
import '../../../widgets/base/textfield/common_digit_textformfield.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
        builder: (context) => const OtpVerificationScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(22)),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: AppSizes.setHeight(150)),
                child: CommonText(
                  text: 'OTP验证',
                  fontSize: AppSizes.setFontSize(35),
                  fontWeight: FontWeight.w800,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: AppSizes.setHeight(25)),
                child: CommonText(
                  text: '请输入我们发送给您的4位验证码',
                  fontSize: AppSizes.setFontSize(15),
                  fontWeight: FontWeight.w600,
                  textColor: CustomAppColor.of(context).txtGrey,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: AppSizes.setHeight(7)),
                child: CommonText(
                  text: '手机号码',
                  fontSize: AppSizes.setFontSize(15),
                  fontWeight: FontWeight.w600,
                  textColor: CustomAppColor.of(context).txtBlack,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(52)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: AppSizes.setWidth(58),
                      height: AppSizes.setHeight(60),
                      child: SingleDigitTextField(
                        controller: TextEditingController(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: AppSizes.setWidth(32)),
                      child: SizedBox(
                        width: AppSizes.setWidth(58),
                        height: AppSizes.setHeight(60),
                        child: SingleDigitTextField(
                          controller: TextEditingController(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: AppSizes.setWidth(32)),
                      child: SizedBox(
                        width: AppSizes.setWidth(58),
                        height: AppSizes.setHeight(60),
                        child: SingleDigitTextField(
                          controller: TextEditingController(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: AppSizes.setWidth(32)),
                      child: SizedBox(
                        width: AppSizes.setWidth(58),
                        height: AppSizes.setHeight(60),
                        child: SingleDigitTextField(
                          controller: TextEditingController(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: AppSizes.setHeight(7)),
                child: CommonText(
                  text: '没有收到验证码？',
                  fontSize: AppSizes.setFontSize(15),
                  fontWeight: FontWeight.w600,
                  textColor: CustomAppColor.of(context).txtGrey,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: AppSizes.setHeight(7)),
                child: CommonText(
                  text: '重新发送验证码',
                  fontSize: AppSizes.setFontSize(15),
                  fontWeight: FontWeight.w600,
                  textColor: CustomAppColor.of(context).txtPurple,
                  textDecoration: TextDecoration.underline,
                ),
              ),
              IgnorePointer(
                ignoring: true,
                child: Padding(
                  padding: EdgeInsets.only(top: AppSizes.setHeight(143)),
                  child: CommonButton(
                    btnText: '继续',
                    onTap: () => {},
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: AppSizes.setHeight(39),
                    left: AppSizes.setWidth(41),
                    right: AppSizes.setWidth(30)),
                child: CommonText(
                  text: '通过继续，您同意Gozzy的',
                  fontSize: AppSizes.setFontSize(15),
                  fontWeight: FontWeight.w600,
                  textColor: CustomAppColor.of(context).txtGrey,
                ),
              ),
              CommonText(
                text: '条款和条件和隐私政策',
                fontSize: AppSizes.setFontSize(15),
                fontWeight: FontWeight.w600,
                textColor: CustomAppColor.of(context).txtGrey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
