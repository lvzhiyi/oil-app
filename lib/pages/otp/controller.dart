import 'dart:async';

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

  Timer? _countdownTimer;
  static const int _countdownDuration = 60;

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
      final phone = phoneController.text;
      BaseRouter.push(url: AppPage.otpVerificationPage.path, extra: {
        "type": type,
        "phone": phone,
      });
      // 启动倒计时
      startCountdown();
    } catch (e) {
      // 发生错误时重置 loading 状态，避免页面卡住
      emit(state.copyWith(loading: false));
      debugPrint('发送验证码失败: $e');
      // 错误已被捕获，不再向上传播，避免页面崩溃
    }
  }

  /// 启动倒计时
  void startCountdown() {
    _countdownTimer?.cancel();
    emit(state.copyWith(countdownSeconds: _countdownDuration));
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentSeconds = state.countdownSeconds ?? 0;
      if (currentSeconds > 0) {
        emit(state.copyWith(countdownSeconds: currentSeconds - 1));
      } else {
        timer.cancel();
        _countdownTimer = null;
      }
    });
  }

  /// 重新发送验证码
  Future<void> resendOtp({required String type, required String phone}) async {
    if (state.countdownSeconds != null && state.countdownSeconds! > 0) {
      // 倒计时未结束，不允许重新发送
      return;
    }

    emit(state.copyWith(loading: true));

    try {
      await authService.sendCode(
        SendCodeRequest(phone: phone, type: type),
      );
      emit(state.copyWith(loading: false));
      // 重新启动倒计时
      startCountdown();
    } catch (e) {
      emit(state.copyWith(loading: false));
      debugPrint('重新发送验证码失败: $e');
    }
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }

  submit({required String type}) async {
    if (type == "register") {
      print('submit register');
      BaseRouter.push(url: AppPage.registerPage.path, extra: {
        "phone": phoneController.text,
        "code": codeController.map((e) => e.text).join(''),
      });
      phoneController.clear();
      return;
    }

    if (type == "password_change") {
      print('submit password_change');
      BaseRouter.push(url: AppPage.changePasswordPage.path, extra: {
        "phone": phoneController.text,
        "code": codeController.map((e) => e.text).join(''),
      });
      phoneController.clear();
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
      phoneController.clear();
    } catch (e) {
      phoneController.clear();
      emit(state.copyWith(loading: false));
      return;
    }
  }
}

final otpCtrl = OtpCtrl();
