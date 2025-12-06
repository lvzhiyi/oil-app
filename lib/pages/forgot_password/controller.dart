import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:oil_business_app/global/model/auth_req_type.dart';
import 'package:oil_business_app/global/service/auth_service.dart';
import 'package:oil_business_app/pages/forgot_password/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';

/// 找回密码控制器
class ForgotPasswordCtrl extends Cubit<ForgotPasswordState> {
  ForgotPasswordCtrl() : super(const ForgotPasswordState(loading: false));

  /// 表单Key
  final formKey = GlobalKey<FormBuilderState>();

  /// 倒计时定时器
  Timer? _countdownTimer;

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }

  /// 发送验证码
  Future<void> sendVerificationCode(String phone) async {
    if (state.verificationCountdown != null &&
        state.verificationCountdown! > 0) {
      return;
    }

    try {
      final request = SendCodeRequest(phone: phone, type: 'password_change');
      await authService.sendCode(request);
      l.d('ForgotPassword', '验证码发送成功');

      emit(state.copyWith(
        verificationCodeSent: true,
        errorMessage: null,
      ));

      startCountdown();
    } catch (e) {
      l.e('ForgotPassword', '发送验证码失败: $e');
      emit(state.copyWith(
        errorMessage: _parseError(e, '发送验证码失败'),
      ));
    }
  }

  /// 启动倒计时
  void startCountdown() {
    emit(state.copyWith(verificationCountdown: 60));

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentCountdown = state.verificationCountdown ?? 0;
      if (currentCountdown > 1) {
        emit(state.copyWith(verificationCountdown: currentCountdown - 1));
      } else {
        timer.cancel();
        emit(ForgotPasswordState(
          loading: state.loading,
          resetSuccess: state.resetSuccess,
          verificationCodeSent: state.verificationCodeSent,
          verificationCountdown: null,
        ));
      }
    });
  }

  /// 停止倒计时
  void stopCountdown() {
    _countdownTimer?.cancel();
    emit(ForgotPasswordState(
      loading: state.loading,
      resetSuccess: state.resetSuccess,
      verificationCodeSent: state.verificationCodeSent,
      verificationCountdown: null,
    ));
  }

  /// 提交密码重置
  Future<void> submitReset() async {
    if (state.loading) return;

    if (!formKey.currentState!.saveAndValidate()) {
      return;
    }

    final formData = formKey.currentState!.value;
    final phone = formData['phone'] as String? ?? '';
    final code = formData['code'] as String? ?? '';
    final password = formData['password'] as String? ?? '';

    emit(state.copyWith(loading: true, errorMessage: null));

    try {
      final request = ChangePasswordRequest(
        phone: phone,
        code: code,
        newPassword: password,
      );

      l.d('ForgotPassword', '开始重置密码');
      await authService.changePassword(request);
      l.d('ForgotPassword', '密码重置成功');

      emit(state.copyWith(
        loading: false,
        resetSuccess: true,
      ));

      // 导航到登录页面
      BaseRouter.replace(url: AppPage.loginPage.path);
    } catch (e) {
      l.e('ForgotPassword', '密码重置失败: $e');
      emit(state.copyWith(
        loading: false,
        errorMessage: _parseError(e, '密码重置失败'),
      ));
    }
  }

  /// 清除错误信息
  void clearError() {
    if (state.errorMessage != null) {
      emit(ForgotPasswordState(
        loading: state.loading,
        resetSuccess: state.resetSuccess,
        verificationCodeSent: state.verificationCodeSent,
        verificationCountdown: state.verificationCountdown,
      ));
    }
  }

  /// 返回登录页面
  void navigateBack() {
    BaseRouter.pop();
  }

  /// 解析错误信息
  String _parseError(dynamic error, String defaultMessage) {
    // 如果是 DioException，尝试从 response 中提取错误消息
    if (error is DioException) {
      // 从响应数据中提取错误消息
      if (error.response?.data != null) {
        final data = error.response!.data;
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        }
      }

      // 根据 DioException 类型返回消息
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return '网络连接超时，请检查网络后重试';
        case DioExceptionType.connectionError:
          return '网络连接失败，请检查网络设置';
        case DioExceptionType.cancel:
          return '请求已取消';
        default:
          break;
      }
    }

    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('timeout') || errorStr.contains('超时')) {
      return '网络连接超时，请重试';
    }
    if (errorStr.contains('network') ||
        errorStr.contains('connection') ||
        errorStr.contains('网络')) {
      return '无网络连接，请检查网络设置';
    }
    if (errorStr.contains('rate') || errorStr.contains('频繁')) {
      return '发送过于频繁，请稍后再试';
    }
    if (errorStr.contains('invalid') && errorStr.contains('code')) {
      return '验证码错误，请重新输入';
    }
    if (errorStr.contains('expired') || errorStr.contains('过期')) {
      return '验证码已过期，请重新获取';
    }
    if (errorStr.contains('not found') || errorStr.contains('不存在')) {
      return '该手机号未注册';
    }
    if (errorStr.contains('locked') || errorStr.contains('锁定')) {
      return '账号已被锁定，请联系客服';
    }

    return defaultMessage;
  }
}
