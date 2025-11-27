import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/pages/pickup_order_detail/controller.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/utils/date_util.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/common/dashed_line.dart';
import 'package:oil_business_app/widgets/popup/dialog.dart';

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
        String jsonStr = order!.vehicleInfo!;
        // 兼容新的格式：原始字符串|||JSON字符串
        if (jsonStr.contains('|||')) {
          final parts = jsonStr.split('|||');
          if (parts.length > 1) {
            jsonStr = parts[1];
          }
        }
        final jsonMap = jsonDecode(jsonStr);
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
              if (order!.status == WithdrawStatus.pendingPickup.value) ...[
                _buildCancelButton(context),
                SizedBox(height: AppSizes.setHeight(20)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _handleCancel(context),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.setHeight(12),
          ),
          side: const BorderSide(color: Color(0xFFEF4444)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.setWidth(24)),
          ),
          backgroundColor: Colors.white,
        ),
        child: CommonText(
          text: '取消订单',
          fontSize: AppSizes.setFontSize(15),
          textColor: const Color(0xFFEF4444),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _handleCancel(BuildContext context) {
    SportsDialog.show(
      title: '取消订单',
      bodyText: '确定要取消该提油订单吗？取消后无法恢复。',
      onCancel: () {},
      onOk: () async {
        await SportsDialog.dismiss();
        if (context.mounted) {
          final success =
              await context.read<PickupOrderDetailCtrl>().cancelOrder();
          if (success && context.mounted) {
            Navigator.pop(context, true);
          }
        }
      },
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
    final isCancelled = order!.status == WithdrawStatus.cancelled.value;
    List<Color> gradientColors = [const Color(0xFF7165E3), const Color(0xFFA78BFA)];
    
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
      ),
    );
  }

  Widget _buildWaybillHeader(BuildContext context, bool isCompleted) {
    final orderNo = order!.withdrawNo ?? order!.id?.toString() ?? '';
    final shortOrderNo = orderNo.length > 15
        ? '${orderNo.substring(0, 15)}...${orderNo.substring(orderNo.length - 5)}'
        : orderNo;

    final isCancelled = order!.status == WithdrawStatus.cancelled.value;
    
    String statusText = '待提油';
    Color statusColor = const Color(0xFFF59E0B);
    IconData statusIcon = Icons.access_time;

    if (isCompleted) {
      statusText = '已完成';
      statusColor = const Color(0xFF10B981);
      statusIcon = Icons.check_circle;
    } else if (isCancelled) {
      statusText = '已取消';
      statusColor = const Color(0xFF9CA3AF);
      statusIcon = Icons.cancel;
    }

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
                statusIcon,
                size: AppSizes.setFontSize(24),
                color: statusColor,
              ),
              SizedBox(width: AppSizes.setWidth(8)),
              CommonText(
                text: statusText,
                fontSize: AppSizes.setFontSize(20),
                fontWeight: FontWeight.w700,
                textColor: statusColor,
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
        _buildDetailItem(
          '提油油库',
          order!.inventoryId != null ? '库存ID: ${order!.inventoryId}' : '未知油库',
        ),
        SizedBox(height: AppSizes.setHeight(16)),
        _buildDashedDivider(),
        SizedBox(height: AppSizes.setHeight(16)),
        if (vehicleModel != null) ...[
          _buildVehicleInfoSection(vehicleModel),
          SizedBox(height: AppSizes.setHeight(16)),
          _buildDashedDivider(),
          SizedBox(height: AppSizes.setHeight(16)),
        ],
        if (isCompleted) ...[
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
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleInfoSection(VehicleModel vehicleModel) {
    final items = <Widget>[
      _buildSectionTitle('车辆及司机信息'),
    ];

    void addItem(String label, String? value, {Widget? valueWidget}) {
      if (value != null && value.trim().isNotEmpty) {
        items.add(_buildDetailItem(label, value, valueWidget: valueWidget));
        items.add(SizedBox(height: AppSizes.setHeight(12)));
      }
    }

    addItem(
      '车牌号',
      vehicleModel.plateNumber,
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
          text: vehicleModel.plateNumber ?? '',
          fontSize: AppSizes.setFontSize(14),
          fontWeight: FontWeight.w500,
          textColor: const Color(0xFF1D4ED8),
        ),
      ),
    );
    addItem('车型', vehicleModel.vehicleType);
    addItem('驾驶员', vehicleModel.driverName);
    addItem('联系电话', vehicleModel.driverPhone);
    addItem('身份证号', vehicleModel.driverIdCard);
    addItem('驾驶证编号', vehicleModel.driverLicense);
    addItem('行驶证编号', vehicleModel.vehicleLicense);
    addItem('核定载重', vehicleModel.loadCapacity);
    addItem('单双仓', vehicleModel.tankType);
    addItem('一仓(吨)', vehicleModel.tank1Capacity);
    addItem('二仓(吨)', vehicleModel.tank2Capacity);
    addItem('是否带泵', vehicleModel.hasPump);

    if (items.isNotEmpty && items.last is SizedBox) {
      items.removeLast();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.setHeight(8)),
      child: CommonText(
        text: title,
        fontSize: AppSizes.setFontSize(13),
        fontWeight: FontWeight.w700,
        textColor: const Color(0xFF6B7280),
        textAlign: TextAlign.left,
      ),
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
