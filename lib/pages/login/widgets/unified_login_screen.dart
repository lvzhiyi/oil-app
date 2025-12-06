import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:oil_business_app/pages/login/controller.dart';
import 'package:oil_business_app/pages/login/state.dart';
import 'package:oil_business_app/pages/login/widgets/action_links.dart';
import 'package:oil_business_app/pages/login/widgets/agreement_footer.dart';
import 'package:oil_business_app/pages/login/widgets/brand_header.dart';
import 'package:oil_business_app/pages/login/widgets/password_login_form.dart';
import 'package:oil_business_app/pages/login/widgets/phone_input_field.dart';
import 'package:oil_business_app/pages/login/widgets/tab_navigation.dart';
import 'package:oil_business_app/pages/login/widgets/verification_login_form.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/button/common_button.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

/// 统一登录屏幕
class UnifiedLoginScreen extends StatelessWidget {
  const UnifiedLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<LoginCtrl>();

    return BlocListener<LoginCtrl, LoginState>(
      listener: (context, state) {
        // 显示错误消息
        if (state.errorMessage != null) {
          SportsToast.showError(state.errorMessage!);
          // 清除错误消息
          ctrl.clearError();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(24)),
            child: SingleChildScrollView(
              child: FormBuilder(
                key: ctrl.formKey,
                child: Column(
                  children: [
                    SizedBox(height: AppSizes.setHeight(20)),

                    // 品牌头部
                    const BrandHeader(),

                    SizedBox(height: AppSizes.setHeight(40)),

                    // Tab导航
                    BlocBuilder<LoginCtrl, LoginState>(
                      builder: (context, state) {
                        return TabNavigation(
                          activeTab: state.activeTab,
                          onTabChanged: (tab) => ctrl.switchTab(tab),
                        );
                      },
                    ),

                    SizedBox(height: AppSizes.setHeight(32)),

                    // 共享的手机号输入框（不会因为Tab切换而重新渲染）
                    const PhoneInputField(),

                    SizedBox(height: AppSizes.setHeight(16)),

                    // 根据Tab显示不同的额外字段（带动画切换）
                    BlocBuilder<LoginCtrl, LoginState>(
                      builder: (context, state) {
                        final isPassword = state.activeTab == LoginTabType.password;
                        return isPassword
                            ? const PasswordLoginForm(
                                key: ValueKey('password'),
                              )
                            : VerificationLoginForm(
                                key: const ValueKey('verification'),
                                countdown: state.verificationCountdown,
                                onSendCode: () =>
                                    _handleSendCode(context, ctrl),
                              );
                      },
                    ),

                    SizedBox(height: AppSizes.setHeight(24)),

                    // 操作链接
                    const ActionLinks(),

                    SizedBox(height: AppSizes.setHeight(24)),

                    // 登录按钮
                    BlocBuilder<LoginCtrl, LoginState>(
                      builder: (context, state) {
                        // loading状态时禁用按钮，但保持正常样式
                        // 只有协议未勾选时才显示灰色
                        final isDisabled =
                            state.loginLoading || !state.agreementAccepted;
                        final showGrayStyle =
                            !state.loginLoading && !state.agreementAccepted;

                        return CommonButton(
                          btnText: '登录',
                          radius: 26,
                          isLoading: state.loginLoading,
                          onTap: isDisabled
                              ? () {
                                  // 未勾选协议时点击显示提示
                                  if (!state.agreementAccepted &&
                                      !state.loginLoading) {
                                    SportsToast.showWarning('请先同意用户服务协议和隐私政策');
                                  }
                                }
                              : () => _handleLogin(context, ctrl),
                          isButtonShadow: !showGrayStyle,
                          buttonColor:
                              showGrayStyle ? const Color(0xFFD1D5DB) : null,
                        );
                      },
                    ),

                    SizedBox(height: AppSizes.setHeight(40)),

                    // 协议底部
                    const AgreementFooter(),

                    SizedBox(height: AppSizes.setHeight(20)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 处理发送验证码
  void _handleSendCode(BuildContext context, LoginCtrl ctrl) {
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

  /// 处理登录
  void _handleLogin(BuildContext context, LoginCtrl ctrl) {
    // 检查是否同意协议
    if (!ctrl.state.agreementAccepted) {
      SportsToast.showWarning('请先同意用户服务协议和隐私政策');
      return;
    }

    if (!ctrl.formKey.currentState!.saveAndValidate()) {
      return;
    }

    ctrl.submit();
  }
}
