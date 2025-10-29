// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oil_business_app/static/svg.dart';
import 'package:oil_business_app/widgets/common/svg_asset.dart';

// import 'cached_network_image_pro.dart';

class BankIcon extends StatelessWidget {
  const BankIcon({
    super.key,
    required this.bankCode,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.color,
    this.package,
    this.url,
  });
  final String bankCode;
  final String? package;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final Color? color;
  final String? url;
  // bool _checkFileExists(String path) {
  //   return File(path).existsSync();
  // }
  @override
  Widget build(BuildContext context) {
    List<String> fixPaths = AssetsSvg.BANK.split('/')..removeLast();
    String assetName =
        '${fixPaths.join('/')}/banks/method_${bankCode.toLowerCase()}.svg';
    // print('assetsName $assetName is exists? ${_checkFileExists(assetName)}');
    // if (!_checkFileExists(assetName)) {
    //   return ImageNetworkCached(
    //     imageUrl: url!,
    //     width: width,
    //     height: height,
    //     alignment: alignment,
    //     fit: fit,
    //     bgColor: color ?? Colors.transparent,
    //   );
    // }

    // print(AssetsSvg.BANKS_METHOD_GCASH);
    // print('converted name = $assetName');
    return SvgAsset(
      assetName: assetName,
      width: width,
      height: height,
      package: package,
      fit: fit,
      alignment: alignment,
      color: color,
    );
  }
}
