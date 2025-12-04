import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

/// 资质证照图片上传组件
/// 用于统一上传资质证照的UI样式
class QualificationImageUpload extends StatelessWidget {
  /// 图片URL或本地文件路径
  final String? imageUrl;

  /// 占位提示文本
  final String hintText;

  /// 图片URL变化回调
  final ValueChanged<String?> onChanged;

  /// 是否禁用
  final bool enabled;

  const QualificationImageUpload({
    Key? key,
    this.imageUrl,
    this.hintText = '点击上传照片',
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = CustomAppColor.of(context);
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: enabled ? () => _pickImage(context) : null,
      child: Container(
        height: AppSizes.setHeight(140),
        width: double.infinity,
        decoration: BoxDecoration(
          color: hasImage ? Colors.transparent : const Color(0xFFF9FAFB),
          border: Border.all(
            color: const Color(0xFFD1D5DB),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
        ),
        child: hasImage
            ? Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.setWidth(12)),
                    child: imageUrl!.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: const Color(0xFFF9FAFB),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: const Color(0xFFF9FAFB),
                              child: Icon(Icons.error, color: colors.txtGrey),
                            ),
                          )
                        : Image.file(
                            File(imageUrl!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: const Color(0xFFF9FAFB),
                              child: Icon(Icons.error, color: colors.txtGrey),
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSizes.setHeight(6),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(AppSizes.setWidth(12)),
                          bottomRight: Radius.circular(AppSizes.setWidth(12)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            size: AppSizes.setFontSize(12),
                            color: Colors.white,
                          ),
                          SizedBox(width: AppSizes.setWidth(4)),
                          CommonText(
                            text: '点击更换',
                            fontSize: AppSizes.setFontSize(12),
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: AppSizes.setFontSize(32),
                      color: const Color(0xFFD1D5DB),
                    ),
                    SizedBox(height: AppSizes.setHeight(8)),
                    CommonText(
                      text: hintText,
                      fontSize: AppSizes.setFontSize(12),
                      textColor: const Color(0xFF9CA3AF),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    if (image != null) {
      onChanged(image.path);
    }
  }
}

