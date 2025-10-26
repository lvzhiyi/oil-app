// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_records_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiftRecordsResponse _$GiftRecordsResponseFromJson(Map<String, dynamic> json) =>
    GiftRecordsResponse(
      data: json['data'] == null
          ? null
          : GiftRecordsData.fromJson(json['data'] as Map<String, dynamic>),
      code: (json['code'] as num?)?.toInt(),
      message: json['message'] as String?,
      requestId: json['requestId'] as String?,
    );

Map<String, dynamic> _$GiftRecordsResponseToJson(
        GiftRecordsResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'code': instance.code,
      'message': instance.message,
      'requestId': instance.requestId,
    };

GiftRecordsData _$GiftRecordsDataFromJson(Map<String, dynamic> json) =>
    GiftRecordsData(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => GiftRecordItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GiftRecordsDataToJson(GiftRecordsData instance) =>
    <String, dynamic>{
      'list': instance.list,
      'total': instance.total,
    };

GiftRecordItem _$GiftRecordItemFromJson(Map<String, dynamic> json) =>
    GiftRecordItem(
      id: (json['id'] as num?)?.toInt(),
      createTime: (json['createTime'] as num?)?.toInt(),
      createdBy: json['createdBy'] as String?,
      creator: json['creator'] == null
          ? null
          : GiftRecordCreator.fromJson(json['creator'] as Map<String, dynamic>),
      tenantUuid: json['tenantUuid'] as String?,
      lotteryType: (json['lotteryType'] as num?)?.toInt(),
      type: json['type'] as String?,
      originCode: json['originCode'] as String?,
      num: json['num'] as String?,
      tenant: json['tenant'] == null
          ? null
          : GiftRecordTenant.fromJson(json['tenant'] as Map<String, dynamic>),
      receiveCount: (json['receiveCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GiftRecordItemToJson(GiftRecordItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createTime': instance.createTime,
      'createdBy': instance.createdBy,
      'creator': instance.creator,
      'tenantUuid': instance.tenantUuid,
      'lotteryType': instance.lotteryType,
      'type': instance.type,
      'originCode': instance.originCode,
      'num': instance.num,
      'tenant': instance.tenant,
      'receiveCount': instance.receiveCount,
    };

GiftRecordCreator _$GiftRecordCreatorFromJson(Map<String, dynamic> json) =>
    GiftRecordCreator(
      id: (json['id'] as num?)?.toInt(),
      uuid: json['uuid'] as String?,
      username: json['username'] as String?,
    );

Map<String, dynamic> _$GiftRecordCreatorToJson(GiftRecordCreator instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'username': instance.username,
    };

GiftRecordTenant _$GiftRecordTenantFromJson(Map<String, dynamic> json) =>
    GiftRecordTenant(
      id: (json['id'] as num?)?.toInt(),
      uuid: json['uuid'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$GiftRecordTenantToJson(GiftRecordTenant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'name': instance.name,
    };
