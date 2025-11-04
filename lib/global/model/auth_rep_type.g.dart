// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_rep_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tenantUuid: json['tenantUuid'] as String,
      userInfo: json['userInfo'] as String,
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tenantUuid': instance.tenantUuid,
      'userInfo': instance.userInfo,
    };
