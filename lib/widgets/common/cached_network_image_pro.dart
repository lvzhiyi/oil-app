import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/utils/screen.dart';
import 'package:oil_business_app/widgets/common/image_asset_pro.dart';
import 'dart:math' as math;

class ImageNetworkCached extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color bgColor;
  final Color? iconColor;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;
  final bool hideDefaultHolder;
  final bool hideErrorHolder;
  final Alignment alignment;
  final Widget? placeholderWidget;
  final Widget? errorWidget;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final VoidCallback? onloaded;
  final String? cacheKey;
  final BaseCacheManager? cacheManager;

  const ImageNetworkCached({
    Key? key,
    required this.imageUrl,
    this.cacheKey,
    this.fit,
    this.width,
    this.height,
    this.borderRadius = .0,
    this.bgColor = Colors.transparent,
    this.fadeInDuration = const Duration(milliseconds: 100),
    this.fadeOutDuration = const Duration(milliseconds: 100),
    this.hideDefaultHolder = false,
    this.hideErrorHolder = false,
    this.alignment = Alignment.center,
    this.placeholderWidget,
    this.errorWidget,
    this.memCacheWidth,
    this.memCacheHeight,
    this.iconColor,
    this.cacheManager,
    this.onloaded,
  }) : super(key: key);

  static bool onloadedOnce = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        color: bgColor,
        child: CachedNetworkImage(
          alignment: alignment,
          fadeInDuration: fadeInDuration,
          fadeOutDuration: fadeOutDuration,
          imageUrl: imageUrl,
          memCacheWidth: memCacheWidth,
          memCacheHeight: memCacheHeight,
          cacheKey: cacheKey,
          cacheManager: cacheManager,
          placeholder: (context, url) {
            if (hideDefaultHolder) {
              return const SizedBox();
            }

            return Center(
              child: placeholderWidget ??
                  LayoutBuilder(
                    builder: ((context, constraints) {
                      // var size = getSize(constraints);
                      return const CupertinoActivityIndicator();
                    }),
                  ),
            );
          },
          errorWidget: (context, url, error) {
            if (hideErrorHolder) {
              return const SizedBox();
            }

            return Center(
              child: errorWidget ??
                  LayoutBuilder(
                    builder: ((context, constraints) {
                      var size = getSize(constraints);

                      return ImageAsset(
                        assetName: AssetsImg.LOGO,
                        fit: BoxFit.contain,
                        width: size.width,
                        height: size.height,
                      );
                    }),
                  ),
            );
          },
          width: width,
          height: height,
          fit: fit,
        ),
      ),
    );
  }

  Size getSize(BoxConstraints constraints) {
    double w = 0;
    double h = 0;

    var max = math.max(constraints.maxWidth, constraints.maxHeight);
    var min = math.min(constraints.maxWidth, constraints.maxHeight);

    // 最大值是一个有限值
    if (max != double.infinity) {
      w = constraints.maxWidth * 0.5;
      h = constraints.maxHeight * 0.5;
    } else {
      if (min != double.infinity) {
        // 最小值是一个有限值
        w = min * 0.5;
        h = min * 0.5;
      } else {
        // 布局尺寸无限大，使用屏幕宽度
        w = screen.screenWidth * 0.5;
        h = screen.screenHeight * 0.5;
      }
    }

    return Size(w, h);
  }
}
