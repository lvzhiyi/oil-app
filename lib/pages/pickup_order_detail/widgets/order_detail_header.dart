import 'package:flutter/material.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

/// 订单详情页头部组件
///
/// 根据订单状态显示不同的图标、标题和描述
class OrderDetailHeader extends StatelessWidget {
  final String? status;

  const OrderDetailHeader({
    Key? key,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerConfig = _getHeaderConfig(context);

    return Column(
      children: [
        Container(
          width: AppSizes.setWidth(76),
          height: AppSizes.setWidth(76),
          decoration: BoxDecoration(
            color: headerConfig.backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            headerConfig.icon,
            size: AppSizes.setWidth(40),
            color: headerConfig.iconColor,
          ),
        ),
        SizedBox(height: AppSizes.setHeight(12)),
        CommonText(
          text: headerConfig.title,
          fontSize: AppSizes.setFontSize(18),
          fontWeight: FontWeight.w600,
          textColor: CustomAppColor.of(context).txtBlack,
        ),
        SizedBox(height: AppSizes.setHeight(6)),
        CommonText(
          text: headerConfig.subtitle,
          fontSize: AppSizes.setFontSize(13),
          fontWeight: FontWeight.w400,
          textColor: const Color(0xff6B7280),
        ),
      ],
    );
  }

  _HeaderConfig _getHeaderConfig(BuildContext context) {
    if (status == WithdrawStatus.pendingPickup.value) {
      return _HeaderConfig(
        icon: Icons.access_time_rounded,
        iconColor: AppColor.primaryColor,
        backgroundColor: AppColor.secondaryLight,
        title: '待提油',
        subtitle: '请保存凭证图片发送给司机',
      );
    } else if (status == WithdrawStatus.completed.value) {
      return _HeaderConfig(
        icon: Icons.check,
        iconColor: CustomAppColor.of(context).green,
        backgroundColor: const Color(0xFFE3F8E8),
        title: '已完成',
        subtitle: '提油订单已完成',
      );
    } else if (status == WithdrawStatus.cancelled.value) {
      return _HeaderConfig(
        icon: Icons.close,
        iconColor: const Color(0xFF9CA3AF),
        backgroundColor: const Color(0xFFF3F4F6),
        title: '已取消',
        subtitle: '提油订单已取消',
      );
    }

    return _HeaderConfig(
      icon: Icons.info_outline,
      iconColor: const Color(0xFF6B7280),
      backgroundColor: const Color(0xFFF3F4F6),
      title: '订单详情',
      subtitle: '查看订单信息',
    );
  }
}

class _HeaderConfig {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;
  final String subtitle;

  _HeaderConfig({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
  });
}
