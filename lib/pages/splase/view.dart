import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottery_app/pages/splase/state.dart';
import 'package:lottery_app/static/img.dart';
import 'package:lottery_app/widgets/common/image_asset_pro.dart';

class SplaseView extends HookWidget {
  final SplaseState state;

  const SplaseView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          ImageAsset(
            assetName: AssetsImg.SPLASE_SPLASE,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ],
      ),
    );
  }
}
