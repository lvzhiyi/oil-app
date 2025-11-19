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
    final availableInventory = order!.purchaseTon ?? 0.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.setWidth(16)),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).bgContainer,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
        border: Border.all(
          color: CustomAppColor.of(context).containerBorder,
          width: 1,
        ),
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
              textColor: CustomAppColor.of(context).txtBlack,
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            flex: 1,
            child: CommonText(
              text: fuelType,
              fontSize: AppSizes.setFontSize(14),
              fontWeight: FontWeight.w500,
              textColor: CustomAppColor.of(context).txtBlack,
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
                  textColor: CustomAppColor.of(context).txtGrey,
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: AppSizes.setHeight(4)),
                CommonText(
                  text: '${availableInventory.toInt()}吨',
                  fontSize: AppSizes.setFontSize(14),
                  fontWeight: FontWeight.w500,
                  textColor: CustomAppColor.of(context).txtBlack,
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

