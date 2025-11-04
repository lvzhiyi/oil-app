import 'package:freezed_annotation/freezed_annotation.dart';

import 'common_response_type.dart';

part 'auth_rep_type.g.dart';

@JsonSerializable()
class AuthResponse extends CommonResponse {
  final String accessToken;
  final String refreshToken;
  final String tenantUuid;
  final String userInfo;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tenantUuid,
    required this.userInfo,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  @override
  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tenantUuid': tenantUuid,
      'userInfo': userInfo,
    });
}
