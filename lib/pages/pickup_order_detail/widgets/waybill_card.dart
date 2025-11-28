import 'package:flutter/material.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/pickup_order_detail/widgets/waybill_body.dart';
import 'package:oil_business_app/pages/pickup_order_detail/widgets/waybill_header.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';

/// 运单卡片组件
///
/// 组装运单的完整展示，包括顶部渐变条、头部和主体
class WaybillCard extends StatelessWidget {
  final WithdrawOrderModel order;
  final VehicleModel? vehicleModel;

  const WaybillCard({
    Key? key,
    required this.order,
    this.vehicleModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCompleted = order.status == WithdrawStatus.completed.value;
    final isCancelled = order.status == WithdrawStatus.cancelled.value;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTopGradientBar(isCompleted, isCancelled),
          WaybillHeader(
            status: order.status,
            orderNo: order.withdrawNo ?? order.id?.toString(),
          ),
          WaybillBody(
            order: order,
            vehicleModel: vehicleModel,
            isCompleted: isCompleted,
          ),
        ],
      ),
    );
  }

  Widget _buildTopGradientBar(bool isCompleted, bool isCancelled) {
    List<Color> gradientColors = [
      const Color(0xFF7165E3),
      const Color(0xFFA78BFA)
    ];

    if (isCompleted) {
      gradientColors = [const Color(0xFF10B981), const Color(0xFF34D399)];
    } else if (isCancelled) {
      gradientColors = [const Color(0xFF9CA3AF), const Color(0xFFD1D5DB)];
    }

    return Container(
      height: AppSizes.setHeight(6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.setWidth(12)),
          topRight: Radius.circular(AppSizes.setWidth(12)),
        ),
      ),
    );
  }
}
