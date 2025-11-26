import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class SaveShareSheet extends StatelessWidget {
  final Uint8List previewBytes;
  final Future<void> Function() onSaveToGallery;
  final Future<void> Function() onSaveToDirectory;
  final Future<void> Function() onShare;

  const SaveShareSheet({
    Key? key,
    required this.previewBytes,
    required this.onSaveToGallery,
    required this.onSaveToDirectory,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.setWidth(16)),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: AppSizes.setHeight(20)),
            CommonText(
              text: '图片已生成',
              fontSize: AppSizes.setFontSize(16),
              fontWeight: FontWeight.w600,
              textColor: const Color(0xff374151),
            ),
            SizedBox(height: AppSizes.setHeight(16)),
            Container(
              width: AppSizes.setWidth(120),
              height: AppSizes.setHeight(160),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.setWidth(8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: const Color(0xffE5E7EB),
                  width: 1,
                ),
              ),
              padding: EdgeInsets.all(AppSizes.setWidth(8)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.setWidth(4)),
                child: Image.memory(
                  previewBytes,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: AppSizes.setWidth(32),
                      color: const Color(0xff9CA3AF),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSizes.setHeight(24)),
            _buildDivider(),
            _ActionRow(
              icon: Icons.photo_library_outlined,
              text: '保存到系统相册',
              onTap: onSaveToGallery,
            ),
            _buildDivider(),
            _ActionRow(
              icon: Icons.folder_open_outlined,
              text: '选择存储目录 / 保存到文件夹',
              onTap: onSaveToDirectory,
            ),
            Container(
              color: const Color(0xffF2F2F2),
              height: AppSizes.setHeight(8),
            ),
            _ActionRow(
              icon: Icons.share_outlined,
              text: '发送给好友 / 司机',
              onTap: onShare,
            ),
            Container(
              color: const Color(0xffF2F2F2),
              height: AppSizes.setHeight(8),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.setHeight(16),
                ),
                alignment: Alignment.center,
                child: CommonText(
                  text: '取消',
                  fontSize: AppSizes.setFontSize(16),
                  fontWeight: FontWeight.w600,
                  textColor: const Color(0xff374151),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xffF3F4F6),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Future<void> Function() onTap;

  const _ActionRow({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.setWidth(20),
          vertical: AppSizes.setHeight(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xff374151),
              size: AppSizes.setWidth(22),
            ),
            SizedBox(width: AppSizes.setWidth(12)),
            Expanded(
              child: CommonText(
                text: text,
                fontSize: AppSizes.setFontSize(15),
                fontWeight: FontWeight.w500,
                textColor: const Color(0xff374151),
                textAlign: TextAlign.left,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: const Color(0xff9CA3AF),
              size: AppSizes.setWidth(20),
            ),
          ],
        ),
      ),
    );
  }
}