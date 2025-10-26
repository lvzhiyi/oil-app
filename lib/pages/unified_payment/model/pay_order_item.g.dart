// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayOrderItem _$PayOrderItemFromJson(Map<String, dynamic> json) => PayOrderItem(
      uuid: json['uuid'] as String?,
      tenantUuid: json['tenantUuid'] as String?,
      type: json['type'] as String?,
      quota: json['quota'] as String?,
      lotteryType: json['lotteryType'] as String?,
      payAmount: json['payAmount'] as String?,
      remark: json['remark'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      status: json['status'] as String?,
      createTime: json['createTime'] as String?,
    );

Map<String, dynamic> _$PayOrderItemToJson(PayOrderItem instance) =>
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
