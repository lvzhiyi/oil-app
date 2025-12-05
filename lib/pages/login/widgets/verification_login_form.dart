import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/static/icon.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/utils/validators/verification_code_validator.dart';
import 'package:oil_business_app/widgets/base/textfield/common_textformfield.dart';

/// 验证码登录表单组件（仅包含验证码字段）
class VerificationLoginForm extends StatelessWidget {
  final int? countdown;
  final VoidCallback onSendCode;

  const VerificationLoginForm({
    this.countdown,
    required this.onSendCode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonTextFormField(
      name: 'verificationCode',
      borderColor: const Color(0xFFE5E7EB),
      fillColor: const Color(0xFFF9FAFB),
      leadingIcon: Image.asset(
        AssetsIcon.IC_PASSWORD,
        width: AppSizes.setHeight(20),
        height: AppSizes.setHeight(20),
      ),
      hintText: '请输入4位验证码',
      keyboardType: TextInputType.number,
      inputFormatter: FilteringTextInputFormatter.digitsOnly,
      maxLength: 4,
      radius: 12,
      validators: VerificationCodeValidator.validateCode,
      suffixIcon: _buildCodeButton(context),
    );
  }

  Widget _buildCodeButton(BuildContext context) {
    final isCountingDown = countdown != null && countdown! > 0;
    final buttonText = isCountingDown ? '${countdown}s' : '获取验证码';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 分隔线
        Container(
          width: 1,
          height: AppSizes.setHeight(12),
          color: const Color(0xFFE5E7EB),
          margin: EdgeInsets.only(right: AppSizes.setWidth(12)),
        ),
        // 获取验证码按钮
        GestureDetector(
          onTap: isCountingDown ? null : onSendCode,
          child: Padding(
            padding: EdgeInsets.only(right: AppSizes.setWidth(8)),
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: AppSizes.setFontSize(13),
                color: isCountingDown
                    ? const Color(0xFF9CA3AF)
                    : AppColor.txtPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
