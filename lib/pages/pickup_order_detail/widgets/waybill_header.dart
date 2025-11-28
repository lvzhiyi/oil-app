import 'package:flutter/material.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

/// 运单头部组件
///
/// 显示订单状态图标、状态文字和订单号
class WaybillHeader extends StatelessWidget {
  final String? status;
  final String? orderNo;

  const WaybillHeader({
    Key? key,
    required this.status,
    this.orderNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status == WithdrawStatus.completed.value;
    final bool isCancelled = status == WithdrawStatus.cancelled.value;

    // 显示简短的订单号（如果太长则截断）
    final shortOrderNo = _formatOrderNo(orderNo);

    // 根据状态设置样式
    final statusData = _getStatusData(isCompleted, isCancelled);

    return Container(
      padding: EdgeInsets.all(AppSizes.setWidth(20)),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                statusData['icon'] as IconData,
                size: AppSizes.setFontSize(24),
                color: statusData['color'] as Color,
              ),
              SizedBox(width: AppSizes.setWidth(8)),
              CommonText(
                text: statusData['text'] as String,
                fontSize: AppSizes.setFontSize(20),
                fontWeight: FontWeight.w700,
                textColor: statusData['color'] as Color,
              ),
            ],
          ),
          CommonText(
            text: shortOrderNo,
            fontSize: AppSizes.setFontSize(13),
            textColor: const Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }

  String _formatOrderNo(String? orderNo) {
    if (orderNo == null || orderNo.isEmpty) return '';

    if (orderNo.length > 15) {
      return '${orderNo.substring(0, 15)}...${orderNo.substring(orderNo.length - 5)}';
    }
    return orderNo;
  }

  Map<String, dynamic> _getStatusData(bool isCompleted, bool isCancelled) {
    if (isCompleted) {
      return {
        'text': '已完成',
        'color': const Color(0xFF10B981),
        'icon': Icons.check_circle,
      };
    } else if (isCancelled) {
      return {
        'text': '已取消',
        'color': const Color(0xFF9CA3AF),
        'icon': Icons.cancel,
      };
    } else {
      return {
        'text': '待提油',
        'color': const Color(0xFFF59E0B),
        'icon': Icons.access_time,
      };
    }
  }
}
