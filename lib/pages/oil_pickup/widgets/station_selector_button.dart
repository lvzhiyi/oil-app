import 'package:flutter/material.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/utils/station_extension.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class StationSelectorButton extends StatelessWidget {
  final Station? station;
  final VoidCallback onTap;

  const StationSelectorButton({
    Key? key,
    this.station,
    required this.onTap,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.local_gas_station,
              color: CustomAppColor.of(context).btnPurple,
              size: AppSizes.setWidth(24),
            ),
            SizedBox(width: AppSizes.setWidth(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonText(
                    text: station?.displayName ?? '选择加油站',
                    fontSize: AppSizes.setFontSize(16),
                    fontWeight: FontWeight.w600,
                    textColor: station != null
                        ? CustomAppColor.of(context).txtBlack
                        : CustomAppColor.of(context).txtGrey,
                    textAlign: TextAlign.left,
                  ),
                  if (station != null) ...[
                    SizedBox(height: AppSizes.setHeight(4)),
                    CommonText(
                      text: station!.fullAddress,
                      fontSize: AppSizes.setFontSize(14),
                      textColor: CustomAppColor.of(context).txtGrey,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: AppSizes.setWidth(6)),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CommonText(
                  text: station != null ? '切换' : '选择',
                  fontSize: AppSizes.setFontSize(14),
                  fontWeight: FontWeight.w500,
                  textColor: CustomAppColor.of(context).btnPurple,
                ),
                Padding(
                  padding: EdgeInsets.only(top: AppSizes.setHeight(3)),
                  child: Image.asset(
                    AssetsIcon.IC_RIGHT_ARROW,
                    height: AppSizes.setHeight(16),
                    width: AppSizes.setWidth(16),
                    color: CustomAppColor.of(context).btnPurple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
