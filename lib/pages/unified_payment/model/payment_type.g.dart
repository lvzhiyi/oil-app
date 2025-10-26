// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePackageOrderRequest _$CreatePackageOrderRequestFromJson(
        Map<String, dynamic> json) =>
    CreatePackageOrderRequest(
      type: json['type'] as String,
      paymentMethod: json['paymentMethod'] as String,
      packageUuid: json['packageUuid'] as String?,
      remark: json['remark'] as String?,
    );

Map<String, dynamic> _$CreatePackageOrderRequestToJson(
        CreatePackageOrderRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'paymentMethod': instance.paymentMethod,
      'packageUuid': instance.packageUuid,
      'remark': instance.remark,
    };

CreateBalanceOrderRequest _$CreateBalanceOrderRequestFromJson(
        Map<String, dynamic> json) =>
    CreateBalanceOrderRequest(
      type: json['type'] as String,
      quota: (json['quota'] as num).toInt(),
      paymentMethod: json['paymentMethod'] as String,
      remark: json['remark'] as String?,
    );

Map<String, dynamic> _$CreateBalanceOrderRequestToJson(
        CreateBalanceOrderRequest instance) =>
    <String, dynamic>{
      'quota': instance.quota,
      'type': instance.type,
      'paymentMethod': instance.paymentMethod,
      'remark': instance.remark,
    };

CreatePaymentOrderData _$CreatePaymentOrderDataFromJson(
        Map<String, dynamic> json) =>
    CreatePaymentOrderData(
      id: (json['id'] as num?)?.toInt(),
      createTime: (json['createTime'] as num?)?.toInt(),
      updateTime: (json['updateTime'] as num?)?.toInt(),
      deleteTime: (json['deleteTime'] as num?)?.toInt(),
      createdBy: json['createdBy'] as String?,
      updatedBy: json['updatedBy'] as String?,
      deletedBy: json['deletedBy'] as String?,
      uuid: json['uuid'] as String?,
      type: json['type'] as String?,
      quota: json['quota'] as String?,
      lotteryType: (json['lotteryType'] as num?)?.toInt(),
      payAmount: json['payAmount'] as String?,
      remark: json['remark'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      origin: json['origin'] as String?,
      status: json['status'] as String?,
      tenantUuid: json['tenantUuid'] as String?,
      pCreatedBy: json['pCreatedBy'] as String?,
      pUpdatedBy: json['pUpdatedBy'] as String?,
      tCreatedBy: json['tCreatedBy'] as String?,
      tUpdatedBy: json['tUpdatedBy'] as String?,
    );

Map<String, dynamic> _$CreatePaymentOrderDataToJson(
        CreatePaymentOrderData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'deleteTime': instance.deleteTime,
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'deletedBy': instance.deletedBy,
      'uuid': instance.uuid,
      'type': instance.type,
      'quota': instance.quota,
      'lotteryType': instance.lotteryType,
      'payAmount': instance.payAmount,
      'remark': instance.remark,
      'paymentMethod': instance.paymentMethod,
      'origin': instance.origin,
      'status': instance.status,
      'tenantUuid': instance.tenantUuid,
      'pCreatedBy': instance.pCreatedBy,
      'pUpdatedBy': instance.pUpdatedBy,
      'tCreatedBy': instance.tCreatedBy,
      'tUpdatedBy': instance.tUpdatedBy,
    };

CreatePaymentOrderResponse _$CreatePaymentOrderResponseFromJson(
        Map<String, dynamic> json) =>
    CreatePaymentOrderResponse(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      data:
          CreatePaymentOrderData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreatePaymentOrderResponseToJson(
        CreatePaymentOrderResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };

PackageInfo _$PackageInfoFromJson(Map<String, dynamic> json) => PackageInfo(
      uuid: json['uuid'] as String,
      lotteryType: (json['lotteryType'] as num).toInt(),
      minQuantity: (json['minQuantity'] as num).toInt(),
      bonusQuantity: (json['bonusQuantity'] as num).toInt(),
      rechargeAmount: json['rechargeAmount'] as String,
    );

Map<String, dynamic> _$PackageInfoToJson(PackageInfo instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'lotteryType': instance.lotteryType,
      'minQuantity': instance.minQuantity,
      'bonusQuantity': instance.bonusQuantity,
      'rechargeAmount': instance.rechargeAmount,
    };

PackageInfoData _$PackageInfoDataFromJson(Map<String, dynamic> json) =>
    PackageInfoData(
      list: (json['list'] as List<dynamic>)
          .map((e) => PackageInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PackageInfoDataToJson(PackageInfoData instance) =>
    <String, dynamic>{
      'list': instance.list,
    };

GetPackagesResponse _$GetPackagesResponseFromJson(Map<String, dynamic> json) =>
    GetPackagesResponse(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      data: PackageInfoData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetPackagesResponseToJson(
        GetPackagesResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };

RechargeRecord _$RechargeRecordFromJson(Map<String, dynamic> json) =>
    RechargeRecord(
      uuid: json['uuid'] as String,
      tenantUuid: json['tenantUuid'] as String,
      type: json['type'] as String,
      quota: json['quota'] as String,
      lotteryType: json['lotteryType'] as String,
      payAmount: json['payAmount'] as String,
      remark: json['remark'] as String?,
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
      createTime: json['createTime'] as String,
    );

Map<String, dynamic> _$RechargeRecordToJson(RechargeRecord instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'tenantUuid': instance.tenantUuid,
      'type': instance.type,
      'quota': instance.quota,
      'lotteryType': instance.lotteryType,
      'payAmount': instance.payAmount,
      'remark': instance.remark,
      'paymentMethod': instance.paymentMethod,
      'status': instance.status,
      'createTime': instance.createTime,
    };

GetRechargesResponse _$GetRechargesResponseFromJson(
        Map<String, dynamic> json) =>
    GetRechargesResponse(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => RechargeRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetRechargesResponseToJson(
        GetRechargesResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
