// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unified_payment_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnifiedPaymentType _$UnifiedPaymentTypeFromJson(Map<String, dynamic> json) =>
    UnifiedPaymentType(
      uuid: json['uuid'] as String?,
      lotteryType: json['lotteryType'] as String?,
      minQuantity: json['minQuantity'] as String?,
      bonusQuantity: json['bonusQuantity'] as String?,
      rechargeAmount: json['rechargeAmount'] as String?,
    );

Map<String, dynamic> _$UnifiedPaymentTypeToJson(UnifiedPaymentType instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'lotteryType': instance.lotteryType,
      'minQuantity': instance.minQuantity,
      'bonusQuantity': instance.bonusQuantity,
      'rechargeAmount': instance.rechargeAmount,
    };
