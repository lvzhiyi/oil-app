/// 登录标签类型
enum LoginTabType { password, verification }

// 用于区分未传值和传null的哨兵对象
const _undefined = Object();

class LoginState {
  /// 是否正在登录
  bool loginLoading;

  /// 登录是否成功
  bool loginSuccess;

  /// 错误信息
  String? errorMessage;

  /// 当前激活的标签
  LoginTabType activeTab;

  /// 验证码倒计时（秒）
  int? verificationCountdown;

  /// 验证码是否已发送
  bool verificationCodeSent;

  /// 是否同意用户协议
  bool agreementAccepted;

  LoginState({
    required this.loginLoading,
    this.loginSuccess = false,
    this.errorMessage,
    this.activeTab = LoginTabType.password,
    this.verificationCountdown,
    this.verificationCodeSent = false,
    this.agreementAccepted = true,
  });

  LoginState copyWith({
    bool? loginLoading,
    bool? loginSuccess,
    Object? errorMessage = _undefined,
    LoginTabType? activeTab,
    Object? verificationCountdown = _undefined,
    bool? verificationCodeSent,
    bool? agreementAccepted,
  }) {
    return LoginState(
      loginLoading: loginLoading ?? this.loginLoading,
      loginSuccess: loginSuccess ?? this.loginSuccess,
      errorMessage: errorMessage == _undefined
          ? this.errorMessage
          : errorMessage as String?,
      activeTab: activeTab ?? this.activeTab,
      verificationCountdown: verificationCountdown == _undefined
          ? this.verificationCountdown
          : verificationCountdown as int?,
      verificationCodeSent: verificationCodeSent ?? this.verificationCodeSent,
      agreementAccepted: agreementAccepted ?? this.agreementAccepted,
    );
  }
}
