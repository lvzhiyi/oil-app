import 'package:json_annotation/json_annotation.dart';
part 'unified_payment_type.g.dart';

@JsonSerializable()
class UnifiedPaymentType {
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

  UnifiedPaymentType({
    this.uuid,
    this.lotteryType,
    this.minQuantity,
    this.bonusQuantity,
    this.rechargeAmount,
  });

  factory UnifiedPaymentType.fromJson(Map<String, dynamic> json) =>
      _$UnifiedPaymentTypeFromJson(json);

  Map<String, dynamic> toJson() => _$UnifiedPaymentTypeToJson(this);

  UnifiedPaymentType copyWith({
    String? uuid,
    String? lotteryType,
    String? minQuantity,
    String? bonusQuantity,
    String? rechargeAmount,
  }) {
    return UnifiedPaymentType(
      uuid: uuid ?? this.uuid,
      lotteryType: lotteryType ?? this.lotteryType,
      minQuantity: minQuantity ?? this.minQuantity,
      bonusQuantity: bonusQuantity ?? this.bonusQuantity,
      rechargeAmount: rechargeAmount ?? this.rechargeAmount,
    );
  }
}

