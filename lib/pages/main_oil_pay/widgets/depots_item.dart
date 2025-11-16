import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/pages/main_oil_pay/model/oil_order_res.type.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/resources/size.dart';
import 'package:oil_business_app/resources/style.dart';
import 'package:oil_business_app/utils/pt.dart';

class DepotsItemWidget extends StatelessWidget {
  final bool forBottomSheet;
  final Depot depot;
  final Function()? onTap;

  const DepotsItemWidget({
    super.key,
    this.forBottomSheet = false,
    required this.depot,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部：左侧油库名称，右侧地址
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 左侧：油库名称
                  Expanded(
                    child: Text(
                      depot.depotName ?? '未知油库',
                      style: SportsTextStyle.baseBold.copyWith(
                        fontSize: pt(16),
                        color: CustomAppColor.of(context).txtBlack,
                      ),
                    ),
                  ),
                  Gap(pt(12)),
                  // 右侧：地址
                  Expanded(
                    child: Text(
                      _buildAddress(depot),
                      textAlign: TextAlign.right,
                      style: SportsTextStyle.baseNormal.copyWith(
                        fontSize: pt(14),
                        color: CustomAppColor.of(context).txtGrey,
                      ),
                    ),
                  ),
                ],
              ),
              // 油品信息：三列显示
              if (depot.fuels != null && depot.fuels!.isNotEmpty) ...[
                Gap(pt(16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: depot.fuels!.take(3).map((fuel) {
                    return Expanded(
                      child: _FuelColumn(
                        fuelType: fuel.fuelType ?? '',
                        price: fuel.priceCny ?? 0,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 构建地址字符串
  String _buildAddress(Depot depot) {
    final parts = <String>[];
    if (depot.provinceName != null && depot.provinceName!.isNotEmpty) {
      parts.add(depot.provinceName!);
    }
    if (depot.cityName != null && depot.cityName!.isNotEmpty) {
      parts.add(depot.cityName!);
    }
    if (depot.areaName != null && depot.areaName!.isNotEmpty) {
      parts.add(depot.areaName!);
    }
    return parts.isEmpty ? '地址信息暂无' : parts.join('');
  }
}

/// 油品列组件（显示油品类型和价格）
class _FuelColumn extends StatelessWidget {
  final String fuelType;
  final double price;

  const _FuelColumn({
    required this.fuelType,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 油品类型（如：92、95、0）
        Text(
          fuelType,
          style: SportsTextStyle.baseBold.copyWith(
            fontSize: pt(16),
            color: CustomAppColor.of(context).txtBlack,
          ),
        ),
        Gap(pt(4)),
        // 价格（如：6000元/吨）
        Text(
          '${price.toStringAsFixed(0)}元/吨',
          style: SportsTextStyle.baseNormal.copyWith(
            fontSize: pt(14),
            color: CustomAppColor.of(context).txtBlack,
          ),
        ),
      ],
    );
  }
}
