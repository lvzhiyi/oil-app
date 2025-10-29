import 'package:flutter/material.dart';
import 'package:oil_business_app/static/img.dart';

class ImageAsset extends StatefulWidget {
  final String assetName;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final double borderRadius;
  final String? package;

  const ImageAsset({
    Key? key,
    required this.assetName,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.borderRadius = .0,
    this.package,
  }) : super(key: key);

  @override
  ImageAssetState createState() => ImageAssetState();
}

class ImageAssetState extends State<ImageAsset> {
  String? cdnAsset; //构建web后替换的cdn资源

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Image.asset(
        widget.assetName.isNotEmpty ? widget.assetName : AssetsImg.LOGO,
        width: widget.width,
        height: widget.height,
        key: widget.key,
        package: widget.package,
        fit: widget.fit,
        alignment: widget.alignment,
      ),
    );
  }
}
