import 'package:flutter/material.dart';
import 'package:oil_business_app/static/svg.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';
import 'package:oil_business_app/widgets/common/svg_asset.dart';

/// 找回密码页面头部区域
class HeaderArea extends StatelessWidget {
  const HeaderArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppSizes.setHeight(10)),
        // 锁形图标圆圈
        Container(
          width: AppSizes.setWidth(64),
          height: AppSizes.setHeight(64),
          decoration: const BoxDecoration(
            color: Color(0xFFEEECFC),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgAsset(
              assetName: AssetsSvg.LOCK,
              width: AppSizes.setWidth(32),
              height: AppSizes.setHeight(32),
              color: const Color(0xFF7165E3),
            ),
          ),
        ),
        SizedBox(height: AppSizes.setHeight(16)),
        // 主标题
        CommonText(
          text: '重置登录密码',
          fontSize: AppSizes.setFontSize(24),
          fontWeight: FontWeight.w700,
          textColor: const Color(0xFF1F2937),
        ),
        SizedBox(height: AppSizes.setHeight(8)),
        // 副标题
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.setWidth(20)),
          child: CommonText(
            text: '请输入您的注册手机号并验证身份\n以设置新的安全密码',
            fontSize: AppSizes.setFontSize(14),
            textColor: const Color(0xFF6B7280),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
        SizedBox(height: AppSizes.setHeight(32)),
      ],
    );
  }
}
