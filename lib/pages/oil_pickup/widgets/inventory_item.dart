import 'package:flutter/material.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class InventoryItem extends StatelessWidget {
  final InventoryModel inventory;
  final VoidCallback? onTap;

  const InventoryItem({
    Key? key,
    required this.inventory,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final depotName = inventory.depotName ?? '';
    final fuelType = inventory.fuelType ?? '';
    final availableInventory = inventory.availableTon ?? 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: depotName,
                    fontSize: AppSizes.setFontSize(16),
                    fontWeight: FontWeight.w600,
                    textColor: CustomAppColor.of(context).txtBlack,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: AppSizes.setHeight(8)),
                  CommonText(
                    text: '油品: $fuelType',
                    fontSize: AppSizes.setFontSize(14),
                    fontWeight: FontWeight.w400,
                    textColor: CustomAppColor.of(context).txtGrey,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonText(
                    text: '剩余库存',
                    fontSize: AppSizes.setFontSize(12),
                    fontWeight: FontWeight.w400,
                    textColor: CustomAppColor.of(context).txtGrey,
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: AppSizes.setHeight(4)),
                  CommonText(
                    text: '${availableInventory.toInt()}吨',
                    fontSize: AppSizes.setFontSize(18),
                    fontWeight: FontWeight.w600,
                    textColor: CustomAppColor.of(context).txtBlack,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
