// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawOrderListResponse _$WithdrawOrderListResponseFromJson(
        Map<String, dynamic> json) =>
    WithdrawOrderListResponse(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => WithdrawOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WithdrawOrderListResponseToJson(
        WithdrawOrderListResponse instance) =>
    <String, dynamic>{
      'list': instance.list,
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };

WithdrawOrderModel _$WithdrawOrderModelFromJson(Map<String, dynamic> json) =>
    WithdrawOrderModel(
      id: (json['id'] as num?)?.toInt(),
      oilOrderId: (json['oilOrderId'] as num?)?.toInt(),
      status: json['status'] as String?,
      stationId: (json['stationId'] as num?)?.toInt(),
      stationName: json['stationName'] as String?,
      withdrawTon: (json['withdrawTon'] as num?)?.toDouble(),
      vehicleInfo: json['vehicleInfo'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$WithdrawOrderModelToJson(WithdrawOrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'oilOrderId': instance.oilOrderId,
      'status': instance.status,
      'stationId': instance.stationId,
      'stationName': instance.stationName,
      'withdrawTon': instance.withdrawTon,
      'vehicleInfo': instance.vehicleInfo,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

WithdrawRequest _$WithdrawRequestFromJson(Map<String, dynamic> json) =>
    WithdrawRequest(
      withdrawTon: (json['withdrawTon'] as num).toInt(),
      stationId: (json['stationId'] as num).toInt(),
      vehicleInfo: json['vehicleInfo'] as String,
    );

Map<String, dynamic> _$WithdrawRequestToJson(WithdrawRequest instance) =>
    <String, dynamic>{
      'withdrawTon': instance.withdrawTon,
      'stationId': instance.stationId,
      'vehicleInfo': instance.vehicleInfo,
    };

WithdrawResponse _$WithdrawResponseFromJson(Map<String, dynamic> json) =>
    WithdrawResponse(
      id: (json['id'] as num?)?.toInt(),
      status: json['status'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$WithdrawResponseToJson(WithdrawResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'message': instance.message,
    };
