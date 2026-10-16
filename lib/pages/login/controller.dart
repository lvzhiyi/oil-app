import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/model/auth_req_type.dart';
import 'package:oil_business_app/global/service/auth_service.dart';
import 'package:oil_business_app/pages/login/state.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCtrl extends Cubit<LoginState> {
  static const _lastLoginPhoneKey = 'last_login_phone';

  LoginCtrl()
      : super(
          LoginState(loginLoading: false),
        ) {
    initState();
  }

  final formKey = GlobalKey<FormBuilderState>();

  final phoneController = TextEditingController();

  Timer? _countdownTimer;

  initState() async {}

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    phoneController.dispose();
    return super.close();
  }

  /// 登录前置检查
  bool loginPrecheck() {
    // 如果正在登录中，不允许重复提交
    if (state.loginLoading) return false;
    return true;
  }

  submit() async {
    if (!loginPrecheck()) return;

    emit(state.copyWith(loginLoading: true));

    try {
      if (state.activeTab == LoginTabType.password) {
        // 密码登录
        await _passwordLogin();
      } else {
        // 验证码登录
        await _verificationLogin();
      }
    } catch (e) {
      l.e('Login', '登录失败: $e');
      final errorMessage = _getErrorMessage(e);
      emit(state.copyWith(
        loginLoading: false,
        errorMessage: errorMessage,
      ));
    }
  }

  /// 根据异常类型返回友好的错误消息
  String _getErrorMessage(dynamic error) {
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
        case DioExceptionType.badResponse:
          return '服务器错误，请稍后重试';
        case DioExceptionType.connectionError:
          return '网络连接失败，请检查网络设置';
        case DioExceptionType.cancel:
          return '请求已取消';
        default:
          break;
      }
    }

    final errorStr = error.toString().toLowerCase();

    // 网络错误
    if (errorStr.contains('timeout') || errorStr.contains('超时')) {
      return '网络连接超时，请检查网络后重试';
    }
    if (errorStr.contains('network') ||
        errorStr.contains('connection') ||
        errorStr.contains('网络')) {
      return '网络连接失败，请检查网络设置';
    }
    if (errorStr.contains('server') || errorStr.contains('服务器')) {
      return '服务器错误，请稍后重试';
    }

    // 认证错误
    if (errorStr.contains('invalid') ||
        errorStr.contains('incorrect') ||
        errorStr.contains('wrong') ||
        errorStr.contains('密码错误') ||
        errorStr.contains('验证码错误')) {
      return state.activeTab == LoginTabType.password
          ? '手机号或密码错误'
          : '验证码错误或已过期';
    }
    if (errorStr.contains('not found') ||
        errorStr.contains('不存在') ||
        errorStr.contains('未找到')) {
      return '账号不存在，请先注册';
    }
    if (errorStr.contains('locked') ||
        errorStr.contains('disabled') ||
        errorStr.contains('锁定') ||
        errorStr.contains('禁用')) {
      return '账号已被锁定，请联系您的业务员';
    }

    // 默认错误
    return '登录失败，请重试';
  }

  /// 密码登录
  Future<void> _passwordLogin() async {
    final formData = formKey.currentState?.value ?? {};
    final phone = (formData['phone'] ?? '').toString();
    final password = formData['password'] ?? '';

    l.d('Login', '开始密码登录: 手机号=$phone');

    final response =
        await authService.login(LoginRequest(phone: phone, password: password));
    BaseConfig.appContext?.read<AppController>().loginSucessProcess(response);
    await _saveLastPhone(phone);
    emit(state.copyWith(loginLoading: false, loginSuccess: true));
  }

  /// 验证码登录
  Future<void> _verificationLogin() async {
    final formData = formKey.currentState?.value ?? {};
    final phone = (formData['phone'] ?? '').toString();
    final code = formData['verificationCode'] ?? '';

    l.d('Login', '开始验证码登录: 手机号=$phone');

    // 调用验证码登录接口
    final response = await authService.login(
      LoginRequest(
        phone: phone,
        code: code,
      ),
    );
    BaseConfig.appContext?.read<AppController>().loginSucessProcess(response);

    await _saveLastPhone(phone);
    emit(state.copyWith(loginLoading: false, loginSuccess: true));
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

  /// 切换标签
  void switchTab(LoginTabType tab) {
    emit(state.copyWith(activeTab: tab));
  }

  /// 切换协议接受状态
  void toggleAgreement(bool accepted) {
    emit(state.copyWith(agreementAccepted: accepted));
  }

  /// 发送验证码
  Future<void> sendVerificationCode(String phone) async {
    try {
      l.d('Login', '发送验证码到: $phone');

      // 调用发送验证码接口
      await authService.sendCode(
        SendCodeRequest(
          phone: phone,
          type: 'login', // 登录用验证码
        ),
      );

      // 标记验证码已发送并开始倒计时
      emit(state.copyWith(verificationCodeSent: true));
      startCountdown();
    } catch (e) {
      l.e('Login', '发送验证码失败: $e');
      final errorMessage = _getSmsErrorMessage(e);
      emit(state.copyWith(
        errorMessage: errorMessage,
      ));
    }
  }

  /// 根据异常类型返回短信服务相关的错误消息
  String _getSmsErrorMessage(dynamic error) {
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
        default:
          break;
      }
    }

    final errorStr = error.toString().toLowerCase();

    // 网络错误
    if (errorStr.contains('timeout') || errorStr.contains('超时')) {
      return '网络连接超时，请检查网络后重试';
    }
    if (errorStr.contains('network') ||
        errorStr.contains('connection') ||
        errorStr.contains('网络')) {
      return '网络连接失败，请检查网络设置';
    }

    // 短信服务错误
    if (errorStr.contains('rate limit') ||
        errorStr.contains('too many') ||
        errorStr.contains('频繁') ||
        errorStr.contains('限制')) {
      return '发送过于频繁，请稍后再试';
    }
    if (errorStr.contains('invalid phone') ||
        errorStr.contains('手机号无效') ||
        errorStr.contains('号码无效')) {
      return '手机号格式不正确';
    }
    if (errorStr.contains('service unavailable') ||
        errorStr.contains('服务不可用')) {
      return '短信服务暂时不可用，请稍后重试';
    }

    // 默认错误
    return '发送验证码失败，请重试';
  }

  /// 开始倒计时
  void startCountdown() {
    // 取消之前的计时器
    _countdownTimer?.cancel();

    // 设置初始倒计时为60秒
    emit(state.copyWith(verificationCountdown: 60));

    // 创建新的计时器
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.verificationCountdown != null &&
          state.verificationCountdown! > 0) {
        emit(state.copyWith(
          verificationCountdown: state.verificationCountdown! - 1,
        ));
      } else {
        stopCountdown();
      }
    });
  }

  /// 停止倒计时
  void stopCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    emit(state.copyWith(
      verificationCountdown: 0,
      verificationCodeSent: false,
    ));
  }

  Future<void> _loadLastPhone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedPhone = prefs.getString(_lastLoginPhoneKey);
      if (cachedPhone != null && cachedPhone.isNotEmpty) {
        phoneController.text = cachedPhone;
      }
    } catch (_) {
      // 读取失败时静默处理，不影响登录流程
    }
  }

  Future<void> _saveLastPhone(String phone) async {
    final trimmed = phone.trim();
    if (trimmed.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastLoginPhoneKey, trimmed);
    } catch (_) {
      // 写入失败时忽略，不阻塞登录
    }
  }
}
