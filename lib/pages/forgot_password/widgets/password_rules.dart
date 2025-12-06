import 'package:flutter/material.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

/// 密码规则提示组件
class PasswordRules extends StatelessWidget {
  const PasswordRules({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: AppSizes.setWidth(4)),
      child: Row(
        children: [
          _buildRuleItem('8-20位字符'),
          SizedBox(width: AppSizes.setWidth(12)),
          _buildRuleItem('包含字母和数字'),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSizes.setWidth(4),
          height: AppSizes.setHeight(4),
          decoration: const BoxDecoration(
            color: Color(0xFFD1D5DB),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: AppSizes.setWidth(4)),
        CommonText(
          text: text,
          fontSize: AppSizes.setFontSize(11),
          textColor: const Color(0xFF6B7280),
        ),
      ],
    );
  }
}
