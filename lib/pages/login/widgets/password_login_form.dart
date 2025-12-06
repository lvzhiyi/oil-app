import 'package:flutter/material.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';

/// 密码登录表单组件（仅包含密码字段）
class PasswordLoginForm extends StatelessWidget {
  const PasswordLoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonTextFormField(
      name: 'password',
      borderColor: const Color(0xFFE5E7EB),
      fillColor: const Color(0xFFF9FAFB),
      leadingIcon: Image.asset(
        AssetsIcon.IC_PASSWORD,
        width: AppSizes.setHeight(20),
        height: AppSizes.setHeight(20),
      ),
      hintText: '请输入登录密码',
      isPasswordField: true,
      radius: 12,
    );
  }
}
