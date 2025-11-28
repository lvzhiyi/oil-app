import 'package:flutter/material.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

/// 订单详情项组件
///
/// 可复用的 label-value 行展示组件，支持自定义 value widget
class DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final Widget? valueWidget;

  const DetailItem({
    Key? key,
    required this.label,
    required this.value,
    this.valueWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          text: label,
          fontSize: AppSizes.setFontSize(14),
          textColor: const Color(0xFF6B7280),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: valueWidget ??
                CommonText(
                  text: value,
                  fontSize: AppSizes.setFontSize(14),
                  fontWeight: FontWeight.w500,
                  textColor: const Color(0xFF1F2937),
                  textAlign: TextAlign.right,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),
          ),
        ),
      ],
    );
  }
}
