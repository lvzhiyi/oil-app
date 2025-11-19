import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/pages/pay_order_list/model/orders_data.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/size.dart';
import 'package:oil_business_app/resources/style.dart';
import 'package:oil_business_app/utils/pt.dart';

/// 订单信息卡片组件
/// 显示油库名称、油品类型、剩余库存
class OrderInfoCard extends StatelessWidget {
  final OrderModel? order;

  const OrderInfoCard({
    Key? key,
    this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (order == null) {
      return const SizedBox.shrink();
    }

    final depotName = order!.depotName ?? '';
    final fuelType = order!.fuelType ?? '';
    final availableInventory = order!.purchaseTon ?? 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: pt(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSize.radius,
        border: Border.all(
          color: CustomAppColor.of(context).containerBorder,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(pt(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                depotName,
                style: SportsTextStyle.baseBold.copyWith(
                  fontSize: pt(16),
                  color: CustomAppColor.of(context).txtBlack,
                ),
              ),
            ),
            Gap(pt(12)),
            Expanded(
              flex: 2,
              child: Text(
                fuelType,
                textAlign: TextAlign.center,
                style: SportsTextStyle.baseNormal.copyWith(
                  fontSize: pt(14),
                  color: CustomAppColor.of(context).txtGrey,
                ),
              ),
            ),
            Gap(pt(12)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '剩余库存',
                  style: SportsTextStyle.baseBold.copyWith(
                    fontSize: pt(16),
                    color: CustomAppColor.of(context).txtBlack,
                  ),
                ),
                Gap(pt(4)),
                Text(
                  '${availableInventory.toInt()}吨',
                  style: SportsTextStyle.baseNormal.copyWith(
                    fontSize: pt(14),
                    color: CustomAppColor.of(context).txtBlack,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

