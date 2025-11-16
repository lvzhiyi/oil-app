import 'dart:io';
import 'package:flutter/material.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'image_viewer.dart';

class UploadVoucherDialog extends StatefulWidget {
  final int maxUploadCount;
  final Function() onPickImage;
  final Function(int) onRemoveImage;
  final Function(int) onUploadImage;
  final Function() onUploadAllImages;
  final Function(int) onRemoveUploadedImage;
  final List<int> uploadingImageIndices;
  final List<String> selectedImagePaths;
  final List<String> uploadedImageUrls;

  const UploadVoucherDialog({
    Key? key,
    this.maxUploadCount = 20,
    required this.onPickImage,
    required this.onRemoveImage,
    required this.onUploadImage,
    required this.onUploadAllImages,
    required this.onRemoveUploadedImage,
    this.uploadingImageIndices = const [],
    this.selectedImagePaths = const [],
    this.uploadedImageUrls = const [],
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
        // 已上传的图片
        if (widget.uploadedImageUrls.isNotEmpty) ...[
          Text(
            '已上传的图片 (${widget.uploadedImageUrls.length}张)',
            style: TextStyle(
              fontSize: pt(14, isFontSize: true),
              fontWeight: FontWeight.w500,
              color: Colors.green[700],
            ),
          ),
          SizedBox(height: pt(8)),
          _buildUploadedImageGrid(),
          SizedBox(height: pt(16)),
        ],

        // 待上传的图片
        if (widget.selectedImagePaths.isNotEmpty) ...[
          Row(
            children: [
              Text(
                '待上传的图片 (${widget.selectedImagePaths.length}张)',
                style: TextStyle(
                  fontSize: pt(14, isFontSize: true),
                  fontWeight: FontWeight.w500,
                  color: Colors.orange[700],
                ),
              ),
              const Spacer(),
              _buildUploadAllButton(),
            ],
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

  /// 已上传图片网格
  Widget _buildUploadedImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: pt(8),
        mainAxisSpacing: pt(8),
        childAspectRatio: 1.0,
      ),
      itemCount: widget.uploadedImageUrls.length,
      itemBuilder: (context, index) {
        return _buildUploadedImageItem(widget.uploadedImageUrls[index], index);
      },
    );
  }

  /// 待上传图片网格
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

  /// 已上传图片项
  Widget _buildUploadedImageItem(String imageUrl, int index) {
    return GestureDetector(
      onTap: () {
        _showImageViewer(widget.uploadedImageUrls, index, false);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(pt(8)),
          border: Border.all(color: Colors.green[300]!, width: 2),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(pt(6)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
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
                onTap: () => _showDeleteConfirmDialog(index),
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
            // 已上传标识
            Positioned(
              top: pt(4),
              left: pt(4),
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: pt(6), vertical: pt(2)),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(pt(10)),
                ),
                child: Text(
                  '已上传',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: pt(8, isFontSize: true),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 待上传图片项
  Widget _buildSelectedImageItem(String imagePath, int index) {
    final isUploading = widget.uploadingImageIndices.contains(index);

    return GestureDetector(
      onTap: () {
        _showImageViewer(widget.selectedImagePaths, index, true);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(pt(8)),
          border: Border.all(color: Colors.orange[300]!, width: 2),
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
                onTap: isUploading ? null : () => widget.onRemoveImage(index),
                child: Container(
                  padding: EdgeInsets.all(pt(4)),
                  decoration: BoxDecoration(
                    color: isUploading ? Colors.grey : Colors.red,
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
            // 上传按钮 - 更明显的设计
            Positioned(
              bottom: pt(4),
              left: pt(4),
              right: pt(4),
              child: GestureDetector(
                onTap: isUploading ? null : () => widget.onUploadImage(index),
                child: Container(
                  height: pt(28),
                  decoration: BoxDecoration(
                    color: isUploading ? Colors.grey[600] : Colors.blue[600],
                    borderRadius: BorderRadius.circular(pt(14)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: pt(4),
                        offset: Offset(0, pt(2)),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isUploading) ...[
                        SizedBox(
                          width: pt(12),
                          height: pt(12),
                          child: const CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: pt(4)),
                        Text(
                          '上传中',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: pt(10, isFontSize: true),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ] else ...[
                        Icon(
                          Icons.cloud_upload_rounded,
                          color: Colors.white,
                          size: pt(12),
                        ),
                        SizedBox(width: pt(4)),
                        Text(
                          '点击上传',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: pt(10, isFontSize: true),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 一键上传所有图片按钮
  Widget _buildUploadAllButton() {
    final hasSelectedImages = widget.selectedImagePaths.isNotEmpty;
    final hasUploadingImages = widget.uploadingImageIndices.isNotEmpty;

    return GestureDetector(
      onTap: (!hasSelectedImages || hasUploadingImages)
          ? null
          : widget.onUploadAllImages,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: pt(12), vertical: pt(6)),
        decoration: BoxDecoration(
          color: (!hasSelectedImages || hasUploadingImages)
              ? Colors.grey[300]
              : Colors.blue[600],
          borderRadius: BorderRadius.circular(pt(16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasUploadingImages) ...[
              SizedBox(
                width: pt(12),
                height: pt(12),
                child: const CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: pt(4)),
              Text(
                '上传中...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: pt(11, isFontSize: true),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else ...[
              Icon(
                Icons.cloud_upload_rounded,
                color: (!hasSelectedImages || hasUploadingImages)
                    ? Colors.grey[600]
                    : Colors.white,
                size: pt(14),
              ),
              SizedBox(width: pt(4)),
              Text(
                '一键上传',
                style: TextStyle(
                  color: (!hasSelectedImages || hasUploadingImages)
                      ? Colors.grey[600]
                      : Colors.white,
                  fontSize: pt(11, isFontSize: true),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddImageButton() {
    final totalImages =
        widget.selectedImagePaths.length + widget.uploadedImageUrls.length;
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

  /// 显示删除确认对话框
  void _showDeleteConfirmDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(pt(16)),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: pt(280),
            padding: EdgeInsets.all(pt(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 警告图标
                Container(
                  width: pt(64),
                  height: pt(64),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    size: pt(32),
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: pt(20)),
                // 标题
                Text(
                  '删除图片',
                  style: TextStyle(
                    fontSize: pt(18, isFontSize: true),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: pt(12)),
                // 内容
                Text(
                  '确定要删除这张转账凭证吗？\n删除后将无法恢复',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: pt(14, isFontSize: true),
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                SizedBox(height: pt(24)),
                // 按钮区域
                Row(
                  children: [
                    // 取消按钮
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: pt(12)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(pt(8)),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Text(
                          '取消',
                          style: TextStyle(
                            fontSize: pt(16, isFontSize: true),
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: pt(12)),
                    // 确定按钮
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          widget.onRemoveUploadedImage(index);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: pt(12)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(pt(8)),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          '确定删除',
                          style: TextStyle(
                            fontSize: pt(16, isFontSize: true),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
