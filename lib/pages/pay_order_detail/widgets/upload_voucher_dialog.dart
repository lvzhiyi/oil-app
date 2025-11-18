import 'dart:io';
import 'package:flutter/material.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'image_viewer.dart';

class UploadVoucherDialog extends StatefulWidget {
  final int maxUploadCount;
  final Function() onPickImage;
  final Function(int) onRemoveImage;
  final List<String> selectedImagePaths;

  const UploadVoucherDialog({
    Key? key,
    this.maxUploadCount = 5,
    required this.onPickImage,
    required this.onRemoveImage,
    this.selectedImagePaths = const [],
  }) : super(key: key);

  @override
  State<UploadVoucherDialog> createState() => _UploadVoucherDialogState();
}

class _UploadVoucherDialogState extends State<UploadVoucherDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 已选择的图片
        if (widget.selectedImagePaths.isNotEmpty) ...[
          Text(
            '已选择的图片 (${widget.selectedImagePaths.length}张)',
            style: TextStyle(
              fontSize: pt(14, isFontSize: true),
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: pt(8)),
          _buildSelectedImageGrid(),
          SizedBox(height: pt(16)),
        ],

        // 添加图片按钮
        _buildAddImageButton(),
        SizedBox(height: pt(8)),
        // 提示文字
        Text(
          '最多可上传${widget.maxUploadCount}张图片，支持JPG、PNG格式',
          style: TextStyle(
            fontSize: pt(12, isFontSize: true),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// 已选择图片网格
  Widget _buildSelectedImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: pt(8),
        mainAxisSpacing: pt(8),
        childAspectRatio: 1.0,
      ),
      itemCount: widget.selectedImagePaths.length,
      itemBuilder: (context, index) {
        return _buildSelectedImageItem(widget.selectedImagePaths[index], index);
      },
    );
  }

  /// 已选择图片项
  Widget _buildSelectedImageItem(String imagePath, int index) {
    return GestureDetector(
      onTap: () {
        _showImageViewer(widget.selectedImagePaths, index, true);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(pt(8)),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(pt(6)),
              child: Image.file(
                File(imagePath),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildErrorPlaceholder();
                },
              ),
            ),
            // 删除按钮
            Positioned(
              top: pt(4),
              right: pt(4),
              child: GestureDetector(
                onTap: () => widget.onRemoveImage(index),
                child: Container(
                  padding: EdgeInsets.all(pt(4)),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: pt(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddImageButton() {
    final totalImages = widget.selectedImagePaths.length;
    final canAddMore = totalImages < widget.maxUploadCount;

    return GestureDetector(
      onTap: canAddMore ? widget.onPickImage : null,
      child: Container(
        height: pt(50),
        decoration: BoxDecoration(
          color: canAddMore ? Colors.grey[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(pt(8)),
          border: Border.all(
              color: canAddMore ? Colors.grey[300]! : Colors.grey[400]!,
              style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: pt(24),
              color: canAddMore ? Colors.grey[600] : Colors.grey[500],
            ),
            SizedBox(width: pt(8)),
            Text(
              canAddMore ? '继续添加图片' : '已达到上限(${widget.maxUploadCount}张)',
              style: TextStyle(
                fontSize: pt(14, isFontSize: true),
                color: canAddMore ? Colors.grey[600] : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: pt(24),
            color: Colors.grey[400],
          ),
          SizedBox(height: pt(4)),
          Text(
            '加载失败',
            style: TextStyle(
              fontSize: pt(10, isFontSize: true),
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  void _showImageViewer(
      List<String> imageUrls, int initialIndex, bool isLocalImages) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageViewer(
          imageUrls: imageUrls,
          initialIndex: initialIndex,
          isLocalImages: isLocalImages,
        ),
      ),
    );
  }
}
