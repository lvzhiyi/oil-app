import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oil_business_app/pages/login/state.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:oil_business_app/utils/log.dart';

import 'state.dart';

class OtpCtrl extends Cubit<OtpState> {
  OtpCtrl()
      : super(
          OtpState(),
        ) {
    initState();
  }

  static final formKey = GlobalKey<FormBuilderState>();

  initState() async {}

  /// 登录前置检查

  submit() async {
    try {
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
      return;
    }
  }

  /// 登录成功后跳转到首页
  void navigateToHome(BuildContext context) {
    // 跳转到主布局页面（包含TabBar的首页）
    context.go('/');
  }

  unFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    }
  }
}
