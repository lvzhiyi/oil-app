import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/models/vehicle_model.dart';
import 'package:oil_business_app/pages/pickup_order_list/controller.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/date_util.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';
import 'package:oil_business_app/widgets/popup/dialog.dart';

class PickupOrderListItem extends StatefulWidget {
  final WithdrawOrderModel item;

  const PickupOrderListItem({Key? key, required this.item}) : super(key: key);

  @override
  State<PickupOrderListItem> createState() => _PickupOrderListItemState();
}

class _PickupOrderListItemState extends State<PickupOrderListItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.item.status == WithdrawStatus.completed.value;
    final isPending = widget.item.status == WithdrawStatus.pendingPickup.value;
    final vehicle = _parseVehicleInfo(widget.item.vehicleInfo);
    
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.setHeight(12)),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapCancel: () => setState(() => _isPressed = false),
        onTapUp: (_) => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            decoration: BoxDecoration(
              color: _isPressed 
                  ? const Color(0xFFFAFAFA) 
                  : CustomAppColor.of(context).white,
              borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
              border: Border.all(
                color: _isPressed 
                    ? const Color(0xFF7165E3) 
                    : Colors.black.withValues(alpha: 0.02),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
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
                  _buildCardHeader(context, isCompleted),
                  SizedBox(height: AppSizes.setHeight(12)),
                  _buildCardBody(context, isCompleted),
                  SizedBox(height: AppSizes.setHeight(12)),
                  _buildCardFooter(context, vehicle, isCompleted),
                  SizedBox(height: AppSizes.setHeight(12)),
                  // const Divider(
                  //   height: 1,
                  //   thickness: 1,
                  //   color: Color(0xFFF3F4F6),
                  // ),
                  // SizedBox(height: AppSizes.setHeight(12)),
                  _buildActionButtons(context, isPending),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context, bool isCompleted) {
    final orderNo = widget.item.withdrawNo ?? widget.item.id?.toString() ?? '';
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              text: orderNo,
              fontSize: AppSizes.setFontSize(12),
              textColor: const Color(0xFF6B7280),
              fontFamily: 'DIN Alternate',
            ),
            _buildStatusBadge(isCompleted),
          ],
        ),
        SizedBox(height: AppSizes.setHeight(12)),
        Divider(
          height: 1,
          thickness: 1,
          color: const Color(0xFFF3F4F6),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool isCompleted) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(8),
        vertical: AppSizes.setHeight(2),
      ),
      decoration: BoxDecoration(
        color: isCompleted 
            ? const Color(0xFFECFDF5) 
            : const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(AppSizes.setWidth(4)),
      ),
      child: CommonText(
        text: isCompleted ? '已完成' : '待提油',
        fontSize: AppSizes.setFontSize(11),
        fontWeight: FontWeight.w600,
        textColor: isCompleted 
            ? const Color(0xFF10B981) 
            : const Color(0xFFF59E0B),
      ),
    );
  }

  Widget _buildCardBody(BuildContext context, bool isCompleted) {
    final amount = widget.item.withdrawTon ?? 0.0;
    final stationName = widget.item.stationName ?? '未知油站';
    final label = isCompleted ? '实提量' : '提油量';
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(
              text: label,
              fontSize: AppSizes.setFontSize(11),
              textColor: const Color(0xFF6B7280),
            ),
            SizedBox(height: AppSizes.setHeight(2)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CommonText(
                  text: amount.toStringAsFixed(1),
                  fontSize: AppSizes.setFontSize(24),
                  fontWeight: FontWeight.w700,
                  textColor: isCompleted 
                      ? const Color(0xFF10B981) 
                      : const Color(0xFF1F2937),
                  fontFamily: 'DIN Alternate',
                ),
                SizedBox(width: AppSizes.setWidth(2)),
                CommonText(
                  text: '吨',
                  fontSize: AppSizes.setFontSize(12),
                  fontWeight: FontWeight.w500,
                  textColor: isCompleted 
                      ? const Color(0xFF10B981) 
                      : const Color(0xFF1F2937),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CommonText(
                text: '加油站',
                fontSize: AppSizes.setFontSize(11),
                textColor: const Color(0xFF6B7280),
              ),
              SizedBox(height: AppSizes.setHeight(4)),
              CommonText(
                text: stationName,
                fontSize: AppSizes.setFontSize(15),
                fontWeight: FontWeight.w600,
                textColor: const Color(0xFF1F2937),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardFooter(
    BuildContext context,
    VehicleModel? vehicle,
    bool isCompleted,
  ) {
    final plateNumber = vehicle?.plateNumber ?? '';
    final driverName = vehicle?.driverName ?? '';
    final dateStr = _getDateString(
      isCompleted ? widget.item.updatedAt : widget.item.createdAt,
    );
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(10),
        vertical: AppSizes.setHeight(6),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(AppSizes.setWidth(6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (plateNumber.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.setWidth(4),
                    vertical: AppSizes.setHeight(1),
                  ),
                  decoration: BoxDecoration(
                    color: isCompleted 
                        ? const Color(0xFFF3F4F6) 
                        : const Color(0xFFEEECFC),
                    borderRadius: BorderRadius.circular(AppSizes.setWidth(3)),
                  ),
                  margin: EdgeInsets.only(right: AppSizes.setWidth(6)),
                  child: CommonText(
                    text: plateNumber,
                    fontSize: AppSizes.setFontSize(11),
                    fontWeight: FontWeight.w600,
                    textColor: isCompleted 
                        ? const Color(0xFF6B7280) 
                        : const Color(0xFF7165E3),
                  ),
                ),
              CommonText(
                text: driverName.isNotEmpty ? driverName : '--',
                fontSize: AppSizes.setFontSize(11),
                textColor: const Color(0xFF6B7280),
              ),
            ],
          ),
          CommonText(
            text: dateStr,
            fontSize: AppSizes.setFontSize(11),
            textColor: const Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isPending) {
    if (isPending) {
      // 待提油状态：显示两个按钮
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildCancelButton(context),
          SizedBox(width: AppSizes.setWidth(8)),
          _buildDetailButton(context),
        ],
      );
    } else {
      // 已完成状态：只显示查看详情按钮
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildDetailButton(context),
        ],
      );
    }
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: AppSizes.setWidth(90),
      child: OutlinedButton(
        onPressed: () => _handleCancel(context),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.setHeight(10),
          ),
          side: const BorderSide(color: Color(0xFFD1D5DB), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.setWidth(20)),
          ),
          backgroundColor: Colors.white,
        ),
        child: CommonText(
          text: '取消订单',
          fontSize: AppSizes.setFontSize(13),
          textColor: const Color(0xFF6B7280),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDetailButton(BuildContext context) {
    return SizedBox(
      width: AppSizes.setWidth(90),
      child: OutlinedButton(
        onPressed: () => _handleViewDetail(context),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.setHeight(10),
          ),
          side: const BorderSide(color: Color(0xFF7165E3), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.setWidth(20)),
          ),
          backgroundColor: Colors.white,
        ),
        child: CommonText(
          text: '查看详情',
          fontSize: AppSizes.setFontSize(13),
          textColor: const Color(0xFF7165E3),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _handleViewDetail(BuildContext context) {
    if (widget.item.withdrawId != null || widget.item.id != null) {
      BaseRouter.push(
        context: context,
        url: AppPage.pickupOrderDetailPage.path,
        extra: {
          'order': widget.item,
        },
      );
    } else {
      l.w('PickupOrderListItem', '订单ID为空，无法跳转到详情页');
      SportsToast.showError('订单信息异常，无法查看详情');
    }
  }

  void _handleCancel(BuildContext context) {
    if (widget.item.withdrawId == null) {
      SportsToast.showError('订单信息异常');
      return;
    }

    SportsDialog.show(
      title: '取消订单',
      bodyText: '确定要取消该提油订单吗？取消后无法恢复。',
      onCancel: () {},
      onOk: () async {
        await SportsDialog.dismiss();
        if (context.mounted) {
          final ctrl = context.read<PickupOrderListCtrl>();
          await ctrl.cancelOrder(widget.item.withdrawId!);
        }
      },
    );
  }

  VehicleModel? _parseVehicleInfo(String? vehicleInfoJson) {
    if (vehicleInfoJson == null || vehicleInfoJson.isEmpty) {
      return null;
    }

    try {
      final jsonMap = jsonDecode(vehicleInfoJson);
      return VehicleModel.fromJson(jsonMap);
    } catch (e) {
      return null;
    }
  }

  String _getDateString(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) {
      return '--';
    }
    try {
      return formatDate(DateTime.parse(dateTime), format: 'yyyy.MM.dd');
    } catch (e) {
      return '--';
    }
  }
}
