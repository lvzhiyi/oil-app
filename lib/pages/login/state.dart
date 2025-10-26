class LoginState {
  /// 是否正在登录
  bool loginLoading;

  /// 登录是否成功
  bool loginSuccess;

  /// 错误信息
  String? errorMessage;

  LoginState({
    required this.loginLoading,
    this.loginSuccess = false,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? loginLoading,
    bool? loginSuccess,
    String? errorMessage,
  }) {
    return LoginState(
      loginLoading: loginLoading ?? this.loginLoading,
      loginSuccess: loginSuccess ?? this.loginSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
