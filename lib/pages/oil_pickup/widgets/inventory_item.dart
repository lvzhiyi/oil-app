import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/size.dart';
import 'package:oil_business_app/resources/style.dart';
import 'package:oil_business_app/utils/pt.dart';

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

    return Container(
      margin: EdgeInsets.only(bottom: pt(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppSize.radius,
        boxShadow: AppSize.boxShadow,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSize.radius,
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
      ),
    );
  }
}
