import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/utils/date_util.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/common/dashed_line.dart';

class PickupOrderDetailScreen extends StatelessWidget {
  final WithdrawOrderModel? order;

  const PickupOrderDetailScreen({
    Key? key,
    this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (order == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
          title: CommonText(
            text: '订单详情',
            fontSize: AppSizes.setFontSize(17),
            fontWeight: FontWeight.w600,
            textColor: const Color(0xFF1F2937),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: CommonText(
            text: '订单信息不存在',
            fontSize: AppSizes.setFontSize(14),
            textColor: const Color(0xFF6B7280),
          ),
        ),
      );
    }

    final isCompleted = order!.status == WithdrawStatus.completed.value;
    VehicleModel? vehicleModel;
    if (order!.vehicleInfo != null && order!.vehicleInfo!.isNotEmpty) {
      try {
        final jsonMap = jsonDecode(order!.vehicleInfo!);
        vehicleModel = VehicleModel.fromJson(jsonMap);
      } catch (e) {
        // 解析失败，vehicleModel 保持为 null
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
        title: CommonText(
          text: '订单详情',
          fontSize: AppSizes.setFontSize(17),
          fontWeight: FontWeight.w600,
          textColor: const Color(0xFF1F2937),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: true,
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(20)),
          child: Column(
            children: [
              SizedBox(height: AppSizes.setHeight(20)),
              _buildWaybillCard(context, isCompleted, vehicleModel),
              SizedBox(height: AppSizes.setHeight(30)),
              // _buildContactButton(context),
              // SizedBox(height: AppSizes.setHeight(20)),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildWaybillCard(
    BuildContext context,
    bool isCompleted,
    VehicleModel? vehicleModel,
  ) {
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
          _buildTopGradientBar(isCompleted),
          _buildWaybillHeader(context, isCompleted),
          _buildWaybillBody(context, isCompleted, vehicleModel),
        ],
      ),
    );
  }

  Widget _buildTopGradientBar(bool isCompleted) {
    return Container(
      height: AppSizes.setHeight(6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCompleted
              ? [const Color(0xFF10B981), const Color(0xFF34D399)]
              : [const Color(0xFF7165E3), const Color(0xFFA78BFA)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  Widget _buildWaybillHeader(BuildContext context, bool isCompleted) {
    final orderNo = order!.withdrawNo ?? order!.id?.toString() ?? '';
    final shortOrderNo = orderNo.length > 15 
        ? '${orderNo.substring(0, 15)}...${orderNo.substring(orderNo.length - 5)}'
        : orderNo;

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
                isCompleted ? Icons.check_circle : Icons.access_time,
                size: AppSizes.setFontSize(24),
                color: isCompleted 
                    ? const Color(0xFF10B981) 
                    : const Color(0xFFF59E0B),
              ),
              SizedBox(width: AppSizes.setWidth(8)),
              CommonText(
                text: isCompleted ? '已完成' : '待提油',
                fontSize: AppSizes.setFontSize(20),
                fontWeight: FontWeight.w700,
                textColor: isCompleted 
                    ? const Color(0xFF10B981) 
                    : const Color(0xFFF59E0B),
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

  Widget _buildWaybillBody(
    BuildContext context,
    bool isCompleted,
    VehicleModel? vehicleModel,
  ) {
    final amount = order!.withdrawTon ?? 0.0;
    final amountLabel = isCompleted ? '实际提油量 (吨)' : '核定提油量 (吨)';
    final amountColor = isCompleted ? const Color(0xFF10B981) : const Color(0xFF1F2937);

    return Container(
      padding: EdgeInsets.all(AppSizes.setWidth(20)),
      child: Stack(
        children: [
          if (isCompleted) _buildSealStamp(),
          Column(
            children: [
              _buildCoreData(amountLabel, amount, amountColor),
              SizedBox(height: AppSizes.setHeight(8)),
              _buildDashedDivider(),
              SizedBox(height: AppSizes.setHeight(16)),
              _buildDetailList(context, vehicleModel, isCompleted),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSealStamp() {
    return Positioned(
      right: AppSizes.setWidth(5),
      top: AppSizes.setHeight(10),
      child: Transform.rotate(
        angle: -0.35,
        child: Container(
          width: AppSizes.setWidth(100),
          height: AppSizes.setWidth(100),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                blurRadius: 0,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Container(
            margin: EdgeInsets.all(AppSizes.setWidth(6)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonText(
                    text: '提油业务',
                    fontSize: AppSizes.setFontSize(14),
                    fontWeight: FontWeight.w700,
                    textColor: const Color(0xFF10B981).withValues(alpha: 0.15),
                  ),
                  CommonText(
                    text: '已完成',
                    fontSize: AppSizes.setFontSize(14),
                    fontWeight: FontWeight.w700,
                    textColor: const Color(0xFF10B981).withValues(alpha: 0.15),
                  ),
                ],
              ),
            ),
          ),
        ),
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

  Widget _buildDetailList(
    BuildContext context,
    VehicleModel? vehicleModel,
    bool isCompleted,
  ) {
    return Column(
      children: [
        _buildDetailItem('加油站', order!.stationName ?? '未知油站'),
        SizedBox(height: AppSizes.setHeight(16)),
        _buildDetailItem('提油油库', '大中华区1号油库'),
        SizedBox(height: AppSizes.setHeight(16)),
        _buildDashedDivider(),
        SizedBox(height: AppSizes.setHeight(16)),
        if (vehicleModel?.plateNumber != null && vehicleModel!.plateNumber!.isNotEmpty)
          _buildDetailItem(
            '车牌号',
            vehicleModel.plateNumber!,
            valueWidget: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.setWidth(4),
                vertical: AppSizes.setHeight(2),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(AppSizes.setWidth(4)),
              ),
              child: CommonText(
                text: vehicleModel.plateNumber!,
                fontSize: AppSizes.setFontSize(14),
                fontWeight: FontWeight.w500,
                textColor: const Color(0xFF1D4ED8),
              ),
            ),
          ),
        if (vehicleModel?.plateNumber != null && vehicleModel!.plateNumber!.isNotEmpty)
          SizedBox(height: AppSizes.setHeight(16)),
        if (vehicleModel?.driverName != null && vehicleModel!.driverName!.isNotEmpty)
          _buildDetailItem('驾驶员', vehicleModel.driverName!),
        if (vehicleModel?.driverName != null && vehicleModel!.driverName!.isNotEmpty)
          SizedBox(height: AppSizes.setHeight(16)),
        if (vehicleModel?.driverPhone != null && vehicleModel!.driverPhone!.isNotEmpty)
          _buildDetailItem(
            '联系电话',
            vehicleModel.driverPhone!,
            valueWidget: CommonText(
              text: vehicleModel.driverPhone!,
              fontSize: AppSizes.setFontSize(14),
              fontWeight: FontWeight.w500,
              textColor: const Color(0xFF1F2937),
            ),
          ),
        if (isCompleted) ...[
          if (vehicleModel?.driverPhone != null && vehicleModel!.driverPhone!.isNotEmpty)
            SizedBox(height: AppSizes.setHeight(16)),
          _buildDashedDivider(),
          SizedBox(height: AppSizes.setHeight(16)),
          if (order!.updatedAt != null && order!.updatedAt!.isNotEmpty)
            _buildDetailItem(
              '完成时间',
              _formatDateTime(order!.updatedAt!),
              valueWidget: CommonText(
                text: _formatDateTime(order!.updatedAt!),
                fontSize: AppSizes.setFontSize(14),
                fontWeight: FontWeight.w500,
                textColor: const Color(0xFF1F2937),
              ),
            ),
          if (order!.updatedAt != null && order!.updatedAt!.isNotEmpty)
            SizedBox(height: AppSizes.setHeight(16)),
          _buildDetailItem(
            '实际提油量',
            '${order!.withdrawTon ?? 0.0} 吨',
            valueWidget: CommonText(
              text: '${order!.withdrawTon ?? 0.0} 吨',
              fontSize: AppSizes.setFontSize(14),
              fontWeight: FontWeight.w700,
              textColor: const Color(0xFF10B981),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailItem(
    String label,
    String value, {
    Widget? valueWidget,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: label,
          fontSize: AppSizes.setFontSize(14),
          textColor: const Color(0xFF6B7280),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: valueWidget ??
                CommonText(
                  text: value,
                  fontSize: AppSizes.setFontSize(14),
                  fontWeight: FontWeight.w500,
                  textColor: const Color(0xFF1F2937),
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        ),
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

  Widget _buildContactButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          // TODO: 实现联系调度员功能
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.setHeight(8),
            horizontal: AppSizes.setWidth(24),
          ),
          side: const BorderSide(color: Color(0xFF7165E3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.setWidth(20)),
          ),
        ),
        child: CommonText(
          text: '联系调度员',
          fontSize: AppSizes.setFontSize(14),
          textColor: const Color(0xFF7165E3),
        ),
      ),
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
