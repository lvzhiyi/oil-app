import 'package:flutter/material.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

/// 发送验证码按钮组件
class SendCodeButton extends StatelessWidget {
  /// 倒计时秒数，null或0表示可以发送
  final int? countdown;

  /// 发送验证码回调
  final VoidCallback onSendCode;

  const SendCodeButton({
    required this.countdown,
    required this.onSendCode,
    Key? key,
  }) : super(key: key);

  bool get _isEnabled => countdown == null || countdown! <= 0;

  String get _buttonText {
    if (_isEnabled) {
      return '获取验证码';
    }
    return '${countdown}s';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 分隔线
        Container(
          width: 1,
          height: AppSizes.setHeight(20),
          color: const Color(0xFFE5E7EB),
          margin: EdgeInsets.only(left: AppSizes.setWidth(4)),
        ),
        // 按钮
        GestureDetector(
          onTap: _isEnabled ? onSendCode : null,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.setWidth(16),
              vertical: AppSizes.setHeight(8),
            ),
            child: CommonText(
              text: _buttonText,
              fontSize: AppSizes.setFontSize(13),
              fontWeight: FontWeight.w600,
              textColor: _isEnabled
                  ? const Color(0xFF7165E3)
                  : const Color(0xFF9CA3AF),
            ),
          ),
        ),
      ],
    );
  }
}
