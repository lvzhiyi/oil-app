import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:oil_business_app/utils/pt.dart';
import 'image_viewer.dart';

class UploadVoucherDialog extends StatefulWidget {
  final int maxUploadCount;
  final Function() onPickImage;
  final Function(int) onRemoveImage;
  final Function(int)? onRemoveUploadedImage; // 删除已上传的凭证
  final List<String> selectedImagePaths; // 新选择的本地图片路径
  final List<String> uploadedImageUrls; // 已上传的凭证URL列表

  const UploadVoucherDialog({
    Key? key,
    this.maxUploadCount = 5,
    required this.onPickImage,
    required this.onRemoveImage,
    this.onRemoveUploadedImage,
    this.selectedImagePaths = const [],
    this.uploadedImageUrls = const [],
  }) : super(key: key);

  @override
  State<UploadVoucherDialog> createState() => _UploadVoucherDialogState();
}

class _UploadVoucherDialogState extends State<UploadVoucherDialog> {
  /// 获取总图片数量（已上传 + 新选择）
  int get _totalImageCount =>
      widget.uploadedImageUrls.length + widget.selectedImagePaths.length;

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.uploadedImageUrls.isNotEmpty ||
        widget.selectedImagePaths.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 已上传和新选择的图片
        if (hasImages) ...[
          Text(
            '已上传凭证 (${_totalImageCount}张)',
            style: TextStyle(
              fontSize: pt(14, isFontSize: true),
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: pt(8)),
          _buildImageGrid(),
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

  /// 图片网格（包含已上传和新选择的图片）
  Widget _buildImageGrid() {
    final totalCount = _totalImageCount;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: pt(8),
        mainAxisSpacing: pt(8),
        childAspectRatio: 1.0,
      ),
      itemCount: totalCount,
      itemBuilder: (context, index) {
        // 前部分是已上传的凭证（网络图片）
        if (index < widget.uploadedImageUrls.length) {
          return _buildUploadedImageItem(
            widget.uploadedImageUrls[index],
            index,
          );
        }
        // 后部分是新选择的图片（本地图片）
        else {
          final localIndex = index - widget.uploadedImageUrls.length;
          return _buildSelectedImageItem(
            widget.selectedImagePaths[localIndex],
            localIndex,
          );
        }
      },
    );
  }

  /// 已上传的凭证项（网络图片）
  Widget _buildUploadedImageItem(String imageUrl, int index) {
    return GestureDetector(
      onTap: () {
        // 查看所有图片（已上传 + 新选择）
        final allImages = [
          ...widget.uploadedImageUrls,
          ...widget.selectedImagePaths,
        ];
        _showImageViewer(allImages, index, false);
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
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.grey[400]!,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => _buildErrorPlaceholder(),
              ),
            ),
            // 删除按钮
            if (widget.onRemoveUploadedImage != null)
              Positioned(
                top: pt(4),
                right: pt(4),
                child: GestureDetector(
                  onTap: () => widget.onRemoveUploadedImage!(index),
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

  /// 新选择的图片项（本地图片）
  Widget _buildSelectedImageItem(String imagePath, int index) {
    return GestureDetector(
      onTap: () {
        // 查看所有图片（已上传 + 新选择）
        final allImages = [
          ...widget.uploadedImageUrls,
          ...widget.selectedImagePaths,
        ];
        final imageIndex = widget.uploadedImageUrls.length + index;
        _showImageViewer(allImages, imageIndex, true);
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
    final canAddMore = _totalImageCount < widget.maxUploadCount;

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
    // ImageViewer现在支持自动判断每张图片的类型（网络或本地）
    // 如果isLocalImages为false，它会自动检查URL是否以http://或https://开头
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
