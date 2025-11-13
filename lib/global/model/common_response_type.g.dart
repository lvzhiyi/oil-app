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

UploadSignatureResponse _$UploadSignatureResponseFromJson(
        Map<String, dynamic> json) =>
    UploadSignatureResponse(
      accessKeyId: json['accessKeyId'] as String?,
      policy: json['policy'] as String?,
      signature: json['signature'] as String?,
      signatureVersion: json['signatureVersion'] as String?,
      credential: json['credential'] as String?,
      date: json['date'] as String?,
      securityToken: json['securityToken'] as String?,
      dir: json['dir'] as String?,
      path: json['path'] as String?,
      bucket: json['bucket'] as String?,
      endpoint: json['endpoint'] as String?,
      host: json['host'] as String?,
      expireAt: json['expireAt'] as String?,
    );

Map<String, dynamic> _$UploadSignatureResponseToJson(
        UploadSignatureResponse instance) =>
    <String, dynamic>{
      'accessKeyId': instance.accessKeyId,
      'policy': instance.policy,
      'signature': instance.signature,
      'signatureVersion': instance.signatureVersion,
      'credential': instance.credential,
      'date': instance.date,
      'securityToken': instance.securityToken,
      'dir': instance.dir,
      'path': instance.path,
      'bucket': instance.bucket,
      'endpoint': instance.endpoint,
      'host': instance.host,
      'expireAt': instance.expireAt,
    };
