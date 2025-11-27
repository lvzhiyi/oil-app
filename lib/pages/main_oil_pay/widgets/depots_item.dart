import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oil_business_app/pages/main_oil_pay/model/oil_order_res.type.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class DepotsItemWidget extends StatefulWidget {
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
  State<DepotsItemWidget> createState() => _DepotsItemWidgetState();
}

class _DepotsItemWidgetState extends State<DepotsItemWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: Transform.scale(
        scale: _isPressed ? 0.98 : 1.0,
        child: Container(
          margin: EdgeInsets.only(bottom: AppSizes.setHeight(12)),
          decoration: BoxDecoration(
            color: _isPressed ? const Color(0xFFFAFAFA) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isPressed ? AppColor.txtPurple : Colors.transparent,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSizes.setWidth(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 卡片头部
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            text: widget.depot.depotName ?? '未知油库',
                            fontSize: AppSizes.setFontSize(16),
                            fontWeight: FontWeight.w700,
                            textColor: const Color(0xFF111827),
                          ),
                          SizedBox(height: AppSizes.setHeight(4)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: AppSizes.setWidth(12),
                                color: const Color(0xFF6B7280),
                              ),
                              SizedBox(width: AppSizes.setWidth(4)),
                              CommonText(
                                text: _buildAddress(widget.depot),
                                fontSize: AppSizes.setFontSize(12),
                                textColor: const Color(0xFF6B7280),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSizes.setWidth(12)),
                    // 去购油按钮
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.setWidth(10),
                          vertical: AppSizes.setHeight(6),
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEECFC),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CommonText(
                              text: '去购油',
                              fontSize: AppSizes.setFontSize(13),
                              fontWeight: FontWeight.w600,
                              textColor: AppColor.txtPurple,
                            ),
                            SizedBox(width: AppSizes.setWidth(2)),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: AppSizes.setWidth(14),
                              color: AppColor.txtPurple,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: AppSizes.setHeight(12),
                  thickness: 1,
                  color: const Color(0xFFE5E7EB),
                ),
                // 价格网格
                if (widget.depot.fuels != null &&
                    widget.depot.fuels!.isNotEmpty)
                  Row(
                    children: widget.depot.fuels!.take(3).map((fuel) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.setWidth(4),
                          ),
                          child: _PriceItem(
                            fuelType: fuel.fuelType ?? '',
                            price: fuel.priceCny ?? 0,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
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

/// 价格项组件
class _PriceItem extends StatelessWidget {
  final String fuelType;
  final double price;

  const _PriceItem({
    required this.fuelType,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final formattedPrice = formatter.format(price);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.setWidth(8),
            vertical: AppSizes.setHeight(2),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(4),
          ),
          child: CommonText(
            text: fuelType,
            fontSize: AppSizes.setFontSize(12),
            textColor: const Color(0xFF6B7280),
          ),
        ),
        SizedBox(height: AppSizes.setHeight(6)),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: AppSizes.setFontSize(18),
              fontWeight: FontWeight.w700,
              color: AppColor.txtPurple,
              fontFamily: 'DIN Alternate',
            ),
            children: [
              TextSpan(text: formattedPrice),
              TextSpan(
                text: '元/吨',
                style: TextStyle(
                  fontSize: AppSizes.setFontSize(11),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
