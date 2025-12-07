import 'package:flutter/material.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

/// 品牌头部组件
class BrandHeader extends StatelessWidget {
  const BrandHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo 盒子
        Center(
          child: Image.asset(
            AssetsImg.LOGO,
            width: AppSizes.setWidth(72),
            height: AppSizes.setHeight(72),
          ),
        ),
        SizedBox(height: AppSizes.setHeight(16)),
        CommonText(
          text: '欢迎回到买油呗',
          fontWeight: FontWeight.w700,
          fontSize: AppSizes.setFontSize(24),
          textColor: const Color(0xFF1F2937),
        ),
        SizedBox(height: AppSizes.setHeight(8)),
        CommonText(
          text: '专业的B2B成品油交易平台',
          fontWeight: FontWeight.w400,
          fontSize: AppSizes.setFontSize(13),
          textColor: const Color(0xFF6B7280),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
