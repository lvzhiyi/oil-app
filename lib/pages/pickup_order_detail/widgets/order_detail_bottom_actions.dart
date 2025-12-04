import 'package:flutter/material.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

/// 订单详情页底部操作按钮组件
///
/// 包含"取消订单"和"保存凭证图片"两个按钮，与提油成功页面风格一致
class OrderDetailBottomActions extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onCancel;
  final VoidCallback? onSave;

  const OrderDetailBottomActions({
    Key? key,
    required this.isSaving,
    required this.onCancel,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius =
        BorderRadius.circular(AppSizes.setWidth(12));

    return Container(
      padding: EdgeInsets.only(
        left: AppSizes.setWidth(16),
        right: AppSizes.setWidth(16),
        top: AppSizes.setHeight(12),
        bottom: AppSizes.setHeight(12) + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: CustomAppColor.of(context).white,
              borderRadius: borderRadius,
              child: InkWell(
                borderRadius: borderRadius,
                onTap: onCancel,
                child: Container(
                  height: AppSizes.setHeight(52),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    border: Border.all(
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                  child: CommonText(
                    text: '取消订单',
                    fontSize: AppSizes.setFontSize(15),
                    fontWeight: FontWeight.w600,
                    textColor: const Color(0xFFEF4444),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.setWidth(12)),
          Expanded(
            child: Material(
              color: CustomAppColor.of(context).btnPurple,
              borderRadius: borderRadius,
              child: InkWell(
                borderRadius: borderRadius,
                onTap: onSave,
                child: Container(
                  height: AppSizes.setHeight(52),
                  alignment: Alignment.center,
                  child: isSaving
                      ? SizedBox(
                          width: AppSizes.setWidth(20),
                          height: AppSizes.setWidth(20),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: AppSizes.setWidth(4)),
                              child: Icon(
                                Icons.download_outlined,
                                color: Colors.white,
                                size: AppSizes.setWidth(18),
                              ),
                            ),
                            SizedBox(width: AppSizes.setWidth(4)),
                            CommonText(
                              text: '保存凭证图片',
                              fontSize: AppSizes.setFontSize(15),
                              fontWeight: FontWeight.w700,
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
