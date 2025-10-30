class RegisterState {
  bool loading;
  bool registerSuccess;
  String? errorMessage;

  RegisterState({
    required this.loading,
    this.registerSuccess = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    bool? loading,
    bool? registerSuccess,
    String? errorMessage,
  }) {
    return RegisterState(
      loading: loading ?? this.loading,
      registerSuccess: registerSuccess ?? this.registerSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
