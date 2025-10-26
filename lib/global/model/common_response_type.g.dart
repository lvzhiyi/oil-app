// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_response_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonResponse _$CommonResponseFromJson(Map<String, dynamic> json) =>
    CommonResponse(
      message: json['message'] as String,
      requestId: json['requestId'] as String?,
      code: (json['code'] as num?)?.toInt(),
      data: json['data'] as String?,
    );

Map<String, dynamic> _$CommonResponseToJson(CommonResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'requestId': instance.requestId,
      'code': instance.code,
      'data': instance.data,
    };

CommonBoolResponse _$CommonBoolResponseFromJson(Map<String, dynamic> json) =>
    CommonBoolResponse(
      message: json['message'] as String,
      requestId: json['requestId'] as String?,
      code: (json['code'] as num?)?.toInt(),
      data: json['data'] as bool?,
    );

Map<String, dynamic> _$CommonBoolResponseToJson(CommonBoolResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'requestId': instance.requestId,
      'code': instance.code,
      'data': instance.data,
    };
