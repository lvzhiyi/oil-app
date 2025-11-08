import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/model/auth_req_type.dart';
import 'package:oil_business_app/global/service/auth_service.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';

import 'state.dart';

class BindStationCtrl extends Cubit<BindStationState> {
  BindStationCtrl({this.extra})
      : super(
          BindStationState(),
        ) {
    initState();
  }
  final Map<String, dynamic>? extra;

  final formKey = GlobalKey<FormBuilderState>();

  final cityController = TextEditingController();

  initState() async {
    print('extra: $extra');
  }

  /// 注册前置检查
  bool registerPrecheck() {
    if (state.loading) return false;
    return formKey.currentState?.saveAndValidate() ?? false;
  }

  submit() async {
    print('submit');
    if (!registerPrecheck()) return;

    print('submit1');
    emit(state.copyWith(loading: true));

    // 获取表单数据
    final formData = formKey.currentState?.value ?? {};
    final reqParams = RegisterRequest(
      name: formData['name'] ?? '',
      phone: extra?['phone'] ?? '',
      code: extra?['code'] ?? '',
      password: formData['password'] ?? '',
    );
    l.d('Register', '开始注册: reqParams.toJson(): ${reqParams.toJson()}');

    try {
      // 调用注册接口
      final response = await authService.register(reqParams);
      BaseConfig.appContext?.read<AppController>().setAuthResponse(response);
      BaseRouter.replace(url: AppPage.mainLayoutPage.path);

      l.d('Register', '注册成功 response: $response');
      emit(state.copyWith(
        loading: false,
      ));
    } catch (e) {
      l.e('Register', '注册失败: $e');
      emit(state.copyWith(loading: false));
    }
  }

  /// 收起键盘
  void unFocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
