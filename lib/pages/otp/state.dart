class OtpState {
  OtpState({this.phone, this.code});
  final String? phone;
  final String? code;

  OtpState copyWith({String? phone, String? code}) {
    return OtpState(phone: phone ?? this.phone, code: code ?? this.code);
  }
}
