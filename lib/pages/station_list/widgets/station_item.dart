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
    final colors = CustomAppColor.of(context);
    final primaryBg = const Color(0xFFF0EEFC);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSizes.setWidth(16)),
        decoration: BoxDecoration(
          color: isSelected ? primaryBg : colors.bgContainer,
          borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
          border: Border.all(
            color: isSelected ? colors.btnPurple : Colors.transparent,
            width: isSelected ? 1 : 0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.btnPurple.withValues(alpha: 0.1),
                    blurRadius: 12,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: const Color(0xFF000000).withValues(alpha: 0.02),
                    blurRadius: 6,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    text: station.displayName,
                    fontSize: AppSizes.setFontSize(16),
                    fontWeight: FontWeight.w600,
                    textColor: colors.txtBlack,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: AppSizes.setHeight(6)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: AppSizes.setFontSize(12),
                        color: colors.txtGrey.withValues(alpha: 0.7),
                      ),
                      SizedBox(width: AppSizes.setWidth(4)),
                      Expanded(
                        child: CommonText(
                          text: station.fullAddress,
                          fontSize: AppSizes.setFontSize(12),
                          textColor: colors.txtGrey,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSizes.setWidth(16)),
            Container(
              width: AppSizes.setWidth(22),
              height: AppSizes.setWidth(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? colors.btnPurple : Colors.white,
                border: Border.all(
                  color:
                      isSelected ? colors.btnPurple : const Color(0xFFD1D5DB),
                  width: 1,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: AppSizes.setFontSize(14),
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
