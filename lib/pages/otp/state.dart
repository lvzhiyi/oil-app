class OtpState {
  OtpState({this.phone, this.code, this.loading});
  final String? phone;
  final String? code;
  final bool? loading;

  OtpState copyWith({String? phone, String? code, bool? loading}) {
    return OtpState(
        phone: phone ?? this.phone,
        code: code ?? this.code,
        loading: loading ?? this.loading);
  }
}
