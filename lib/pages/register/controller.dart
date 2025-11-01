import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:oil_business_app/global/service/auth_service.dart';
import 'package:oil_business_app/pages/register/state.dart';
import 'package:oil_business_app/net/code.dart';
import 'package:oil_business_app/utils/log.dart';

class RegisterCtrl extends Cubit<RegisterState> {
  RegisterCtrl()
      : super(
          RegisterState(loading: false),
        ) {
    initState();
  }

  final formKey = GlobalKey<FormBuilderState>();

  initState() async {}

  /// 注册前置检查
  bool registerPrecheck() {
    if (state.loading) return false;
    return formKey.currentState?.saveAndValidate() ?? false;
  }

  submit() async {
    if (!registerPrecheck()) return;

    emit(state.copyWith(loading: true, errorMessage: null));

    // 获取表单数据
    final formData = formKey.currentState?.value ?? {};
    final name = formData['name'] ?? '';
    final phone = formData['phone'] ?? '';
    final code = formData['code'] ?? '';
    final password = formData['password'] ?? '';

    l.d('Register', '开始注册: 手机号=$phone');

    try {
      // 调用注册接口
      final response = await authService.register(
        RegisterRequest(
          name: name,
          phone: phone,
          code: code,
          password: password,
        ),
      );

      l.d('Register', '注册成功');
      emit(state.copyWith(
        loading: false,
        registerSuccess: true,
      ));
    } catch (e) {
      l.e('Register', '注册失败: $e');
      emit(state.copyWith(
        loading: false,
        errorMessage: '注册失败，请检查网络连接或稍后重试',
      ));
    }
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
