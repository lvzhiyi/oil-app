import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/fuel_type_helper.dart';
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
    final isOutOfStock = availableInventory <= 0;
    // Define low stock threshold (e.g. less than 5 tons)
    final isLowStock = !isOutOfStock && availableInventory < 5.0;
    final themeColor = CustomAppColor.of(context).btnPurple;

    final fuelInfo = _parseFuelType(fuelType);

    // Determine colors based on stock status
    Color symbolBgColor;
    Color symbolTextColor;

    if (isOutOfStock) {
      symbolBgColor = const Color(0xFFF5F5F5);
      symbolTextColor = const Color(0xFFAAAAAA);
    } else if (isLowStock) {
      symbolBgColor = AppColor.orange.withValues(alpha: 0.08);
      symbolTextColor = AppColor.orange;
    } else {
      symbolBgColor = themeColor.withOpacity(0.08);
      symbolTextColor = themeColor;
    }

    return Container(
      margin: EdgeInsets.only(bottom: pt(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.06),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: pt(16), vertical: pt(12)),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFF5F5F5),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    depotName,
                    style: TextStyle(
                      fontSize: pt(15),
                      fontWeight: FontWeight.bold,
                      color: CustomAppColor.of(context).txtBlack,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Gap(pt(8)),
                Container(
                  width: pt(6),
                  height: pt(6),
                  decoration: BoxDecoration(
                    color: (isLowStock || isOutOfStock)
                        ? AppColor.orange
                        : CustomAppColor.of(context).green,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: EdgeInsets.all(pt(16)),
            child: Row(
              children: [
                // Left: Symbol
                Container(
                  width: pt(56),
                  height: pt(56),
                  decoration: BoxDecoration(
                    color: symbolBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        fuelInfo.code,
                        style: TextStyle(
                          fontSize: pt(20),
                          fontWeight: FontWeight.w900,
                          color: symbolTextColor,
                          height: 1.0,
                        ),
                      ),
                      if (fuelInfo.name.isNotEmpty) ...[
                        Gap(pt(4)),
                        Text(
                          fuelInfo.name,
                          style: TextStyle(
                            fontSize: pt(10),
                            fontWeight: FontWeight.w500,
                            color: isOutOfStock
                                ? const Color(0xFFAAAAAA)
                                : symbolTextColor.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                Gap(pt(16)),

                // Middle: Stock
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '当前持有',
                        style: TextStyle(
                          fontSize: pt(12),
                          color: const Color(0xff888888),
                        ),
                      ),
                      Gap(pt(2)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${availableInventory.toInt()}',
                            style: TextStyle(
                              fontSize: pt(24),
                              fontWeight: FontWeight.bold,
                              color: isOutOfStock
                                  ? const Color(0xFFCCCCCC)
                                  : CustomAppColor.of(context).txtBlack,
                            ),
                          ),
                          Gap(pt(2)),
                          Text(
                            '吨',
                            style: TextStyle(
                              fontSize: pt(12),
                              color: const Color(0xff888888),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right: Button
                Material(
                  color: isOutOfStock ? const Color(0xFFEEEEEE) : themeColor,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    onTap: isOutOfStock ? null : onTap,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      height: pt(36),
                      padding: EdgeInsets.symmetric(horizontal: pt(20)),
                      alignment: Alignment.center,
                      child: Text(
                        isOutOfStock ? '暂无库存' : '去提油',
                        style: TextStyle(
                          fontSize: pt(13),
                          fontWeight: FontWeight.w600,
                          color: isOutOfStock
                              ? const Color(0xFFBBBBBB)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ({String code, String name}) _parseFuelType(String fuelType) {
    if (fuelType.isEmpty) return (code: '', name: '');

    String code = '';
    String name = '';
    String numberPart = RegExp(r'[-]?\d+').stringMatch(fuelType) ?? '';

    if (fuelType.contains('#')) {
      // Handle formats like "#95汽油" or "95#汽油"
      final match = RegExp(r'([#]?[-]?\d+[#]?)(.*)').firstMatch(fuelType);
      if (match != null) {
        code = match.group(1) ?? '';
        name = match.group(2) ?? '';
      } else {
        code = fuelType;
      }
    } else if (RegExp(r'[-]?\d+').hasMatch(fuelType)) {
      // Handle format like "95汽油" (implied #95)
      final match = RegExp(r'^([-]?\d+)(.*)').firstMatch(fuelType);
      if (match != null) {
        code = '#${match.group(1)}';
        name = match.group(2) ?? '';
      } else {
        code = fuelType;
      }
    } else {
      code = fuelType;
    }

    name = name.trim();

    // Infer "汽油" or "柴油" if not present
    if (!name.contains('汽油') && !name.contains('柴油')) {
      if (['92', '95', '98'].any((e) => numberPart.contains(e))) {
        name = name.isEmpty ? '汽油' : '$name 汽油';
      } else if (['0', '-10', '-20', '-35', '-50'].contains(numberPart)) {
        name = name.isEmpty ? '柴油' : '$name 柴油';
      }
    }

    if (code.isEmpty && name.isEmpty) {
      name = fuelType;
    }

    return (code: code, name: name);
  }
}
