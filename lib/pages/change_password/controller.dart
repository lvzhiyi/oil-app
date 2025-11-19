import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:oil_business_app/global/model/auth_req_type.dart';
import 'package:oil_business_app/global/service/auth_service.dart';
import 'package:oil_business_app/pages/change_password/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';

class ChangePasswordCtrl extends Cubit<ChangePasswordState> {
  ChangePasswordCtrl({this.extra})
      : super(
          ChangePasswordState(loading: false),
        ) {
    initState();
  }
  final Map<String, dynamic>? extra;

  final formKey = GlobalKey<FormBuilderState>();

  initState() async {
    print('extra: $extra');
  }

  /// 修改密码前置检查
  bool changePasswordPrecheck() {
    if (state.loading) return false;
    return formKey.currentState?.saveAndValidate() ?? false;
  }

  submit() async {
    print('submit');
    if (!changePasswordPrecheck()) return;

    print('submit1');
    emit(state.copyWith(loading: true, errorMessage: null));

    // 获取表单数据
    final formData = formKey.currentState?.value ?? {};
    final reqParams = ChangePasswordRequest(
      phone: extra?['phone'] ?? '',
      code: extra?['code'] ?? '',
      newPassword: formData['password'] ?? '',
    );
    l.d('ChangePassword', '开始修改密码: reqParams.toJson(): ${reqParams.toJson()}');

    try {
      // 调用修改密码接口
      final response = await authService.changePassword(reqParams);
      l.d('ChangePassword', '修改密码成功 response: $response');
      BaseRouter.replace(url: AppPage.loginPage.path);
      emit(state.copyWith(
        loading: false,
        changePasswordSuccess: true,
      ));
    } catch (e) {
      l.e('ChangePassword', '修改密码失败: $e');
      emit(state.copyWith(loading: false));
    }
  }

  /// 修改密码成功后返回上一页
  void navigateBack(BuildContext context) {
    context.pop();
  }

  /// 清除错误信息
  void clearError() {
    if (state.errorMessage != null) {
      emit(state.copyWith(errorMessage: null));
    }
  }

  /// 重置修改密码状态
  void resetChangePasswordState() {
    emit(ChangePasswordState(loading: false));
  }

  /// 收起键盘
  void unFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
