// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lottery_package_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LotteryPackageInfo _$LotteryPackageInfoFromJson(Map<String, dynamic> json) =>
    LotteryPackageInfo(
      uuid: json['uuid'] as String?,
      lotteryType: json['lotteryType'] as String?,
      minQuantity: json['minQuantity'] as String?,
      bonusQuantity: json['bonusQuantity'] as String?,
      rechargeAmount: json['rechargeAmount'] as String?,
    );

Map<String, dynamic> _$LotteryPackageInfoToJson(LotteryPackageInfo instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'lotteryType': instance.lotteryType,
      'minQuantity': instance.minQuantity,
      'bonusQuantity': instance.bonusQuantity,
      'rechargeAmount': instance.rechargeAmount,
    };
