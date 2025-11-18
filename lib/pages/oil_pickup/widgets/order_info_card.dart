import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/pay_order_list/model/orders_data.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

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
    final availableInventory = order!.availableInventory ?? 0.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(18),
        vertical: AppSizes.setHeight(16),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D35),
        borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: CommonText(
              text: depotName,
              fontSize: AppSizes.setFontSize(14),
              fontWeight: FontWeight.w500,
              textColor: CustomAppColor.of(context).txtWhite,
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 1,
            child: CommonText(
              text: fuelType,
              fontSize: AppSizes.setFontSize(14),
              fontWeight: FontWeight.w500,
              textColor: CustomAppColor.of(context).txtWhite,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonText(
                  text: '库存',
                  fontSize: AppSizes.setFontSize(12),
                  fontWeight: FontWeight.w400,
                  textColor: CustomAppColor.of(context).txtWhite.withValues(alpha: 0.7),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: AppSizes.setHeight(4)),
                CommonText(
                  text: '${availableInventory.toInt()}吨',
                  fontSize: AppSizes.setFontSize(14),
                  fontWeight: FontWeight.w500,
                  textColor: CustomAppColor.of(context).txtWhite,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

