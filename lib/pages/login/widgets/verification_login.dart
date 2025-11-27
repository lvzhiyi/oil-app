import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/static/icon.dart';

import '../../../utils/sizer_utils.dart';
import '../../../widgets/base/button/common_button.dart';
import '../../../widgets/base/text/common_text.dart';
import '../../../widgets/base/textfield/common_textformfield.dart';

class VerificationLoginScreen extends StatefulWidget {
  const VerificationLoginScreen({super.key});

  @override
  State<VerificationLoginScreen> createState() =>
      _VerificationLoginScreenState();
}

class _VerificationLoginScreenState extends State<VerificationLoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final phoneController = TextEditingController();

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
                  text: '登录',
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
                  controller: phoneController,
                  isPhoneNumberField: false,
                  enabled: true,
                  borderColor: CustomAppColor.of(context).textFieldBorder,
                  hintText: '手机号码',
                  keyboardType: TextInputType.phone,
                  inputFormatter: FilteringTextInputFormatter.digitsOnly,
                  maxLength: 11,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(35)),
                child: CommonButton(
                  radius: 26,
                  onTap: () => {
                    BaseRouter.push(url: AppPage.otpPage.path, extra: {
                      "type": "login",
                      "phone": phoneController.text,
                    }),
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
