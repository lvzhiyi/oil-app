import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgAsset extends StatefulWidget {
  final String assetName;
  final String? package;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final Color? color;
  final ColorFilter? colorFilter;

  const SvgAsset({
    Key? key,
    required this.assetName,
    this.package,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.color,
    this.colorFilter,
  }) : super(key: key);

  @override
  SvgAssetState createState() => SvgAssetState();
}

class SvgAssetState extends State<SvgAsset> {
  String? cdnAsset; //构建web后替换的cdn资源

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      widget.assetName,
      width: widget.width,
      height: widget.height,
      key: widget.key,
      package: widget.package,
      fit: widget.fit,
      alignment: widget.alignment,
      // ignore: deprecated_member_use
      color: widget.color,
      colorFilter: widget.colorFilter,
    );
  }
}
