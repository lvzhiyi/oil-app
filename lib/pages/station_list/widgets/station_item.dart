import 'package:flutter/material.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/utils/station_extension.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class StationItem extends StatelessWidget {
  final Station station;
  final VoidCallback onTap;
  final bool isSelected;

  const StationItem({
    Key? key,
    required this.station,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSizes.setWidth(16)),
        decoration: BoxDecoration(
          color: isSelected
              ? CustomAppColor.of(context).btnPurple.withValues(alpha: 0.05)
              : CustomAppColor.of(context).bgContainer,
          borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
          border: Border.all(
            color: isSelected
                ? CustomAppColor.of(context).btnPurple
                : CustomAppColor.of(context).containerBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (isSelected) ...[
              Icon(
                Icons.check_circle,
                color: CustomAppColor.of(context).btnPurple,
                size: AppSizes.setWidth(20),
              ),
              SizedBox(width: AppSizes.setWidth(12)),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: station.displayName,
                    fontSize: AppSizes.setFontSize(16),
                    fontWeight: FontWeight.w600,
                    textColor: isSelected
                        ? CustomAppColor.of(context).btnPurple
                        : CustomAppColor.of(context).txtBlack,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: AppSizes.setHeight(8)),
                  CommonText(
                    text: station.fullAddress,
                    fontSize: AppSizes.setFontSize(14),
                    textColor: CustomAppColor.of(context).txtGrey,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

