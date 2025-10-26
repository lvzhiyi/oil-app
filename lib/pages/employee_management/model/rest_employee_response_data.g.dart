// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_employee_response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestEmployeeResponseData _$RestEmployeeResponseDataFromJson(
        Map<String, dynamic> json) =>
    RestEmployeeResponseData(
      uuid: json['uuid'] as String?,
      password: json['password'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$RestEmployeeResponseDataToJson(
        RestEmployeeResponseData instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'password': instance.password,
      'phone': instance.phone,
    };
