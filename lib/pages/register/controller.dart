import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/auth_req_type.dart';
import 'package:oil_business_app/global/service/auth_service.dart';
import 'package:oil_business_app/pages/register/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';

class RegisterCtrl extends Cubit<RegisterState> {
  RegisterCtrl({this.extra})
      : super(
          RegisterState(loading: false),
        ) {
    initState();
  }
  final Map<String, dynamic>? extra;

  final formKey = GlobalKey<FormBuilderState>();

  initState() async {
    print('extra: $extra');
  }

  /// 注册前置检查
  bool registerPrecheck() {
    if (state.loading) return false;
    return formKey.currentState?.saveAndValidate() ?? false;
  }

  /// 跳转到 OTP 验证码页面
  goToOtpPage() async {
    if (!registerPrecheck()) return;

    // 获取表单数据
    final formData = formKey.currentState?.value ?? {};
    final phone = formData['phone'] ?? '';
    final name = formData['name'] ?? '';
    final password = formData['password'] ?? '';
    final code = formData['code'] ?? '';
    final referralCode = formData['referralCode'] ?? '';
    // 跳转到 OTP 发送验证码页面，传递表单数据
    BaseRouter.push(url: AppPage.otpPage.path, extra: {
      'type': 'register',
      'phone': phone,
      'name': name,
      'password': password,
      'code': code,
      'referralCode': referralCode,
    });
  }

  /// 注册成功后跳转到首页
  void navigateToHome(BuildContext context) {
    // 跳转到主布局页面（包含TabBar的首页）
    context.go('/');
  }

  /// 清除错误信息
  void clearError() {
    if (state.errorMessage != null) {
      emit(state.copyWith(errorMessage: null));
    }
  }

  /// 重置注册状态
  void resetRegisterState() {
    emit(RegisterState(loading: false));
  }

  /// 收起键盘
  void unFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
