import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:oil_business_app/pages/forgot_password/controller.dart';
import 'package:oil_business_app/pages/forgot_password/state.dart';
import 'package:oil_business_app/pages/forgot_password/widgets/contact_support.dart';
import 'package:oil_business_app/pages/forgot_password/widgets/header_area.dart';
import 'package:oil_business_app/pages/forgot_password/widgets/password_rules.dart';
import 'package:oil_business_app/pages/forgot_password/widgets/send_code_button.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/static/svg.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/utils/validators/phone_validator.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';
import 'package:oil_business_app/widgets/common/svg_asset.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

/// 找回密码页面主界面
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<ForgotPasswordCtrl>();

    return Scaffold(
      backgroundColor: CustomAppColor.of(context).white,
      body: SafeArea(
        child: Column(
          children: [
            // 导航栏
            _buildNavBar(context, ctrl),
            // 内容区域
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.setWidth(24),
                  vertical: AppSizes.setHeight(20),
                ),
                child: FormBuilder(
                  key: ctrl.formKey,
                  child: Column(
                    children: [
                      // 头部区域
                      const HeaderArea(),
                      // 手机号输入框
                      _buildPhoneField(),
                      SizedBox(height: AppSizes.setHeight(16)),
                      // 验证码输入框
                      BlocBuilder<ForgotPasswordCtrl, ForgotPasswordState>(
                        builder: (context, state) {
                          return _buildCodeField(ctrl, state);
                        },
                      ),
                      SizedBox(height: AppSizes.setHeight(16)),
                      // 新密码输入框
                      _buildPasswordField('password', '设置新密码'),
                      SizedBox(height: AppSizes.setHeight(16)),
                      // 确认密码输入框
                      _buildConfirmPasswordField(ctrl),
                      SizedBox(height: AppSizes.setHeight(8)),
                      // 密码规则提示
                      const PasswordRules(),
                      SizedBox(height: AppSizes.setHeight(24)),
                      // 提交按钮
                      BlocBuilder<ForgotPasswordCtrl, ForgotPasswordState>(
                        builder: (context, state) {
                          return _buildSubmitButton(ctrl, state);
                        },
                      ),
                      // SizedBox(height: AppSizes.setHeight(24)),
                      // // 联系客服
                      // ContactSupport(
                      //   onContactSupport: () {
                      //     // TODO: 实现联系客服功能
                      //     SportsToast.showWarning('客服功能开发中');
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context, ForgotPasswordCtrl ctrl) {
    return Container(
      height: AppSizes.setHeight(44),
      padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(16)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => ctrl.navigateBack(),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(AppSizes.setWidth(8)),
              child: Icon(
                Icons.arrow_back,
                size: AppSizes.setFontSize(24),
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return CommonTextFormField(
      name: 'phone',
      borderColor: const Color(0xFFE5E7EB),
      fillColor: const Color(0xFFF9FAFB),
      leadingIcon: Image.asset(
        AssetsIcon.IC_PROFILE,
        width: AppSizes.setHeight(20),
        height: AppSizes.setHeight(20),
      ),
      hintText: '请输入手机号码',
      keyboardType: TextInputType.phone,
      inputFormatter: FilteringTextInputFormatter.digitsOnly,
      maxLength: 11,
      radius: 12,
      validators: PhoneValidator.validatePhone,
    );
  }

  Widget _buildCodeField(ForgotPasswordCtrl ctrl, ForgotPasswordState state) {
    return CommonTextFormField(
      name: 'code',
      borderColor: const Color(0xFFE5E7EB),
      fillColor: const Color(0xFFF9FAFB),
      leadingIcon: SvgAsset(
        assetName: AssetsSvg.SMSCODE,
        width: AppSizes.setHeight(20),
        height: AppSizes.setHeight(20),
        color: const Color(0xFF9CA3AF),
      ),
      hintText: '请输入4位验证码',
      keyboardType: TextInputType.number,
      inputFormatter: FilteringTextInputFormatter.digitsOnly,
      maxLength: 4,
      radius: 12,
      validators: (value) {
        if (value == null || value.isEmpty) {
          return '请输入验证码';
        }
        if (value.length != 4) {
          return '请输入4位验证码';
        }
        return null;
      },
      suffixIcon: SendCodeButton(
        countdown: state.verificationCountdown,
        onSendCode: () => _handleSendCode(ctrl),
      ),
    );
  }

  Widget _buildPasswordField(String name, String hint) {
    return CommonTextFormField(
      name: name,
      borderColor: const Color(0xFFE5E7EB),
      fillColor: const Color(0xFFF9FAFB),
      leadingIcon: SvgAsset(
        assetName: AssetsSvg.LOCK,
        width: AppSizes.setHeight(20),
        height: AppSizes.setHeight(20),
        color: const Color(0xFF9CA3AF),
      ),
      hintText: hint,
      isPasswordField: true,
      radius: 12,
      validators: (value) {
        if (value == null || value.isEmpty) {
          return '请输入新密码';
        }
        if (value.length < 8 || value.length > 20) {
          return '密码长度必须为8-20位';
        }
        if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
          return '密码必须包含字母';
        }
        if (!RegExp(r'\d').hasMatch(value)) {
          return '密码必须包含数字';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField(ForgotPasswordCtrl ctrl) {
    return CommonTextFormField(
      name: 'confirmPassword',
      borderColor: const Color(0xFFE5E7EB),
      fillColor: const Color(0xFFF9FAFB),
      leadingIcon: SvgAsset(
        assetName: AssetsSvg.LOCK,
        width: AppSizes.setHeight(20),
        height: AppSizes.setHeight(20),
        color: const Color(0xFF9CA3AF),
      ),
      hintText: '确认新密码',
      isPasswordField: true,
      radius: 12,
      validators: (value) {
        if (value == null || value.isEmpty) {
          return '请确认新密码';
        }
        final formState = ctrl.formKey.currentState;
        final password = formState?.fields['password']?.value;
        if (value != password) {
          return '两次输入的密码不一致';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(
      ForgotPasswordCtrl ctrl, ForgotPasswordState state) {
    return CommonButton(
      btnText: '重置密码',
      radius: 26,
      height: AppSizes.setHeight(52),
      isLoading: state.loading,
      onTap: state.loading ? null : () => _handleSubmit(ctrl),
    );
  }

  void _handleSendCode(ForgotPasswordCtrl ctrl) {
    // 先保存表单数据
    ctrl.formKey.currentState?.save();

    final formData = ctrl.formKey.currentState?.value ?? {};
    final phone = formData['phone'] ?? '';

    if (phone.isEmpty) {
      SportsToast.showWarning('请输入手机号');
      return;
    }

    if (phone.length != 11) {
      SportsToast.showWarning('请输入正确的手机号');
      return;
    }

    ctrl.sendVerificationCode(phone);
  }

  void _handleSubmit(ForgotPasswordCtrl ctrl) {
    if (!ctrl.formKey.currentState!.saveAndValidate()) {
      return;
    }

    ctrl.submitReset();
  }
}
