class ChangePasswordState {
  bool loading;
  bool changePasswordSuccess;
  String? errorMessage;

  ChangePasswordState({
    required this.loading,
    this.changePasswordSuccess = false,
    this.errorMessage,
  });

  ChangePasswordState copyWith({
    bool? loading,
    bool? changePasswordSuccess,
    String? errorMessage,
  }) {
    return ChangePasswordState(
      loading: loading ?? this.loading,
      changePasswordSuccess: changePasswordSuccess ?? this.changePasswordSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}



