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
      withdrawId: (json['withdrawId'] as num?)?.toInt(),
      withdrawNo: json['withdrawNo'] as String?,
      inventoryId: (json['inventoryId'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      oilOrderId: (json['oilOrderId'] as num?)?.toInt(),
      status: json['status'] as String?,
      stationId: (json['stationId'] as num?)?.toInt(),
      stationName: json['stationName'] as String?,
      withdrawTon: (json['withdrawTon'] as num?)?.toDouble(),
      vehicleInfo: json['vehicleInfo'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      provinceName: json['provinceName'] as String?,
      cityName: json['cityName'] as String?,
      areaName: json['areaName'] as String?,
      addressDetail: json['addressDetail'] as String?,
      depotName: json['depotName'] as String?,
    );

Map<String, dynamic> _$WithdrawOrderModelToJson(WithdrawOrderModel instance) =>
    <String, dynamic>{
      'withdrawId': instance.withdrawId,
      'withdrawNo': instance.withdrawNo,
      'inventoryId': instance.inventoryId,
      'id': instance.id,
      'oilOrderId': instance.oilOrderId,
      'status': instance.status,
      'depotName': instance.depotName,
      'stationId': instance.stationId,
      'stationName': instance.stationName,
      'withdrawTon': instance.withdrawTon,
      'vehicleInfo': instance.vehicleInfo,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'provinceName': instance.provinceName,
      'cityName': instance.cityName,
      'areaName': instance.areaName,
      'addressDetail': instance.addressDetail,
    };

WithdrawRequest _$WithdrawRequestFromJson(Map<String, dynamic> json) =>
    WithdrawRequest(
      withdrawTon: (json['withdrawTon'] as num).toDouble(),
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
      withdrawId: (json['withdrawId'] as num?)?.toInt(),
      withdrawNo: json['withdrawNo'] as String?,
      remainingTon: (json['remainingTon'] as num?)?.toDouble(),
      status: json['status'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$WithdrawResponseToJson(WithdrawResponse instance) =>
    <String, dynamic>{
      'withdrawId': instance.withdrawId,
      'withdrawNo': instance.withdrawNo,
      'remainingTon': instance.remainingTon,
      'status': instance.status,
      'message': instance.message,
    };

InventoryModel _$InventoryModelFromJson(Map<String, dynamic> json) =>
    InventoryModel(
      inventoryId: (json['inventoryId'] as num?)?.toInt(),
      depotId: (json['depotId'] as num?)?.toInt(),
      depotName: json['depotName'] as String?,
      fuelType: json['fuelType'] as String?,
      availableTon: (json['availableTon'] as num?)?.toDouble(),
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$InventoryModelToJson(InventoryModel instance) =>
    <String, dynamic>{
      'inventoryId': instance.inventoryId,
      'depotId': instance.depotId,
      'depotName': instance.depotName,
      'fuelType': instance.fuelType,
      'availableTon': instance.availableTon,
      'updatedAt': instance.updatedAt,
    };

InventoryListResponse _$InventoryListResponseFromJson(
        Map<String, dynamic> json) =>
    InventoryListResponse(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => InventoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$InventoryListResponseToJson(
        InventoryListResponse instance) =>
    <String, dynamic>{
      'list': instance.list,
      'total': instance.total,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };
