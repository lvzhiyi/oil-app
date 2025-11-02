import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/otp/page.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';

class LoginToYourAccountScreen extends StatelessWidget {
  const LoginToYourAccountScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
        builder: (context) => const LoginToYourAccountScreen());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        backgroundColor: CustomAppColor.of(context).bgScaffold,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: AppSizes.setHeight(61)),
                  child: const Align(
                    alignment: Alignment.topLeft,
                    // child: InkWell(
                    //   onTap: () => Navigator.pop(context),
                    //   child: Image.asset(
                    //     AssetsIcon.IC_LEFT_ARROW,
                    //     width: AppSizes.setWidth(20),
                    //     height: AppSizes.setHeight(20),
                    //   ),
                    // ),
                  ),
                ),
                Image.asset(
                  AssetsImg.LOGO,
                  width: AppSizes.setWidth(80),
                  height: AppSizes.setHeight(80),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: AppSizes.setHeight(15)),
                  child: CommonText(
                    text: '登录到您的账户',
                    fontWeight: FontWeight.w700,
                    fontSize: AppSizes.setFontSize(24),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: AppSizes.setHeight(15)),
                  child: CommonTextFormField(
                    borderColor: CustomAppColor.of(context).textFieldBorder,
                    leadingIcon: Image.asset(
                      AssetsIcon.IC_ACCOUNT_BALANCE,
                      width: AppSizes.setHeight(20),
                      height: AppSizes.setHeight(20),
                    ),
                    hintText: '账号',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: AppSizes.setHeight(16)),
                  child: CommonTextFormField(
                    borderColor: CustomAppColor.of(context).textFieldBorder,
                    leadingIcon: Image.asset(
                      AssetsIcon.IC_PASSWORD,
                      width: AppSizes.setHeight(20),
                      height: AppSizes.setHeight(20),
                    ),
                    hintText: '密码',
                    isPasswordField: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: AppSizes.setHeight(32)),
                  child: CommonButton(btnText: '登录', onTap: () => {}
                      // Navigator.push(context, LoginPage.route()),
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: AppSizes.setHeight(10)),
                      child: TextButton(
                        onPressed: () => {
                          BaseRouter.push(url: AppPage.otpPage.path, extra: {
                            "type": "login",
                          }),
                        },
                        child: CommonText(
                          text: "验证码登录",
                          fontSize: AppSizes.setFontSize(14),
                          fontWeight: FontWeight.w600,
                          textColor: CustomAppColor.of(context).txtPurple,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: AppSizes.setHeight(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonText(
                            text: '没有账户？',
                            textColor: CustomAppColor.of(context).txtGrey,
                            fontWeight: FontWeight.w500,
                          ),
                          InkWell(
                            onTap: () => {
                              BaseRouter.push(
                                  url: AppPage.otpPage.path,
                                  extra: {
                                    "type": "register",
                                  }),
                            },
                            child: CommonText(
                              text: '注册',
                              textColor: CustomAppColor.of(context).txtPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
