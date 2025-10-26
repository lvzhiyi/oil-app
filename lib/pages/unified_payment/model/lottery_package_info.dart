import 'package:json_annotation/json_annotation.dart';
part 'lottery_package_info.g.dart';

@JsonSerializable()
class LotteryPackageInfo {
  @JsonKey(name: 'uuid')
  String? uuid;
  @JsonKey(name: 'lotteryType')
  String? lotteryType;
  @JsonKey(name: 'minQuantity')
  String? minQuantity;
  @JsonKey(name: 'bonusQuantity')
  String? bonusQuantity;
  @JsonKey(name: 'rechargeAmount')
  String? rechargeAmount;

  LotteryPackageInfo({
    this.uuid,
    this.lotteryType,
    this.minQuantity,
    this.bonusQuantity,
    this.rechargeAmount,
  });

  factory LotteryPackageInfo.fromJson(Map<String, dynamic> json) =>
      _$LotteryPackageInfoFromJson(json);

  Map<String, dynamic> toJson() => _$LotteryPackageInfoToJson(this);

  LotteryPackageInfo copyWith({
    String? uuid,
    String? lotteryType,
    String? minQuantity,
    String? bonusQuantity,
    String? rechargeAmount,
  }) {
    return LotteryPackageInfo(
      uuid: uuid ?? this.uuid,
      lotteryType: lotteryType ?? this.lotteryType,
      minQuantity: minQuantity ?? this.minQuantity,
      bonusQuantity: bonusQuantity ?? this.bonusQuantity,
      rechargeAmount: rechargeAmount ?? this.rechargeAmount,
    );
  }
}
