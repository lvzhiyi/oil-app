import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/utils/validators/phone_validator.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';

/// 共享的手机号输入框组件
class PhoneInputField extends StatelessWidget {
  final String name;
  final TextEditingController? controller;

  const PhoneInputField({
    this.name = 'phone',
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonTextFormField(
      name: name,
      controller: controller,
      borderColor: const Color(0xFFE5E7EB),
      fillColor: const Color(0xFFF9FAFB),
      leadingIcon: Image.asset(
        AssetsIcon.IC_PROFILE,
        width: AppSizes.setHeight(20),
        height: AppSizes.setHeight(20),
      ),
      hintText: '请输入手机号码',
      keyboardType: TextInputType.phone,
      inputFormatter: FilteringTextInputFormatter.digitsOnly,
      maxLength: 11,
      radius: 12,
      validators: PhoneValidator.validatePhone,
    );
  }
}
