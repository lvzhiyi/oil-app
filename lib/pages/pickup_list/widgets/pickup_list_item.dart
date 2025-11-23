import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/date_util.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/container/common_container.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';

class PickupListItem extends StatelessWidget {
  final WithdrawOrderModel item;

  const PickupListItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.setHeight(12)),
      child: CustomContainer(
        width: double.infinity,
        height: AppSizes.setHeight(200), // 增加高度以适应解析后的车辆信息
        child: Padding(
          padding: EdgeInsets.all(AppSizes.setWidth(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText(
                    text: '单号: ${item.withdrawNo ?? item.id ?? ""}',
                    fontSize: AppSizes.setFontSize(14),
                    textColor: CustomAppColor.of(context).txtGrey,
                  ),
                  CommonText(
                    text: _getStatusText(item.status),
                    fontSize: AppSizes.setFontSize(14),
                    textColor: _getStatusColor(context, item.status),
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(height: AppSizes.setHeight(8)),
              Row(
                children: [
                  _buildInfoItem(context, '提油量', '${item.withdrawTon ?? 0}吨'),
                  SizedBox(width: AppSizes.setWidth(24)),
                  Expanded(
                    child: _buildInfoItem(context, '加油站', item.stationName ?? '未知油站'),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.setHeight(8)),
              _buildVehicleInfo(context, item.vehicleInfo),
              SizedBox(height: AppSizes.setHeight(8)),
              if(item.createdAt != null && item.createdAt!.isNotEmpty)
              CommonText(
                text: _getDateTimeString(item.createdAt, prefix: '申请时间'),
                fontSize: AppSizes.setFontSize(12),
                textColor: CustomAppColor.of(context).txtGrey,
              ),
              if(item.status == WithdrawStatus.completed.value && item.updatedAt != null && item.updatedAt!.isNotEmpty)
                CommonText(
                  text: _getDateTimeString(item.updatedAt, prefix: '完成时间'),
                  fontSize: AppSizes.setFontSize(12),
                  textColor: CustomAppColor.of(context).txtGrey,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDateTimeString(String? dateTime, { String prefix = '申请时间' }) {
    if(dateTime == null || dateTime.isEmpty) {
      return '$prefix: --';
    }
    return '$prefix: ${formatDate(DateTime.parse(dateTime), format: "yyyy.MM.dd HH:mm:ss")}';
  }

  Widget _buildVehicleInfo(BuildContext context, String? vehicleInfoJson) {
    if (vehicleInfoJson == null || vehicleInfoJson.isEmpty) {
      return _buildInfoRow(context, '车辆信息', '无');
    }

    try {
      final jsonMap = jsonDecode(vehicleInfoJson);
      final vehicle = VehicleModel.fromJson(jsonMap);
      
      final info = [
        if (vehicle.plateNumber != null) vehicle.plateNumber,
        if (vehicle.driverName != null) vehicle.driverName,
        if (vehicle.driverPhone != null) vehicle.driverPhone,
      ].join('  |  ');

      return _buildInfoRow(context, '车辆信息', info.isEmpty ? '无' : info);
    } catch (e) {
      return _buildInfoRow(context, '车辆信息', vehicleInfoJson);
    }
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: label,
          fontSize: AppSizes.setFontSize(12),
          textColor: CustomAppColor.of(context).txtGrey,
        ),
        SizedBox(height: AppSizes.setHeight(4)),
        CommonText(
          text: value,
          fontSize: AppSizes.setFontSize(14),
          textColor: CustomAppColor.of(context).txtBlack,
          maxLines: 2,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          text: label,
          fontSize: AppSizes.setFontSize(12),
          textColor: CustomAppColor.of(context).txtGrey,
        ),
        SizedBox(height: AppSizes.setHeight(4)),
        CommonText(
          text: value,
          fontSize: AppSizes.setFontSize(16),
          fontWeight: FontWeight.bold,
          textColor: CustomAppColor.of(context).txtBlack,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'pending_pickup':
        return '待提油';
      case 'completed':
        return '已完成';
      default:
        return status ?? '未知状态';
    }
  }

  Color _getStatusColor(BuildContext context, String? status) {
    switch (status) {
      case 'pending_pickup':
        return CustomAppColor.of(context).txtOrange;
      case 'completed':
        return CustomAppColor.of(context).green;
      default:
        return CustomAppColor.of(context).txtGrey;
    }
  }
}
