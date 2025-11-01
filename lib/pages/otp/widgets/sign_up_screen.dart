import 'package:flutter/material.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/static/icon.dart';

import '../../../utils/sizer_utils.dart';
import '../../../widgets/base/button/common_button.dart';
import '../../../widgets/base/text/common_text.dart';
import '../../../widgets/base/textfield/common_textformfield.dart';
import 'otp_verification_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (context) => const SignUpScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.of(context).bgScaffold,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: AppSizes.setHeight(63),
              horizontal: AppSizes.setWidth(21)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    AssetsIcon.IC_LEFT_ARROW,
                    width: AppSizes.setWidth(20),
                    height: AppSizes.setHeight(20),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: AppSizes.setHeight(65),
                  bottom: AppSizes.setHeight(25),
                ),
                child: CommonText(
                  text: '注册',
                  fontWeight: FontWeight.w800,
                  fontSize: AppSizes.setFontSize(35),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: AppSizes.setHeight(55),
                    left: AppSizes.setWidth(10),
                    right: AppSizes.setWidth(10)),
                child: CommonText(
                  text: '请输入您的手机号码，我们将发送4位验证码到您的手机号码以验证您的账户',
                  fontWeight: FontWeight.w600,
                  fontSize: AppSizes.setFontSize(15),
                  textColor: CustomAppColor.of(context).txtGrey,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(30)),
                child: CommonTextFormField(
                  isPhoneNumberField: true,
                  borderColor: CustomAppColor.of(context).textFieldBorder,
                  hintText: '手机号码',
                ),
              ),
              IgnorePointer(
                ignoring: true,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: AppSizes.setHeight(35)),
                  child: CommonButton(
                    onTap: () => Navigator.push(
                      context,
                      OtpVerificationScreen.route(),
                    ),
                    btnText: '发送验证码',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
