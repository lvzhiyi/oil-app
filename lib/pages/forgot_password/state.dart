/// 找回密码页面状态
class ForgotPasswordState {
  /// 是否正在加载
  final bool loading;

  /// 密码重置是否成功
  final bool resetSuccess;

  /// 错误信息
  final String? errorMessage;

  /// 验证码倒计时（秒）
  final int? verificationCountdown;

  /// 验证码是否已发送
  final bool verificationCodeSent;

  const ForgotPasswordState({
    required this.loading,
    this.resetSuccess = false,
    this.errorMessage,
    this.verificationCountdown,
    this.verificationCodeSent = false,
  });

  ForgotPasswordState copyWith({
    bool? loading,
    bool? resetSuccess,
    String? errorMessage,
    int? verificationCountdown,
    bool? verificationCodeSent,
  }) {
    return ForgotPasswordState(
      loading: loading ?? this.loading,
      resetSuccess: resetSuccess ?? this.resetSuccess,
      errorMessage: errorMessage,
      verificationCountdown:
          verificationCountdown ?? this.verificationCountdown,
      verificationCodeSent: verificationCodeSent ?? this.verificationCodeSent,
    );
  }
}
