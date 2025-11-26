import 'package:flutter/material.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/utils/station_extension.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/common/dashed_line.dart';

class StationManagementItem extends StatelessWidget {
  final Station station;
  final VoidCallback onEdit;

  const StationManagementItem({
    Key? key,
    required this.station,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = station.status;
    final isDisabled = status == StationStatus.disabled;
    final isRejected = status == StationStatus.rejected;
    final colors = CustomAppColor.of(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.setWidth(16)),
      decoration: BoxDecoration(
        color: colors.bgContainer,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.02),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CommonText(
                  text: station.displayName,
                  fontSize: AppSizes.setFontSize(16),
                  fontWeight: FontWeight.w700,
                  textColor: isDisabled ? colors.txtGrey : colors.txtBlack,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(width: AppSizes.setWidth(12)),
              _buildStatusTag(context, status),
            ],
          ),
          SizedBox(height: AppSizes.setHeight(12)),
          _buildAddressArea(context),
          if (isRejected && station.rejectionReason != null && station.rejectionReason!.isNotEmpty)
            _buildRejectReason(context),
          if (!isDisabled) _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildAddressArea(BuildContext context) {
    final colors = CustomAppColor.of(context);
    return Container(
      padding: EdgeInsets.all(AppSizes.setWidth(8)),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on,
            size: AppSizes.setFontSize(14),
            color: const Color(0xff6B7280),
          ),
          SizedBox(width: AppSizes.setWidth(6)),
          Expanded(
            child: CommonText(
              text: station.fullAddress,
              fontSize: AppSizes.setFontSize(13),
              textColor: colors.txtGrey,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(BuildContext context, StationStatus? status) {
    final colors = CustomAppColor.of(context);
    String label;
    Color bgColor;
    Color textColor;

    switch (status) {
      case StationStatus.active:
        label = '正常';
        bgColor = const Color(0xFFECFDF5);
        textColor = const Color(0xFF10B981);
        break;
      case StationStatus.pending_review:
        label = '待审核';
        bgColor = colors.btnPurple.withValues(alpha: 0.1);
        textColor = colors.btnPurple;
        break;
      case StationStatus.rejected:
        label = '已驳回';
        bgColor = const Color(0xFFFEF2F2);
        textColor = const Color(0xFFEF4444);
        break;
      case StationStatus.disabled:
        label = '禁用';
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF9CA3AF);
        break;
      default:
        label = '未知';
        bgColor = colors.containerBorder;
        textColor = colors.txtGrey;
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
        text: label,
        fontSize: AppSizes.setFontSize(11),
        fontWeight: FontWeight.w500,
        textColor: textColor,
      ),
    );
  }

  Widget _buildRejectReason(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: AppSizes.setHeight(12),
        bottom: AppSizes.setHeight(12),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(12),
        vertical: AppSizes.setHeight(10),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        border: Border.all(
          color: const Color(0xFFEF4444).withValues(alpha: 0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: AppSizes.setFontSize(16),
            color: const Color(0xFFEF4444),
          ),
          SizedBox(width: AppSizes.setWidth(8)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  text: '审核不通过原因：',
                  fontSize: AppSizes.setFontSize(12),
                  fontWeight: FontWeight.w700,
                  textColor: const Color(0xFFEF4444),
                ),
                SizedBox(height: AppSizes.setHeight(2)),
                CommonText(
                  text: station.rejectionReason ?? '',
                  fontSize: AppSizes.setFontSize(12),
                  textColor: const Color(0xFFEF4444).withValues(alpha: 0.9),
                  maxLines: null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final colors = CustomAppColor.of(context);
    final isRejected = station.status == StationStatus.rejected;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: AppSizes.setHeight(12)),
          child: DashedLine(
            color: colors.containerBorder,
            strokeWidth: 1,
            dashWidth: 4,
            dashSpace: 4,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: AppSizes.setHeight(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isRejected)
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.setWidth(16),
                      vertical: AppSizes.setHeight(6),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF),
                      border: Border.all(
                        color: colors.btnPurple,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.setWidth(16)),
                    ),
                    child: CommonText(
                      text: '去修改并重新提交',
                      fontSize: AppSizes.setFontSize(13),
                      fontWeight: FontWeight.w500,
                      textColor: colors.btnPurple,
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.setWidth(16),
                      vertical: AppSizes.setHeight(6),
                    ),
                    decoration: BoxDecoration(
                      color: colors.bgContainer,
                      border: Border.all(
                        color: colors.containerBorder,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.setWidth(16)),
                    ),
                    child: CommonText(
                      text: '修改信息',
                      fontSize: AppSizes.setFontSize(13),
                      textColor: colors.txtBlack,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
