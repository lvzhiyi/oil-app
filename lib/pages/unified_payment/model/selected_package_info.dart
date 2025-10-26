import 'package:lottery_app/pages/unified_payment/model/lottery_package_info.dart';

class SelectedPackageInfo extends LotteryPackageInfo {
  bool hasBonus;
  int totalQuantity;
  SelectedPackageInfo({
    required super.uuid,
    required super.lotteryType,
    required super.minQuantity,
    required super.bonusQuantity,
    required super.rechargeAmount,
    this.hasBonus = false,
    this.totalQuantity = 0,
  });

  @override
  SelectedPackageInfo copyWith({
    bool? hasBonus,
    String? uuid,
    String? lotteryType,
    String? minQuantity,
    String? bonusQuantity,
    String? rechargeAmount,
    int? totalQuantity,
  }) {
    return SelectedPackageInfo(
      uuid: uuid,
      lotteryType: lotteryType,
      minQuantity: minQuantity,
      bonusQuantity: bonusQuantity,
      rechargeAmount: rechargeAmount,
      hasBonus: hasBonus ?? this.hasBonus,
      totalQuantity: totalQuantity ?? this.totalQuantity,
    );
  }
}