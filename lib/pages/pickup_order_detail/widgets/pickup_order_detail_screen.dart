import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

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
        backgroundColor: CustomAppColor.of(context).bgScaffold,
        appBar: AppBar(
          backgroundColor: CustomAppColor.of(context).bgScaffold,
          elevation: 0,
          iconTheme: IconThemeData(
            color: CustomAppColor.of(context).txtBlack,
          ),
          title: CommonText(
            text: '提油订单详情',
            fontSize: AppSizes.setFontSize(18),
            fontWeight: FontWeight.w600,
            textColor: CustomAppColor.of(context).txtBlack,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: CommonText(
            text: '订单信息不存在',
            fontSize: AppSizes.setFontSize(14),
            textColor: CustomAppColor.of(context).txtGrey,
          ),
        ),
      );
    }

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
      backgroundColor: CustomAppColor.of(context).bgScaffold,
      appBar: AppBar(
        backgroundColor: CustomAppColor.of(context).bgScaffold,
        elevation: 0,
        iconTheme: IconThemeData(
          color: CustomAppColor.of(context).txtBlack,
        ),
        title: CommonText(
          text: '提油订单详情',
          fontSize: AppSizes.setFontSize(18),
          fontWeight: FontWeight.w600,
          textColor: CustomAppColor.of(context).txtBlack,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSizes.setHeight(32)),
              _buildPickupInfoCard(context),
              SizedBox(height: AppSizes.setHeight(16)),
              _buildStationInfoCard(context),
              if (vehicleModel != null) ...[
                SizedBox(height: AppSizes.setHeight(16)),
                _buildVehicleInfoCard(context, vehicleModel),
              ],
              SizedBox(height: AppSizes.setHeight(20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickupInfoCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.setWidth(16)),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
        border: Border.all(
          color: CustomAppColor.of(context).containerBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: '提油信息',
            fontSize: AppSizes.setFontSize(16),
            fontWeight: FontWeight.w700,
            textColor: CustomAppColor.of(context).txtBlack,
          ),
          SizedBox(height: AppSizes.setHeight(16)),
          if (order!.withdrawNo != null || order!.id != null)
            _buildInfoRow(
              context,
              '订单编号',
              order!.withdrawNo ?? order!.id!.toString(),
            ),
          if (order!.withdrawTon != null)
            _buildInfoRow(context, '提油量', '${order!.withdrawTon} 吨'),
          if (order!.status != null)
            _buildStatusRow(
              context,
              '状态',
              _getStatusText(order!.status!),
              order!.status!,
            ),
          if (order!.createdAt != null)
            _buildInfoRow(context, '创建时间', _formatDateTime(order!.createdAt!)),
          if (order!.updatedAt != null)
            _buildInfoRow(context, '更新时间', _formatDateTime(order!.updatedAt!)),
        ],
      ),
    );
  }

  Widget _buildStationInfoCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.setWidth(16)),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
        border: Border.all(
          color: CustomAppColor.of(context).containerBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: '加油站信息',
            fontSize: AppSizes.setFontSize(16),
            fontWeight: FontWeight.w700,
            textColor: CustomAppColor.of(context).txtBlack,
          ),
          SizedBox(height: AppSizes.setHeight(16)),
          _buildInfoRow(
            context,
            '加油站名称',
            order!.stationName ?? '未知油站',
          ),
          if (order!.stationId != null)
            _buildInfoRow(
              context,
              '加油站ID',
              order!.stationId!.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildVehicleInfoCard(BuildContext context, VehicleModel vehicleModel) {
    return Container(
      padding: EdgeInsets.all(AppSizes.setWidth(16)),
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
        border: Border.all(
          color: CustomAppColor.of(context).containerBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: '车辆及司机信息',
            fontSize: AppSizes.setFontSize(16),
            fontWeight: FontWeight.w700,
            textColor: CustomAppColor.of(context).txtBlack,
          ),
          SizedBox(height: AppSizes.setHeight(16)),
          if (vehicleModel.driverName != null && vehicleModel.driverName!.isNotEmpty)
            _buildInfoRow(context, '驾驶员姓名', vehicleModel.driverName!),
          if (vehicleModel.plateNumber != null && vehicleModel.plateNumber!.isNotEmpty)
            _buildInfoRow(context, '车号', vehicleModel.plateNumber!),
          if (vehicleModel.driverPhone != null && vehicleModel.driverPhone!.isNotEmpty)
            _buildInfoRow(context, '驾驶员电话', vehicleModel.driverPhone!),
          if (vehicleModel.driverIdCard != null && vehicleModel.driverIdCard!.isNotEmpty)
            _buildInfoRow(context, '身份证号', vehicleModel.driverIdCard!),
          if (vehicleModel.vehicleType != null && vehicleModel.vehicleType!.isNotEmpty)
            _buildInfoRow(context, '车型', vehicleModel.vehicleType!),
          if (vehicleModel.loadCapacity != null && vehicleModel.loadCapacity!.isNotEmpty)
            _buildInfoRow(context, '核定载重', vehicleModel.loadCapacity!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.setHeight(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSizes.setWidth(100),
            child: CommonText(
              text: '$label:',
              fontSize: AppSizes.setFontSize(14),
              textColor: CustomAppColor.of(context).txtGrey,
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: CommonText(
              text: value,
              fontSize: AppSizes.setFontSize(14),
              textColor: CustomAppColor.of(context).txtBlack,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context, String label, String value, String status) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.setHeight(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSizes.setWidth(100),
            child: CommonText(
              text: '$label:',
              fontSize: AppSizes.setFontSize(14),
              textColor: CustomAppColor.of(context).txtGrey,
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: CommonText(
              text: value,
              fontSize: AppSizes.setFontSize(14),
              textColor: _getStatusColor(context, status),
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    final withdrawStatus = WithdrawStatus.fromString(status);
    if (withdrawStatus != null) {
      return withdrawStatus.displayName;
    }
    switch (status) {
      case 'pending_pickup':
        return '待提油';
      case 'completed':
        return '已完成';
      default:
        return status;
    }
  }

  Color _getStatusColor(BuildContext context, String status) {
    switch (status) {
      case 'pending_pickup':
        return CustomAppColor.of(context).txtOrange;
      case 'completed':
        return CustomAppColor.of(context).green;
      default:
        return CustomAppColor.of(context).txtGrey;
    }
  }

  String _formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final year = dateTime.year;
      final month = dateTime.month.toString().padLeft(2, '0');
      final day = dateTime.day.toString().padLeft(2, '0');
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final second = dateTime.second.toString().padLeft(2, '0');
      return '$year-$month-$day $hour:$minute:$second';
    } catch (e) {
      return dateTimeStr;
    }
  }
}

