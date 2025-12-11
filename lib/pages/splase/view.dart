import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oil_business_app/pages/splase/state.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/static/img.dart';
import 'package:oil_business_app/utils/constant.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/common/image_asset_pro.dart';

class SplaseView extends HookWidget {
  final SplaseState state;

  const SplaseView({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // body: Stack(
      //   fit: StackFit.expand,
      //   children: [
      //     // 中心内容
      //     Center(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           // 水滴图标容器
      //           ImageAsset(
      //               assetName: AssetsImg.LOGO,
      //               width: AppSizes.setWidth(240),
      //               height: AppSizes.setHeight(240)),

      //           SizedBox(height: AppSizes.setHeight(180)),

      //           // "买油呗" 标题
      //           Text(
      //             '买油呗',
      //             style: TextStyle(
      //               fontFamily: Constant.fontFamilyUrbanist,
      //               fontSize: AppSizes.setFontSize(32),
      //               fontWeight: FontWeight.w700,
      //               color: CustomAppColor.of(context).txtOrange, // 紫色-蓝色
      //               height: 1.2,
      //             ),
      //           ),

      //           SizedBox(height: AppSizes.setHeight(12)),

      //           // "更专业的 B2B 交易平台" 副标题
      //           Text(
      //             '专业的 B2B 成品油交易平台',
      //             style: TextStyle(
      //               fontFamily: Constant.fontFamilyUrbanist,
      //               fontSize: AppSizes.setFontSize(16),
      //               fontWeight: FontWeight.w400,
      //               color: const Color(0xFF9EA6BE), // 灰色-紫色
      //               height: 1.2,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
