import 'package:flutter/material.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/utils/station_extension.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

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
      padding: EdgeInsets.all(AppSizes.setWidth(20)),
      decoration: BoxDecoration(
        color: isDisabled ? colors.bgTopBar : colors.bgContainer,
        borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
        border: Border.all(
          color: colors.containerBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
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
                child: Row(
                  children: [
                    Flexible(
                      child: CommonText(
                        text: station.displayName,
                        fontSize: AppSizes.setFontSize(18),
                        fontWeight: FontWeight.bold,
                        textColor: isDisabled ? colors.txtGrey : colors.txtBlack,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: AppSizes.setWidth(8)),
                    _buildStatusTag(context, status),
                  ],
                ),
              ),
              if (!isDisabled) _buildEditButton(context),
            ],
          ),
          SizedBox(height: AppSizes.setHeight(12)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                size: AppSizes.setFontSize(16),
                color: colors.icGrey,
              ),
              SizedBox(width: AppSizes.setWidth(8)),
              Expanded(
                child: CommonText(
                  text: station.fullAddress,
                  fontSize: AppSizes.setFontSize(14),
                  textColor: colors.txtGrey,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          if (isRejected && station.rejectionReason != null && station.rejectionReason!.isNotEmpty)
            _buildRejectReason(context),
        ],
      ),
    );
  }

  Widget _buildStatusTag(BuildContext context, StationStatus? status) {
    final colors = CustomAppColor.of(context);
    String label;
    Color bgColor;
    Color textColor;
    Color borderColor;

    switch (status) {
      case StationStatus.active:
        label = '正常';
        bgColor = AppColor.containerGreen;
        textColor = AppColor.green;
        borderColor = AppColor.green.withValues(alpha: 0.3);
        break;
      case StationStatus.pending_review:
        label = '待审核';
        bgColor = colors.btnPurple.withValues(alpha: 0.1);
        textColor = colors.btnPurple;
        borderColor = colors.btnPurple.withValues(alpha: 0.3);
        break;
      case StationStatus.rejected:
        label = '已驳回';
        bgColor = AppColor.containerRed.withValues(alpha: 0.1);
        textColor = AppColor.txtRed;
        borderColor = AppColor.txtRed.withValues(alpha: 0.3);
        break;
      case StationStatus.disabled:
        label = '禁用';
        bgColor = colors.containerBorder;
        textColor = colors.txtGrey;
        borderColor = colors.containerBorder;
        break;
      default:
        label = '未知';
        bgColor = colors.containerBorder;
        textColor = colors.txtGrey;
        borderColor = colors.containerBorder;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.setWidth(6),
        vertical: AppSizes.setHeight(2),
      ),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppSizes.setWidth(4)),
      ),
      child: CommonText(
        text: label,
        fontSize: AppSizes.setFontSize(10),
        fontWeight: FontWeight.w500,
        textColor: textColor,
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    final colors = CustomAppColor.of(context);
    return GestureDetector(
      onTap: onEdit,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.setWidth(8),
          vertical: AppSizes.setHeight(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.edit_outlined,
              size: AppSizes.setFontSize(14),
              color: colors.txtGrey,
            ),
            SizedBox(width: AppSizes.setWidth(4)),
            CommonText(
              text: '修改',
              fontSize: AppSizes.setFontSize(12),
              textColor: colors.txtGrey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRejectReason(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppSizes.setHeight(12)),
      padding: EdgeInsets.all(AppSizes.setWidth(10)),
      decoration: BoxDecoration(
        color: AppColor.containerRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: AppSizes.setFontSize(12),
            color: AppColor.txtRed,
          ),
          SizedBox(width: AppSizes.setWidth(8)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: AppSizes.setFontSize(12),
                  color: AppColor.txtRed,
                  height: 1.4,
                ),
                children: [
                  const TextSpan(
                    text: '驳回原因：',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: station.rejectionReason ?? '',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
