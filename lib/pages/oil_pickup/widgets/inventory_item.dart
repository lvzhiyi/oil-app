import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/resources/colors.dart';
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
    final isLowStock = !isOutOfStock && availableInventory < 5.0;

    final fuelInfo = _parseFuelType(fuelType);
    final isDiesel = _isDiesel(fuelInfo.code);

    return Container(
      margin: EdgeInsets.only(bottom: pt(12)),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        borderRadius: BorderRadius.circular(pt(16)),
        border: Border.all(
          color: const Color(0x08000000),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x00000000).withValues(alpha: 0.02),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Card Header: Depot Info
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: pt(16),
              vertical: pt(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Depot Icon
                    Icon(
                      Icons.warehouse_outlined,
                      size: pt(14),
                      color: CustomAppColor.of(context).txtGrey,
                    ),
                    Gap(pt(6)),
                    // Depot Name
                    Expanded(
                      child: Text(
                        depotName,
                        style: TextStyle(
                          fontSize: pt(14),
                          fontWeight: FontWeight.w600,
                          color: CustomAppColor.of(context).txtBlack,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Gap(pt(12)),
                _buildDashedDivider(),
              ],
            ),
          ),

          // Card Body
          Padding(
            padding: EdgeInsets.only(left: pt(16), right: pt(16), bottom: pt(16)),
            child: Row(
              children: [
                // Left: Oil Badge
                _buildOilBadge(
                  fuelInfo: fuelInfo,
                  isDiesel: isDiesel,
                  isOutOfStock: isOutOfStock,
                ),

                Gap(pt(14)),

                // Middle: Stock Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '当前持有',
                        style: TextStyle(
                          fontSize: pt(11),
                          color: CustomAppColor.of(context).txtGrey,
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
                              fontSize: pt(26),
                              fontWeight: FontWeight.w700,
                              fontFeatures: const [FontFeature.tabularFigures()],
                              color: isOutOfStock
                                  ? const Color(0xFFCCCCCC)
                                  : CustomAppColor.of(context).txtBlack,
                              height: 1.0,
                            ),
                          ),
                          Gap(pt(2)),
                          Text(
                            '吨',
                            style: TextStyle(
                              fontSize: pt(12),
                              fontWeight: FontWeight.w500,
                              color: CustomAppColor.of(context).txtGrey,
                            ),
                          ),
                        ],
                      ),
                      Gap(pt(6)),
                      if (!isOutOfStock) _buildStockStatusTag(isLowStock),
                    ],
                  ),
                ),

                // Right: Action Button
                _buildActionButton(
                  context: context,
                  isOutOfStock: isOutOfStock,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOilBadge({
    required ({String code, String name}) fuelInfo,
    required bool isDiesel,
    required bool isOutOfStock,
  }) {
    Color badgeBgColor;
    Color badgeTextColor;

    if (isOutOfStock) {
      badgeBgColor = const Color(0xFFF5F5F5);
      badgeTextColor = const Color(0xFFAAAAAA);
    } else if (isDiesel) {
      badgeBgColor = AppColor.dieselBg;
      badgeTextColor = AppColor.dieselText;
    } else {
      badgeBgColor = AppColor.gasBg;
      badgeTextColor = AppColor.gasText;
    }

    return Container(
      width: pt(52),
      height: pt(52),
      decoration: BoxDecoration(
        color: badgeBgColor,
        borderRadius: BorderRadius.circular(pt(12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            fuelInfo.code,
            style: TextStyle(
              fontSize: pt(18),
              fontWeight: FontWeight.w700,
              color: badgeTextColor,
              height: 1.1,
            ),
          ),
          if (fuelInfo.name.isNotEmpty) ...[
            Text(
              fuelInfo.name,
              style: TextStyle(
                fontSize: pt(11),
                fontWeight: FontWeight.w500,
                color: isOutOfStock
                    ? const Color(0xFFAAAAAA)
                    : badgeTextColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStockStatusTag(bool isLowStock) {
    final Color tagColor;
    final String tagText;

    if (isLowStock) {
      tagColor = AppColor.stockLow;
      tagText = '库存紧张';
    } else {
      tagColor = AppColor.stockSufficient;
      tagText = '库存充足';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: pt(6),
          height: pt(6),
          decoration: BoxDecoration(
            color: tagColor,
            shape: BoxShape.circle,
          ),
        ),
        Gap(pt(4)),
        Text(
          tagText,
          style: TextStyle(
            fontSize: pt(11),
            fontWeight: FontWeight.w500,
            color: tagColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required bool isOutOfStock,
  }) {
    final themeColor = CustomAppColor.of(context).btnPurple;

    return Material(
      color: isOutOfStock ? const Color(0xFFEEEEEE) : themeColor,
      borderRadius: BorderRadius.circular(pt(20)),
      child: InkWell(
        onTap: isOutOfStock ? null : onTap,
        borderRadius: BorderRadius.circular(pt(20)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: pt(20),
            vertical: pt(8),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(pt(20)),
            boxShadow: isOutOfStock
                ? null
                : [
                    BoxShadow(
                      color: themeColor.withValues(alpha: 0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                      spreadRadius: 0,
                    ),
                  ],
          ),
          child: Text(
            isOutOfStock ? '暂无库存' : '去提油',
            style: TextStyle(
              fontSize: pt(14),
              fontWeight: FontWeight.w600,
              color: isOutOfStock
                  ? const Color(0xFFBBBBBB)
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  bool _isDiesel(String code) {
    if (code.isEmpty) return false;
    
    final numberPart = RegExp(r'[-]?\d+').stringMatch(code) ?? '';
    
    if (['0', '-10', '-20', '-35', '-50'].contains(numberPart)) {
      return true;
    }
    
    if (['92', '95', '98'].any((e) => numberPart.contains(e))) {
      return false;
    }
    
    return false;
  }

  ({String code, String name}) _parseFuelType(String fuelType) {
    if (fuelType.isEmpty) return (code: '', name: '');

    String code = '';
    String name = '';
    String numberPart = RegExp(r'[-]?\d+').stringMatch(fuelType) ?? '';

    if (fuelType.contains('#')) {
      final match = RegExp(r'([#]?[-]?\d+[#]?)(.*)').firstMatch(fuelType);
      if (match != null) {
        code = match.group(1) ?? '';
        name = match.group(2) ?? '';
      } else {
        code = fuelType;
      }
    } else if (RegExp(r'[-]?\d+').hasMatch(fuelType)) {
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

  Widget _buildDashedDivider() {
    return CustomPaint(
      painter: DashedLinePainter(
        color: const Color(0xFFF3F4F6),
        strokeWidth: 1,
        dashWidth: 4,
        dashSpace: 4,
      ),
      child: const SizedBox(
        height: 1,
        width: double.infinity,
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedLinePainter({
    required this.color,
    this.strokeWidth = 1,
    this.dashWidth = 4,
    this.dashSpace = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace;
  }
}
