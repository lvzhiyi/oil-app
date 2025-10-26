class ChangePwState {
  bool loading;
  ChangePwState({required this.loading});

  ChangePwState copyWith() {
    return ChangePwState(
      loading: loading,
    );
  }
}
