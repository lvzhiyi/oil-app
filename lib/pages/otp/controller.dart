import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/model/auth_req_type.dart';
import 'package:oil_business_app/global/service/auth_service.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';

import 'state.dart';

class OtpCtrl extends Cubit<OtpState> {
  OtpCtrl() : super(OtpState()) {
    initState();
  }

  final phoneController = TextEditingController();

  final codeController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  final focusNode = [FocusNode(), FocusNode(), FocusNode(), FocusNode()];

  initState() async {
    for (int i = 0; i < focusNode.length; i++) {
      codeController[i].addListener(() {
        if (codeController[i].text.isNotEmpty) {
          if (i < focusNode.length - 1) {
            focusNode[i + 1].requestFocus();
          }
        }
      });
    }
  }

  initPhone() {
    phoneController.text = BaseConfig.appContext
            ?.read<AppController>()
            .state
            .authResponse
            ?.account
            ?.phone ??
        '';
    emit(state.copyWith(phone: phoneController.text));
  }

  sendOtp({required String type}) async {
    emit(state.copyWith(phone: phoneController.text, loading: true));

    try {
      await authService.sendCode(
        SendCodeRequest(phone: phoneController.text, type: type),
      );
      emit(state.copyWith(loading: false));
      BaseRouter.push(url: AppPage.otpVerificationPage.path, extra: {
        "type": type,
        "phone": phoneController.text,
      });
    } catch (e) {
      // 发生错误时重置 loading 状态，避免页面卡住
      emit(state.copyWith(loading: false));
      debugPrint('发送验证码失败: $e');
      // 错误已被捕获，不再向上传播，避免页面崩溃
    }
  }

  submit({required String type}) async {
    if (type == "register") {
      print('submit register');
      BaseRouter.push(url: AppPage.registerPage.path, extra: {
        "phone": phoneController.text,
        "code": codeController.map((e) => e.text).join(''),
      });
      return;
    }

    if (type == "password_change") {
      print('submit password_change');
      BaseRouter.push(url: AppPage.changePasswordPage.path, extra: {
        "phone": phoneController.text,
        "code": codeController.map((e) => e.text).join(''),
      });
      return;
    }

    emit(state.copyWith(loading: true));
    try {
      final response = await authService.login(LoginRequest(
          phone: phoneController.text,
          code: codeController.map((e) => e.text).join('')));
      print('response: $response');
      BaseConfig.appContext?.read<AppController>().loginSucessProcess(response);
      emit(state.copyWith(loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false));
      return;
    }
  }
}

final otpCtrl = OtpCtrl();
