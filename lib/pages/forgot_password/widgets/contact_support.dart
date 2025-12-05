import 'package:flutter/material.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

/// 联系客服组件
class ContactSupport extends StatelessWidget {
  /// 点击联系客服回调
  final VoidCallback? onContactSupport;

  const ContactSupport({
    this.onContactSupport,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonText(
          text: '手机号已停用？',
          fontSize: AppSizes.setFontSize(13),
          textColor: const Color(0xFF6B7280),
        ),
        GestureDetector(
          onTap: onContactSupport,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.only(left: AppSizes.setWidth(4)),
            child: CommonText(
              text: '联系人工客服',
              fontSize: AppSizes.setFontSize(13),
              fontWeight: FontWeight.w600,
              textColor: const Color(0xFF7165E3),
            ),
          ),
        ),
      ],
    );
  }
}
