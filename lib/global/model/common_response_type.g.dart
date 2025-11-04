// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_response_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonResponse _$CommonResponseFromJson(Map<String, dynamic> json) =>
    CommonResponse(
      message: json['message'] as String?,
      code: (json['code'] as num?)?.toInt(),
      data: json['data'],
    );

Map<String, dynamic> _$CommonResponseToJson(CommonResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
      'data': instance.data,
    };
