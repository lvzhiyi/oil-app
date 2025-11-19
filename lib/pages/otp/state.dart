class OtpState {
  OtpState({this.phone, this.code, this.loading, this.countdownSeconds});
  final String? phone;
  final String? code;
  final bool? loading;
  final int? countdownSeconds;

  OtpState copyWith(
      {String? phone, String? code, bool? loading, int? countdownSeconds}) {
    return OtpState(
        phone: phone ?? this.phone,
        code: code ?? this.code,
        loading: loading ?? this.loading,
        countdownSeconds: countdownSeconds ?? this.countdownSeconds);
  }
}
