import 'package:flutter/material.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/pages/oil_pickup/model/withdraw_data.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/constant.dart';
import 'package:oil_business_app/utils/fuel_type_helper.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/utils/station_extension.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/common/dashed_line.dart';

class OilPickupReceiptCard extends StatelessWidget {
  final WithdrawResponse response;
  final InventoryModel inventory;
  final Station station;
  final String oilAmount;
  final String dispatchContent;
  final ValueChanged<String> onCopyWithdrawNo;

  const OilPickupReceiptCard({
    Key? key,
    required this.response,
    required this.inventory,
    required this.station,
    required this.oilAmount,
    required this.dispatchContent,
    required this.onCopyWithdrawNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String statusLabel = response.status != null
        ? (WithdrawStatus.fromString(response.status)?.displayName ?? response.status!)
        : '待提油';
    final String withdrawNo = response.withdrawNo ?? response.withdrawId?.toString() ?? '--';
    final String productName = inventory.fuelType != null
        ? FuelTypeHelper.getDisplayName(inventory.fuelType)
        : '油品';
    final String formattedAmount = _formatOilAmount(oilAmount);
    final String depotName = inventory.depotName?.trim().isNotEmpty == true
        ? inventory.depotName!
        : '--';
    final String stationName = station.displayName.isNotEmpty ? station.displayName : '--';

    return Container(
      decoration: BoxDecoration(
        color: CustomAppColor.of(context).white,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStripeBar(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.setHeight(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader(context, statusLabel),
                SizedBox(height: AppSizes.setHeight(18)),
                _buildDashedDivider(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(18)),
                  child: Column(
                    children: [
                      SizedBox(height: AppSizes.setHeight(16)),
                      _buildWithdrawNo(context, withdrawNo),
                      SizedBox(height: AppSizes.setHeight(4)),
                      _buildAmountPanel(context, productName, formattedAmount),
                      SizedBox(height: AppSizes.setHeight(18)),
                      _buildLocationRow(context, depotName, stationName),
                      SizedBox(height: AppSizes.setHeight(18)),
                      _buildDispatchDetail(context, dispatchContent),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStripeBar() {
    return Container(
      height: AppSizes.setHeight(10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.repeated,
          colors: [
            Color(0xFF7C75F5),
            Color(0xFF7C75F5),
            Color(0xFF9D90F6),
            Color(0xFF9D90F6),
          ],
          stops: [0.0, 0.25, 0.25, 0.5],
          transform: GradientRotation(0.785398),
        ),
      ),
    );
  }

  Widget _buildCardHeader(BuildContext context, String statusLabel) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(14)),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                Icons.water_drop_outlined,
                size: AppSizes.setWidth(18),
                color: CustomAppColor.of(context).txtPurple,
              ),
              SizedBox(width: AppSizes.setWidth(6)),
              CommonText(
                text: '买油呗提油单',
                fontSize: AppSizes.setFontSize(15),
                fontWeight: FontWeight.w700,
                textColor: CustomAppColor.of(context).txtBlack,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          const Spacer(),
          _buildStatusTag(context, statusLabel),
        ],
      ),
    );
  }

  Widget _buildStatusTag(BuildContext context, String statusLabel) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(10),
        vertical: AppSizes.setHeight(4),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.setWidth(5)),
        border: Border.all(
          color: CustomAppColor.of(context).btnPurple,
          width: AppSizes.setWidth(1),
        ),
      ),
      child: CommonText(
        text: statusLabel,
        fontSize: AppSizes.setFontSize(12),
        fontWeight: FontWeight.w600,
        textColor: CustomAppColor.of(context).txtPurple,
      ),
    );
  }

  Widget _buildWithdrawNo(BuildContext context, String withdrawNo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '提油单号 / NO.',
          style: TextStyle(
            fontSize: AppSizes.setFontSize(12),
            fontWeight: FontWeight.w500,
            color: const Color(0xff6B7280),
            height: 1,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                withdrawNo,
                style: TextStyle(
                  fontSize: AppSizes.setFontSize(16),
                  color: CustomAppColor.of(context).txtBlack,
                  height: 1,
                ),
              ),
            ),
            IconButton(
              onPressed: () => onCopyWithdrawNo(withdrawNo),
              icon: Icon(
                Icons.copy_outlined,
                size: AppSizes.setWidth(18),
                color: CustomAppColor.of(context).txtPurple,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: AppSizes.setWidth(18),
              tooltip: '复制提油单号',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountPanel(
    BuildContext context,
    String productName,
    String formattedAmount,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(14),
        vertical: AppSizes.setHeight(12),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FC),
        borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: '油品类型',
                  fontSize: AppSizes.setFontSize(12),
                  fontWeight: FontWeight.w500,
                  textColor: const Color(0xff6B7280),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: AppSizes.setHeight(6)),
                Text(
                  productName,
                  style: TextStyle(
                    fontSize: AppSizes.setFontSize(18),
                    fontWeight: FontWeight.w500,
                    color: CustomAppColor.of(context).txtBlack,
                    fontFamily: Constant.fontFamilyUrbanist,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSizes.setWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CommonText(
                  text: '提油量',
                  fontSize: AppSizes.setFontSize(12),
                  fontWeight: FontWeight.w500,
                  textColor: const Color(0xff6B7280),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: AppSizes.setHeight(4)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      formattedAmount,
                      style: TextStyle(
                        fontSize: AppSizes.setFontSize(28),
                        fontWeight: FontWeight.w600,
                        color: CustomAppColor.of(context).txtPurple,
                        fontFamily: Constant.fontFamilyUrbanist,
                        height: 1,
                      ),
                    ),
                    SizedBox(width: AppSizes.setWidth(4)),
                    Padding(
                      padding: EdgeInsets.only(top: AppSizes.setHeight(2)),
                      child: CommonText(
                        text: '吨',
                        fontSize: AppSizes.setFontSize(14),
                        fontWeight: FontWeight.w600,
                        textColor: CustomAppColor.of(context).txtBlack,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(
    BuildContext context,
    String depotName,
    String stationName,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildLocationItem(
            context,
            label: '油库',
            value: depotName,
          ),
        ),
        Expanded(
          child: _buildLocationItem(
            context,
            label: '加油站',
            value: stationName,
            emphasize: true,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationItem(
    BuildContext context, {
    required String label,
    required String value,
    bool emphasize = false,
  }) {
    return Column(
      crossAxisAlignment: emphasize ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: emphasize ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Expanded(
              child: CommonText(
                text: value,
                fontSize: AppSizes.setFontSize(14),
                fontWeight: FontWeight.w700,
                textColor: CustomAppColor.of(context).txtBlack,
                textAlign: emphasize ? TextAlign.right : TextAlign.left,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.setHeight(6)),
        CommonText(
          text: label,
          fontSize: AppSizes.setFontSize(12),
          fontWeight: FontWeight.w500,
          textColor: const Color(0xff6B7280),
          textAlign: emphasize ? TextAlign.right : TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildDispatchDetail(BuildContext context, String dispatchDetail) {
    final List<String> lines = dispatchDetail.replaceAll('\r\n', '\n').split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.article_outlined,
              size: AppSizes.setWidth(16),
              color: CustomAppColor.of(context).txtGrey,
            ),
            SizedBox(width: AppSizes.setWidth(6)),
            CommonText(
              text: '调度明细',
              fontSize: AppSizes.setFontSize(13),
              fontWeight: FontWeight.w700,
              textColor: CustomAppColor.of(context).txtBlack,
              textAlign: TextAlign.left,
            ),
          ],
        ),
        SizedBox(height: AppSizes.setHeight(8)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSizes.setWidth(12)),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FC),
            borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
            border: Border.all(color: CustomAppColor.of(context).containerBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lines
                .map(
                  (line) => SelectableText(
                    line.isEmpty ? ' ' : line,
                    style: TextStyle(
                      fontSize: AppSizes.setFontSize(13),
                      color: CustomAppColor.of(context).txtBlack,
                      height: 1.5,
                    ),
                  ),
                )
                .toList(),
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

  String _formatOilAmount(String rawAmount) {
    final double? parsed = double.tryParse(rawAmount);
    if (parsed == null) return rawAmount;
    if (parsed % 1 == 0) {
      return parsed.toStringAsFixed(1);
    }
    return parsed.toStringAsFixed(2);
  }
}
