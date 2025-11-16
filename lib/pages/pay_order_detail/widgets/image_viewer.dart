import 'dart:io';
import 'package:flutter/material.dart';
import 'package:oil_business_app/utils/pt.dart';

/// 图片查看器组件，支持幻灯片效果
class ImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final bool isLocalImages; // 是否为本地图片

  const ImageViewer({
    Key? key,
    required this.imageUrls,
    this.initialIndex = 0,
    this.isLocalImages = false,
  }) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          '${_currentIndex + 1}/${widget.imageUrls.length}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // 图片展示区域
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: widget.isLocalImages
                      ? Image.file(
                          File(widget.imageUrls[index]),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: pt(200),
                              height: pt(200),
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(pt(8)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: pt(48),
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: pt(8)),
                                  Text(
                                    '图片加载失败',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: pt(14, isFontSize: true),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Image.network(
                          widget.imageUrls[index],
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                color: Colors.white,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: pt(200),
                              height: pt(200),
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(pt(8)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: pt(48),
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: pt(8)),
                                  Text(
                                    '图片加载失败',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: pt(14, isFontSize: true),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              );
            },
          ),

          // 左右切换按钮（只在多张图片时显示）
          if (widget.imageUrls.length > 1) ...[
            // 左侧按钮
            Positioned(
              left: pt(20),
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _currentIndex > 0 ? _previousImage : null,
                  child: Container(
                    width: pt(48),
                    height: pt(48),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_left,
                      color: _currentIndex > 0 ? Colors.white : Colors.grey,
                      size: pt(32),
                    ),
                  ),
                ),
              ),
            ),

            // 右侧按钮
            Positioned(
              right: pt(20),
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _currentIndex < widget.imageUrls.length - 1
                      ? _nextImage
                      : null,
                  child: Container(
                    width: pt(48),
                    height: pt(48),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_right,
                      color: _currentIndex < widget.imageUrls.length - 1
                          ? Colors.white
                          : Colors.grey,
                      size: pt(32),
                    ),
                  ),
                ),
              ),
            ),
          ],

          // 底部指示器（多张图片时显示）
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: pt(50),
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imageUrls.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: pt(4)),
                    width: pt(8),
                    height: pt(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentIndex
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _previousImage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextImage() {
    if (_currentIndex < widget.imageUrls.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
