import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/auth_req_type.dart';
import 'package:oil_business_app/global/service/auth_service.dart';

import 'state.dart';

class OtpCtrl extends Cubit<OtpState> {
  OtpCtrl() : super(OtpState()) {
    initState();
  }

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

    // 清除验证码输入框
    for (var controller in codeController) {
      controller.clear();
    }
  }

  sendOtp({required Map<String, dynamic> extra}) async {
    if (isClosed) return;
    emit(state.copyWith(phone: extra['phone'] ?? '', loading: true));

    try {
      await authService.sendCode(
        SendCodeRequest(phone: extra['phone'] ?? '', type: extra['type'] ?? ''),
      );
      if (isClosed) return;
      emit(state.copyWith(loading: false));
      // 启动倒计时
      startCountdown();
    } catch (e) {
      // 发生错误时重置 loading 状态，避免页面卡住
      if (!isClosed) {
        emit(state.copyWith(loading: false));
      }
      debugPrint('发送验证码失败: $e');
      // 错误已被捕获，不再向上传播，避免页面崩溃
    }
  }

  /// 启动倒计时
  void startCountdown() {
    if (isClosed) return;
    _countdownTimer?.cancel();
    emit(state.copyWith(countdownSeconds: _countdownDuration));
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        _countdownTimer = null;
        return;
      }
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
  Future<void> resendOtp({required Map<String, dynamic> extra}) async {
    if (isClosed) return;
    if (state.countdownSeconds != null && state.countdownSeconds! > 0) {
      // 倒计时未结束，不允许重新发送
      return;
    }

    emit(state.copyWith(loading: true));

    try {
      await authService.sendCode(
        SendCodeRequest(phone: extra['phone'] ?? '', type: extra['type'] ?? ''),
      );
      if (isClosed) return;
      emit(state.copyWith(loading: false));
      // 重新启动倒计时
      startCountdown();
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(loading: false));
      }
      debugPrint('重新发送验证码失败: $e');
    }
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }

  submit({required Map<String, dynamic> extra}) async {
    if (extra['type'] == "register") {
      // 注册流程：直接调用注册接口
      if (isClosed) return;
      emit(state.copyWith(loading: true));

      try {
        final otpCode = codeController.map((e) => e.text).join('');
        final phone = extra['phone'] ?? '';
        final name = extra['name'] ?? '';
        final password = extra['password'] ?? '';

        final reqParams = RegisterRequest(
          name: name,
          phone: phone,
          code: otpCode,
          password: password,
          referralCode: extra['referralCode'] ?? '',
        );

        final response = await authService.register(reqParams);
        BaseConfig.appContext
            ?.read<AppController>()
            .loginSucessProcess(response, type: AuthReqType.register);

        if (!isClosed) {
          emit(state.copyWith(loading: false));
        }
        // 清除验证码输入框
        for (var controller in codeController) {
          controller.clear();
        }
      } catch (e) {
        // 清除验证码输入框
        for (var controller in codeController) {
          controller.clear();
        }
        if (!isClosed) {
          emit(state.copyWith(loading: false));
        }
        debugPrint('注册失败: $e');
        return;
      }
      return;
    }

    if (extra['type'] == "password_change") {
      // 修改密码流程：直接调用修改密码接口
      if (isClosed) return;
      emit(state.copyWith(loading: true));

      try {
        final otpCode = codeController.map((e) => e.text).join('');
        final phone = extra['phone'] ?? '';
        final newPassword = extra['password'] ?? '';

        final reqParams = ChangePasswordRequest(
          phone: phone,
          code: otpCode,
          newPassword: newPassword,
        );

        await authService.changePassword(reqParams);
        BaseConfig.appContext?.read<AppController>().logout();
        if (!isClosed) {
          emit(state.copyWith(loading: false));
        }
        // 清除验证码输入框
        for (var controller in codeController) {
          controller.clear();
        }
      } catch (e) {
        // 清除验证码输入框
        for (var controller in codeController) {
          controller.clear();
        }
        if (!isClosed) {
          emit(state.copyWith(loading: false));
        }
        debugPrint('修改密码失败: $e');
        return;
      }
      return;
    }

    if (isClosed) return;
    emit(state.copyWith(loading: true));
    try {
      final response = await authService.login(LoginRequest(
          phone: extra?['phone'] ?? '',
          code: codeController.map((e) => e.text).join('')));
      print('response: $response');
      BaseConfig.appContext?.read<AppController>().loginSucessProcess(response);
      if (!isClosed) {
        emit(state.copyWith(loading: false));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(loading: false));
      }
      return;
    }
    for (var controller in codeController) {
      controller.clear();
    }
  }
}
