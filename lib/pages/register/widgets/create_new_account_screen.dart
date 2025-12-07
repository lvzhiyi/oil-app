import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:oil_business_app/pages/register/controller.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/static/img.dart';

import '../../../resources/colors.dart';
import '../../../utils/sizer_utils.dart';
import '../../../widgets/base/button/common_button.dart';
import '../../../widgets/base/text/common_text.dart';
import '../../../widgets/base/textfield/common_textformfield.dart';

class CreateNewAccountScreen extends StatelessWidget {
  const CreateNewAccountScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
        builder: (context) => const CreateNewAccountScreen());
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<RegisterCtrl>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color(0xFF1F2937),
            size: AppSizes.setWidth(20),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: CommonText(
          text: '注册',
          fontWeight: FontWeight.w700,
          fontSize: AppSizes.setFontSize(18),
          textColor: const Color(0xFF1F2937),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(24)),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                ],
              ),
              FormBuilder(
                key: ctrl.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonTextFormField(
                      name: 'name',
                      borderColor: const Color(0xFFE5E7EB),
                      fillColor: const Color(0xFFF9FAFB),
                      leadingIcon: Image.asset(
                        AssetsIcon.IC_PROFILE,
                        width: AppSizes.setHeight(20),
                        height: AppSizes.setHeight(20),
                      ),
                      hintText: '您的姓名',
                      radius: 12,
                      validators: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: '请输入全名'),
                      ]),
                    ),
                    SizedBox(height: AppSizes.setHeight(16)),
                    CommonTextFormField(
                      name: 'phone',
                      borderColor: const Color(0xFFE5E7EB),
                      fillColor: const Color(0xFFF9FAFB),
                      leadingIcon: Icon(
                        Icons.phone_outlined,
                        size: AppSizes.setHeight(20),
                        color: const Color(0xFF6B7280).withValues(alpha: 0.5),
                      ),
                      hintText: '手机号码 (将作为登录账号)',
                      keyboardType: TextInputType.phone,
                      inputFormatter: FilteringTextInputFormatter.digitsOnly,
                      maxLength: 11,
                      radius: 12,
                      validators: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: '请输入手机号'),
                        FormBuilderValidators.minLength(
                          11,
                          errorText: '手机号必须是11位数字',
                        ),
                        FormBuilderValidators.maxLength(
                          11,
                          errorText: '手机号必须是11位数字',
                        ),
                      ]),
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
                      hintText: '设置登录密码',
                      isPasswordField: true,
                      radius: 12,
                      validators: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: '请输入密码'),
                      ]),
                    ),
                    SizedBox(height: AppSizes.setHeight(16)),
                    CommonTextFormField(
                      name: 'confirmPassword',
                      borderColor: const Color(0xFFE5E7EB),
                      fillColor: const Color(0xFFF9FAFB),
                      leadingIcon: Image.asset(
                        AssetsIcon.IC_PASSWORD,
                        width: AppSizes.setHeight(20),
                        height: AppSizes.setHeight(20),
                      ),
                      hintText: '确认登录密码',
                      isPasswordField: true,
                      radius: 12,
                      validators: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: '请输入确认密码'),
                        (value) {
                          final formState = ctrl.formKey.currentState;
                          final pw = formState?.fields['password']?.value;
                          if (value != pw) {
                            return '密码不一致';
                          }
                          return null;
                        }
                      ]),
                    ),
                    // 密码提示规则
                    Padding(
                      padding: EdgeInsets.only(
                        top: AppSizes.setHeight(8),
                        bottom: AppSizes.setHeight(16),
                      ),
                      child: Row(
                        children: [
                          _buildHintItem('8-20位字符'),
                          SizedBox(width: AppSizes.setWidth(12)),
                          _buildHintItem('包含字母和数字'),
                        ],
                      ),
                    ),
                    CommonTextFormField(
                      name: 'referralCode',
                      borderColor: const Color(0xFFE5E7EB),
                      fillColor: const Color(0xFFF9FAFB),
                      leadingIcon: Image.asset(
                        AssetsIcon.IC_REFER,
                        width: AppSizes.setHeight(20),
                        height: AppSizes.setHeight(20),
                      ),
                      hintText: '业务员推荐码',
                      radius: 12,
                      validators: FormBuilderValidators.compose([]),
                    ),
                    SizedBox(height: AppSizes.setHeight(24)),
                    CommonButton(
                      isLoading: ctrl.state.loading,
                      btnText: '注册并登录',
                      radius: 26,
                      onTap: () {
                        ctrl.goToOtpPage();
                      },
                    ),
                    SizedBox(height: AppSizes.setHeight(24)),
                    // 底部登录引导
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonText(
                          text: '已有账户？',
                          textColor: const Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                          fontSize: AppSizes.setFontSize(14),
                        ),
                        SizedBox(width: AppSizes.setWidth(4)),
                        InkWell(
                          onTap: () {
                            BaseRouter.replace(url: AppPage.loginPage.path);
                          },
                          child: CommonText(
                            text: '立即登录',
                            textColor: AppColor.txtPurple,
                            fontWeight: FontWeight.w600,
                            fontSize: AppSizes.setFontSize(14),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.setHeight(20)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHintItem(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Color(0xFFD1D5DB),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: AppSizes.setWidth(4)),
        CommonText(
          text: text,
          fontSize: AppSizes.setFontSize(11),
          textColor: const Color(0xFF6B7280),
        ),
      ],
    );
  }
}
