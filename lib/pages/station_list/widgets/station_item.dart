import 'package:flutter/material.dart';
import 'package:oil_business_app/models/station_model.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class StationItem extends StatelessWidget {
  final StationModel station;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const StationItem({
    Key? key,
    required this.station,
    required this.onTap,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSizes.setWidth(16)),
        decoration: BoxDecoration(
          color: CustomAppColor.of(context).bgContainer,
          borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
          border: Border.all(
            color: CustomAppColor.of(context).containerBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: station.name,
                    fontSize: AppSizes.setFontSize(16),
                    fontWeight: FontWeight.w600,
                    textColor: CustomAppColor.of(context).txtBlack,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: AppSizes.setHeight(8)),
                  CommonText(
                    text: station.address,
                    fontSize: AppSizes.setFontSize(14),
                    textColor: CustomAppColor.of(context).txtGrey,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSizes.setWidth(12)),
            GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.setWidth(12),
                  vertical: AppSizes.setHeight(6),
                ),
                decoration: BoxDecoration(
                  color: CustomAppColor.of(context).btnPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.setWidth(6)),
                ),
                child: CommonText(
                  text: '修改',
                  fontSize: AppSizes.setFontSize(12),
                  fontWeight: FontWeight.w500,
                  textColor: CustomAppColor.of(context).btnPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

