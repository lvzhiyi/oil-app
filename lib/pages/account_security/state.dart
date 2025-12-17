class AccountSecurityState {
  bool loading;
  String? errorMessage;

  AccountSecurityState({
    this.loading = false,
    this.errorMessage,
  });

  AccountSecurityState copyWith({
    bool? loading,
    String? errorMessage,
  }) {
    return AccountSecurityState(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

