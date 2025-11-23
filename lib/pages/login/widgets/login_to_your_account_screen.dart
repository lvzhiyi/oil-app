import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:oil_business_app/pages/login/controller.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/common_richtext/common_richtext.dart';
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
    final ctrl = context.read<LoginCtrl>();

    return Scaffold(
      backgroundColor: Colors.white,
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
                padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(15)),
                child: CommonText(
                  text: '登录到您的账户',
                  fontWeight: FontWeight.w700,
                  fontSize: AppSizes.setFontSize(24),
                ),
              ),
              FormBuilder(
                key: ctrl.formKey,
                child: Column(
                  children: [
                    CommonTextFormField(
                      name: 'phone',
                      borderColor: CustomAppColor.of(context).textFieldBorder,
                      leadingIcon: Image.asset(
                        AssetsIcon.IC_PROFILE,
                        width: AppSizes.setHeight(20),
                        height: AppSizes.setHeight(20),
                      ),
                      hintText: '账号',
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: AppSizes.setHeight(16)),
                      child: CommonTextFormField(
                        name: 'password',
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: AppSizes.setHeight(32)),
                child: CommonButton(
                    btnText: '登录',
                    onTap: () => {
                          ctrl.submit(),
                        }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: AppSizes.setHeight(10)),
                    child: TextButton(
                      onPressed: () => {
                        BaseRouter.push(
                            url: AppPage.verificationLoginPage.path),
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
                                url: AppPage.registerPage.path, extra: null),
                          },
                          child: CommonText(
                            text: '注册',
                            textColor: CustomAppColor.of(context).txtPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: AppSizes.setWidth(160),
                    bottom: AppSizes.setHeight(15)),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: CustomAppColor.of(context).dividerGrey,
                        thickness: 2,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: CustomAppColor.of(context).dividerGrey,
                        thickness: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(),
                child: CommonText(
                  text: '通过登录，您将同意买油呗的',
                  fontSize: AppSizes.setFontSize(15),
                  fontWeight: FontWeight.w600,
                  textColor: CustomAppColor.of(context).txtGrey,
                ),
              ),
              SizedBox(height: AppSizes.setHeight(5)),
              const CommonRichText(
                firstText: '条款和条件',
                middleText: '和',
                lastText: '隐私政策',
              )
            ],
          ),
        ),
      ),
    );
  }
}
