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
import 'package:flutter/gestures.dart';
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(24)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: AppSizes.setHeight(20)),
                // 品牌头部
                Column(
                  children: [
                    // Logo 盒子
                    Center(
                      child: Image.asset(
                        AssetsImg.LOGO,
                        width: AppSizes.setWidth(132),
                        height: AppSizes.setHeight(132),
                      ),
                    ),
                    SizedBox(height: AppSizes.setHeight(16)),
                    CommonText(
                      text: '欢迎回到买油呗',
                      fontWeight: FontWeight.w700,
                      fontSize: AppSizes.setFontSize(24),
                      textColor: const Color(0xFF1F2937),
                    ),
                    SizedBox(height: AppSizes.setHeight(8)),
                    CommonText(
                      text: 'B2B成品油交易平台',
                      fontWeight: FontWeight.w400,
                      fontSize: AppSizes.setFontSize(14),
                      textColor: const Color(0xFF6B7280),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.setHeight(40)),
                FormBuilder(
                  key: ctrl.formKey,
                  child: Column(
                    children: [
                      CommonTextFormField(
                        name: 'phone',
                        borderColor: const Color(0xFFE5E7EB),
                        fillColor: const Color(0xFFF9FAFB),
                        leadingIcon: Image.asset(
                          AssetsIcon.IC_PROFILE,
                          width: AppSizes.setHeight(20),
                          height: AppSizes.setHeight(20),
                        ),
                        hintText: '请输入手机号',
                        radius: 12,
                      ),
                      SizedBox(height: AppSizes.setHeight(16)),
                      CommonTextFormField(
                        name: 'password',
                        borderColor: const Color(0xFFE5E7EB),
                        fillColor: const Color(0xFFF9FAFB),
                        leadingIcon: Image.asset(
                          AssetsIcon.IC_PASSWORD,
                          width: AppSizes.setHeight(20),
                          height: AppSizes.setHeight(20),
                        ),
                        hintText: '请输入密码',
                        isPasswordField: true,
                        radius: 12,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.setHeight(24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CommonText(
                      text: '没有账户？',
                      textColor: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                      fontSize: AppSizes.setFontSize(14),
                    ),
                    SizedBox(width: AppSizes.setWidth(4)),
                    InkWell(
                      onTap: () {
                        BaseRouter.push(
                          url: AppPage.registerPage.path,
                          extra: null,
                        );
                      },
                      child: CommonText(
                        text: '注册',
                        textColor: AppColor.txtPurple,
                        fontWeight: FontWeight.w600,
                        fontSize: AppSizes.setFontSize(14),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSizes.setHeight(24)),
                // 登录按钮
                CommonButton(
                  btnText: '立即登录',
                  radius: 26,
                  onTap: () => ctrl.submit(),
                  isButtonShadow: true,
                ),
                SizedBox(height: AppSizes.setHeight(16)),
                // 忘记密码
                Align(
                  alignment: Alignment.center,
                  child: // 手机号验证码登录切换
                      GestureDetector(
                    onTap: () {
                      BaseRouter.push(url: AppPage.verificationLoginPage.path);
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: AppSizes.setFontSize(14),
                          color: const Color(0xFF6B7280),
                        ),
                        children: [
                          const TextSpan(text: '手机号验证码登录 '),
                          TextSpan(
                            text: '切换',
                            style: TextStyle(
                              color: AppColor.txtPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppSizes.setHeight(40)),
                // 协议部分
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      margin: EdgeInsets.only(
                          top: AppSizes.setHeight(2),
                          right: AppSizes.setWidth(8)),
                      decoration: BoxDecoration(
                        color: AppColor.txtPurple,
                        border: Border.all(color: AppColor.txtPurple),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: AppSizes.setFontSize(12),
                            color: const Color(0xFF6B7280),
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(text: '登录即代表您同意 '),
                            TextSpan(
                              text: '《用户服务协议》',
                              style: TextStyle(
                                color: AppColor.txtPurple,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  BaseRouter.push(
                                      url: AppPage.serviceAgreementPage.path);
                                },
                            ),
                            const TextSpan(text: ' 和 '),
                            TextSpan(
                              text: '《隐私政策》',
                              style: TextStyle(
                                color: AppColor.txtPurple,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  BaseRouter.push(
                                      url: AppPage.privacyPolicyPage.path);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.setHeight(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
