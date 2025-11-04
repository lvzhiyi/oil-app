// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_rep_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      account: json['account'] == null
          ? null
          : Account.fromJson(json['account'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'account': instance.account,
    };

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      id: (json['id'] as num).toInt(),
      phone: json['phone'] as String,
      name: json['name'] as String,
      status: (json['status'] as num).toInt(),
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'status': instance.status,
    };
