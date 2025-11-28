import 'package:flutter/material.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

/// 订单完成印章组件
///
/// 用于已完成订单详情页右上角的印章水印效果
class SealStamp extends StatelessWidget {
  const SealStamp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: AppSizes.setWidth(5),
      top: AppSizes.setHeight(10),
      child: Transform.rotate(
        angle: -0.35,
        child: Container(
          width: AppSizes.setWidth(100),
          height: AppSizes.setWidth(100),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                blurRadius: 0,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Container(
            margin: EdgeInsets.all(AppSizes.setWidth(6)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonText(
                    text: '提油业务',
                    fontSize: AppSizes.setFontSize(14),
                    fontWeight: FontWeight.w700,
                    textColor: const Color(0xFF10B981).withValues(alpha: 0.15),
                  ),
                  CommonText(
                    text: '已完成',
                    fontSize: AppSizes.setFontSize(14),
                    fontWeight: FontWeight.w700,
                    textColor: const Color(0xFF10B981).withValues(alpha: 0.15),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
