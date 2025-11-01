import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oil_business_app/pages/login/state.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:oil_business_app/utils/log.dart';

class LoginCtrl extends Cubit<LoginState> {
  LoginCtrl()
      : super(
          LoginState(loginLoading: false),
        ) {
    initState();
  }

  static final formKey = GlobalKey<FormBuilderState>();

  initState() async {}

  /// 登录前置检查
  bool loginPrecheck() {
    if (state.loginLoading) return false;
    return formKey.currentState?.saveAndValidate() ?? false;
  }

  submit() async {
    if (!loginPrecheck()) return;

    emit(state.copyWith(loginLoading: true));

    // 获取表单数据
    final formData = formKey.currentState?.value ?? {};
    final phone = formData['phone'] ?? '';
    final password = formData['password'] ?? '';

    l.d('Login', '开始登录: 手机号=$phone');

    // 调用真实登录接口

    try {
      // response = await authService.login(loginRequest);

      // // 检查登录结果
      // if (response.code == HttpCode.success) {
      //   // 登录成功，保存access_token、refresh_token、tenantUuid和用户信息
      //   if (response.data?.accessToken != null) {
      //     await TokenManager.instance
      //         .saveAccessToken(response.data!.accessToken!);
      //   }

      //   if (response.data?.refreshToken != null) {
      //     await TokenManager.instance
      //         .saveRefreshToken(response.data!.refreshToken!);
      //   }

      //   if (response.data?.tenantUuid != null) {
      //     await TokenManager.instance
      //         .saveTenantUuid(response.data!.tenantUuid!);
      //   }
    } catch (e) {
      emit(state.copyWith(loginLoading: false));
      return;
    }
  }

  /// 登录成功后跳转到首页
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

  /// 重置登录状态
  void resetLoginState() {
    emit(state.copyWith(
      loginLoading: false,
      loginSuccess: false,
      errorMessage: null,
    ));
  }

  unFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    }
  }
}
