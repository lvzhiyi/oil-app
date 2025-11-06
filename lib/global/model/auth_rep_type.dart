import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_rep_type.g.dart';

@JsonSerializable()
class AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final Account? account;

  AuthResponse({this.accessToken, this.refreshToken, this.account});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class Account {
  final int id;
  final String phone;
  final String name;
  final int status;

  Account(
      {required this.id,
      required this.phone,
      required this.name,
      required this.status});

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
