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
    final isCancelled = widget.item.status == WithdrawStatus.cancelled.value;
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
                  _buildCardHeader(context, isCompleted, isCancelled),
                  SizedBox(height: AppSizes.setHeight(12)),
                  _buildCardBody(context, isCompleted, isCancelled),
                  SizedBox(height: AppSizes.setHeight(12)),
                  _buildCardFooter(context, vehicle, isCompleted, isCancelled),
                  SizedBox(height: AppSizes.setHeight(12)),
                  // const Divider(
                  //   height: 1,
                  //   thickness: 1,
                  //   color: Color(0xFFF3F4F6),
                  // ),
                  // SizedBox(height: AppSizes.setHeight(12)),
                  _buildActionButtons(context, isPending, isCancelled),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(
      BuildContext context, bool isCompleted, bool isCancelled) {
    final orderNo = widget.item.withdrawNo ?? '';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(
              text: orderNo,
              fontSize: AppSizes.setFontSize(12),
              textColor: const Color(0xFF6B7280),
            ),
            _buildStatusBadge(isCompleted, isCancelled),
          ],
        ),
        SizedBox(height: AppSizes.setHeight(12)),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFF3F4F6),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool isCompleted, bool isCancelled) {
    String text;
    Color bgColor;
    Color textColor;

    if (isCancelled) {
      text = '已取消';
      bgColor = const Color(0xFFFEF2F2);
      textColor = const Color(0xFFEF4444);
    } else if (isCompleted) {
      text = '已完成';
      bgColor = const Color(0xFFECFDF5);
      textColor = const Color(0xFF10B981);
    } else {
      text = '待提油';
      bgColor = const Color(0xFFFFF7ED);
      textColor = const Color(0xFFF59E0B);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(8),
        vertical: AppSizes.setHeight(2),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(4)),
      ),
      child: CommonText(
        text: text,
        fontSize: AppSizes.setFontSize(11),
        fontWeight: FontWeight.w600,
        textColor: textColor,
      ),
    );
  }

  Widget _buildCardBody(
      BuildContext context, bool isCompleted, bool isCancelled) {
    final amount = widget.item.withdrawTon ?? 0.0;
    final stationName = widget.item.station?.stationName ?? '未知油站';
    final label = isCompleted ? '实提量' : '提油量';

    Color amountColor;
    if (isCancelled) {
      amountColor = const Color(0xFF9CA3AF);
    } else if (isCompleted) {
      amountColor = const Color(0xFF10B981);
    } else {
      amountColor = const Color(0xFF1F2937);
    }

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
              children: [
                CommonText(
                  text: amount.toStringAsFixed(2),
                  fontSize: AppSizes.setFontSize(24),
                  fontWeight: FontWeight.w700,
                  textColor: amountColor,
                  fontFamily: 'DIN Alternate',
                ),
                SizedBox(width: AppSizes.setWidth(2)),
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    top: AppSizes.setHeight(4),
                  ),
                  child: CommonText(
                    text: '吨',
                    fontSize: AppSizes.setFontSize(12),
                    fontWeight: FontWeight.w500,
                    textColor: amountColor,
                  ),
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
                textColor: isCancelled
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF1F2937),
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
    bool isCancelled,
  ) {
    final plateNumber = vehicle?.plateNumber ?? '';
    final driverName = vehicle?.driverName ?? '';
    final dateStr = _getDateString(
      isCompleted ? widget.item.updatedAt : widget.item.createdAt,
    );

    Color plateNumberBgColor;
    Color plateNumberTextColor;

    if (isCancelled) {
      plateNumberBgColor = const Color(0xFFF3F4F6);
      plateNumberTextColor = const Color(0xFF9CA3AF);
    } else if (isCompleted) {
      plateNumberBgColor = const Color(0xFFF3F4F6);
      plateNumberTextColor = const Color(0xFF6B7280);
    } else {
      plateNumberBgColor = const Color(0xFFEEECFC);
      plateNumberTextColor = const Color(0xFF7165E3);
    }

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
                    color: plateNumberBgColor,
                    borderRadius: BorderRadius.circular(AppSizes.setWidth(3)),
                  ),
                  margin: EdgeInsets.only(right: AppSizes.setWidth(6)),
                  child: CommonText(
                    text: plateNumber,
                    fontSize: AppSizes.setFontSize(11),
                    fontWeight: FontWeight.w600,
                    textColor: plateNumberTextColor,
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

  Widget _buildActionButtons(
      BuildContext context, bool isPending, bool isCancelled) {
    if (isPending) {
      // 待提油状态：显示取消订单和查看详情按钮
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildCancelButton(context),
          SizedBox(width: AppSizes.setWidth(8)),
          _buildDetailButton(context),
        ],
      );
    } else {
      // 已完成或已取消状态：只显示查看详情按钮
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

  Future<void> _handleViewDetail(BuildContext context) async {
    if (widget.item.withdrawId != null) {
      final result = await BaseRouter.push(
        context: context,
        url: AppPage.pickupOrderDetailPage.path,
        extra: {
          'withdrawId': widget.item.withdrawId,
        },
      );
      if (context.mounted &&
          result is Map &&
          result['refresh'] == true) {
        final ctrl = context.read<PickupOrderListCtrl>();
        await ctrl.onRefresh();
      }
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
      String jsonStr = vehicleInfoJson;
      // 兼容新的格式：原始字符串|||JSON字符串
      if (vehicleInfoJson.contains('|||')) {
        final parts = vehicleInfoJson.split('|||');
        if (parts.length > 1) {
          jsonStr = parts[1];
        }
      }

      final jsonMap = jsonDecode(jsonStr);
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
