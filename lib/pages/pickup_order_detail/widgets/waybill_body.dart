import 'package:flutter/material.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/pickup_order_detail/widgets/detail_item.dart';
import 'package:oil_business_app/pages/pickup_order_detail/widgets/seal_stamp.dart';
import 'package:oil_business_app/pages/pickup_order_detail/widgets/vehicle_info_section.dart';
import 'package:oil_business_app/utils/date_util.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/common/dashed_line.dart';

/// 运单主体组件
///
/// 显示核心数据（提油量）、详细信息列表、车辆信息等
class WaybillBody extends StatelessWidget {
  final WithdrawOrderModel order;
  final VehicleModel? vehicleModel;
  final bool isCompleted;

  const WaybillBody({
    Key? key,
    required this.order,
    this.vehicleModel,
    required this.isCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final amount = order.withdrawTon ?? 0.0;
    final amountLabel = isCompleted ? '实际提油量 (吨)' : '核定提油量 (吨)';
    final amountColor =
        isCompleted ? const Color(0xFF10B981) : const Color(0xFF1F2937);

    return Container(
      padding: EdgeInsets.all(AppSizes.setWidth(20)),
      child: Stack(
        children: [
          // 已完成订单显示印章
          if (isCompleted) const SealStamp(),

          Column(
            children: [
              // 核心数据：提油量
              _buildCoreData(amountLabel, amount, amountColor),
              SizedBox(height: AppSizes.setHeight(8)),
              _buildDashedDivider(),
              SizedBox(height: AppSizes.setHeight(16)),

              // 详细信息列表
              _buildDetailList(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoreData(String label, double amount, Color amountColor) {
    return Column(
      children: [
        CommonText(
          text: label,
          fontSize: AppSizes.setFontSize(13),
          textColor: const Color(0xFF6B7280),
        ),
        SizedBox(height: AppSizes.setHeight(6)),
        CommonText(
          text: amount.toStringAsFixed(1),
          fontSize: AppSizes.setFontSize(40),
          fontWeight: FontWeight.w700,
          textColor: amountColor,
        ),
      ],
    );
  }

  Widget _buildDetailList(BuildContext context) {
    return Column(
      children: [
        DetailItem(
          label: '提油油库',
          value: order.depotName ?? '-',
        ),
        SizedBox(height: AppSizes.setHeight(16)),

        DetailItem(
          label: '加油站',
          value: order.stationName ?? '未知油站',
        ),
        SizedBox(height: AppSizes.setHeight(16)),

        _buildDashedDivider(),
        SizedBox(height: AppSizes.setHeight(16)),

        // 车辆信息区域
        if (vehicleModel != null) ...[
          VehicleInfoSection(vehicleModel: vehicleModel!),
          SizedBox(height: AppSizes.setHeight(16)),
          _buildDashedDivider(),
          SizedBox(height: AppSizes.setHeight(16)),
        ],

        // 已完成订单的额外信息
        if (isCompleted) ...[
          if (order.updatedAt != null && order.updatedAt!.isNotEmpty)
            DetailItem(
              label: '完成时间',
              value: _formatDateTime(order.updatedAt!),
              valueWidget: CommonText(
                text: _formatDateTime(order.updatedAt!),
                fontSize: AppSizes.setFontSize(14),
                fontWeight: FontWeight.w500,
                textColor: const Color(0xFF1F2937),
              ),
            ),
          if (order.updatedAt != null && order.updatedAt!.isNotEmpty)
            SizedBox(height: AppSizes.setHeight(16)),
          DetailItem(
            label: '实际提油量',
            value: '${order.withdrawTon ?? 0.0} 吨',
            valueWidget: CommonText(
              text: '${order.withdrawTon ?? 0.0} 吨',
              fontSize: AppSizes.setFontSize(14),
              fontWeight: FontWeight.w700,
              textColor: const Color(0xFF10B981),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDashedDivider() {
    return const DashedLine(
      color: Color(0xFFE5E7EB),
      strokeWidth: 1,
      dashWidth: 4,
      dashSpace: 4,
    );
  }

  String _formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      return formatDate(dateTime, format: 'yyyy-MM-dd HH:mm:ss');
    } catch (e) {
      return dateTimeStr;
    }
  }
}
