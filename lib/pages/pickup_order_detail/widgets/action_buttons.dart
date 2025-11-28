import 'package:flutter/material.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

/// 订单详情页底部操作按钮组件
///
/// 包含"取消订单"和"保存凭证"两个按钮
class ActionButtons extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSaveCertificate;
  final bool isSaving;

  const ActionButtons({
    Key? key,
    required this.onCancel,
    required this.onSaveCertificate,
    this.isSaving = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.setWidth(20),
            vertical: AppSizes.setHeight(12),
          ),
          child: Row(
            children: [
              Expanded(child: _buildCancelButton()),
              SizedBox(width: AppSizes.setWidth(16)),
              Expanded(child: _buildSaveCertificateButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onCancel,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.setHeight(12),
          ),
          backgroundColor: const Color(0xFFF5F7FA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.setWidth(24)),
          ),
        ),
        child: CommonText(
          text: '取消订单',
          fontSize: AppSizes.setFontSize(15),
          textColor: const Color(0xFFEF4444),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSaveCertificateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSaving ? null : onSaveCertificate,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: AppSizes.setHeight(12),
          ),
          backgroundColor: const Color(0xFF7165E3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.setWidth(24)),
          ),
          elevation: 0,
        ),
        child: CommonText(
          text: '保存凭证',
          fontSize: AppSizes.setFontSize(15),
          textColor: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
