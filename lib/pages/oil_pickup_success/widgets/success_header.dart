import 'package:flutter/material.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class OilPickupSuccessHeader extends StatelessWidget {
  const OilPickupSuccessHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: AppSizes.setWidth(76),
          height: AppSizes.setWidth(76),
          decoration: const BoxDecoration(
            color: Color(0xFFE3F8E8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            size: AppSizes.setWidth(40),
            color: CustomAppColor.of(context).green,
          ),
        ),
        SizedBox(height: AppSizes.setHeight(12)),
        CommonText(
          text: '提油凭证生成成功',
          fontSize: AppSizes.setFontSize(18),
          fontWeight: FontWeight.w600,
          textColor: CustomAppColor.of(context).txtBlack,
        ),
        SizedBox(height: AppSizes.setHeight(6)),
        CommonText(
          text: '请保存下方图片发送给司机',
          fontSize: AppSizes.setFontSize(13),
          fontWeight: FontWeight.w400,
          textColor: const Color(0xff6B7280),
        ),
      ],
    );
  }
}
