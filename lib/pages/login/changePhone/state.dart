class ChangePhoneState {
  bool loading;
  ChangePhoneState({required this.loading});

  ChangePhoneState copyWith() {
    return ChangePhoneState(loading: loading);
  }
}
