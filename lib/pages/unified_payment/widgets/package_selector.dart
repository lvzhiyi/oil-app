import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/global/enum/common.dart';
import 'package:lottery_app/resources/style.dart';
import 'package:lottery_app/utils/pt.dart';

import '../model/lottery_package_info.dart';
import '../model/selected_package_info.dart';

class PackageSelector extends StatelessWidget {
  final List<LotteryPackageInfo> packages;
  final LotteryPackageInfo? selectedPackage;
  final Function(SelectedPackageInfo) onPackageSelected;

  const PackageSelector({
    Key? key,
    required this.packages,
    required this.selectedPackage,
    required this.onPackageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '选择套餐',
          style: SportsTextStyle.baseBold.copyWith(
            fontSize: pt(16),
            color: Colors.black,
          ),
        ),
        Gap(pt(16)),
        ...packages.map((package) {
          return _buildPackageItem(package);
        }).toList(),
      ],
    );
  }

  Widget _buildPackageItem(LotteryPackageInfo package) {
    final isSelected = selectedPackage?.uuid == package.uuid;
    final hasBonus = int.parse(package.bonusQuantity!) > 0;
    final lotteryType = LotteryType.fromValue(int.parse(package.lotteryType!));

    return GestureDetector(
      onTap: () => onPackageSelected(SelectedPackageInfo(
        uuid: package.uuid,
        lotteryType: package.lotteryType,
        minQuantity: package.minQuantity,
        bonusQuantity: package.bonusQuantity,
        rechargeAmount: package.rechargeAmount,
        totalQuantity:
            int.parse(package.minQuantity!) + int.parse(package.bonusQuantity!),
        hasBonus: hasBonus,
      )),
      child: Container(
        margin: EdgeInsets.only(bottom: pt(16)),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(pt(20)),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue.withValues(alpha: 0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(pt(12)),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[200]!,
                  width: 1,
                ),
                boxShadow: [
                  if (!isSelected)
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: pt(4),
                      offset: Offset(0, pt(2)),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${lotteryType.displayName}套餐',
                              style: SportsTextStyle.baseBold.copyWith(
                                fontSize: pt(16),
                                color: isSelected ? Colors.blue : Colors.black,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '购买${package.minQuantity!}张${lotteryType.displayName}',
                                  style: SportsTextStyle.baseNormal.copyWith(
                                    fontSize: pt(14),
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Gap(pt(8)),
                                if (hasBonus)
                                  Expanded(
                                    child: Text(
                                      '赠送${package.bonusQuantity!}张${lotteryType.displayName}',
                                      style: SportsTextStyle.baseBold.copyWith(
                                        fontSize: pt(14),
                                        color: Colors.orange,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // if (isSelected)
                      //   Container(
                      //     width: pt(24),
                      //     height: pt(24),
                      //     decoration: const BoxDecoration(
                      //       color: Colors.blue,
                      //       shape: BoxShape.circle,
                      //     ),
                      //     child: Icon(
                      //       Icons.check,
                      //       color: Colors.white,
                      //       size: pt(16),
                      //     ),
                      //   ),
                    ],
                  ),
                  Gap(pt(16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '总价',
                            style: SportsTextStyle.baseNormal.copyWith(
                              fontSize: pt(12),
                              color: Colors.grey[600],
                            ),
                          ),
                          Gap(pt(4)),
                          Text(
                            '¥${package.rechargeAmount!}',
                            style: SportsTextStyle.baseBold.copyWith(
                              fontSize: pt(24),
                              color: isSelected ? Colors.blue : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: pt(8),
                              vertical: pt(4),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(pt(4)),
                            ),
                            child: Text(
                              '共${int.parse(package.minQuantity ?? '0') + int.parse(package.bonusQuantity ?? '0')}张',
                              style: SportsTextStyle.baseBold.copyWith(
                                fontSize: pt(12),
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          // Gap(pt(4)),
                          // Text(
                          //   '单价¥${package.unitPrice.toStringAsFixed(2)}',
                          //   style: SportsTextStyle.baseNormal.copyWith(
                          //     fontSize: pt(12),
                          //     color: Colors.grey[600],
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (hasBonus)
              Positioned(
                top: 0,
                right: pt(20),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: pt(12),
                    vertical: pt(6),
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(pt(8)),
                      bottomRight: Radius.circular(pt(8)),
                    ),
                  ),
                  child: Text(
                    '有赠送',
                    style: SportsTextStyle.baseBold.copyWith(
                      fontSize: pt(10),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
