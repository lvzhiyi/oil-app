import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/otp/controller.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/static/icon.dart';

import '../../../utils/sizer_utils.dart';
import '../../../widgets/base/button/common_button.dart';
import '../../../widgets/base/text/common_text.dart';
import '../../../widgets/base/textfield/common_textformfield.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key, this.extra});
  final Map<String, dynamic>? extra;

  static Route route() {
    return MaterialPageRoute(builder: (context) => const SignUpScreen());
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<OtpCtrl>();

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
                  onTap: () => BaseRouter.pop(),
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
                  text: extra?["type"] == "register" ? '注册' : '登录',
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
                  controller: ctrl.phoneController,
                  isPhoneNumberField: true,
                  borderColor: CustomAppColor.of(context).textFieldBorder,
                  hintText: '手机号码',
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(35)),
                child: CommonButton(
                  onTap: () => {
                    ctrl.sendOtp(type: extra?["type"]),
                  },
                  btnText: '发送验证码',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
