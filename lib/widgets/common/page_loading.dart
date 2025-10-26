import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/static/img.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/base/btn.dart';
import 'package:lottery_app/widgets/common/image_asset_pro.dart';

enum PageStatus { loading, success, error, empty }

class LotteryPageLoading extends StatelessWidget {
  final PageStatus status;
  final Widget child;
  final String? msg;
  final TextStyle? textStyle;
  final double? placeholderHeight;

  /// 提示文案
  final String? placeText;

  /// 重试
  final VoidCallback? retry; // 不传参数不会显示重试按钮

  const LotteryPageLoading({
    Key? key,
    required this.status,
    required this.child,
    this.placeText,
    this.msg,
    this.textStyle,
    this.retry,

    /// Loading加载时的容器高度
    this.placeholderHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // flutter web 对app版本有最低要求 1.81.0

    if (status == PageStatus.error) {
      return Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageAsset(
                  assetName: AssetsImg.PAGE_ERROR,
                  width: pt(180),
                ),
                Gap(pt(20)),
                SizedBox(
                  width: pt(200),
                  child: Text(
                    placeText ?? "加载失败",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xffacb2bb),
                      fontSize: pt(16, isFontSize: true),
                    ),
                  ),
                ),
                Gap(pt(20)),
                if (retry != null)
                  SportsBtn(
                    text: '刷新',
                    width: pt(132),
                    height: pt(44),
                    btnLoading: false,
                    tapHandle: () {
                      if (retry != null) {
                        retry!();
                      }
                    },
                  )
              ],
            ),
          ),
        ],
      );
    }

    if (status == PageStatus.empty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageAsset(
              assetName: AssetsImg.PAGE_EMPTY,
              width: pt(180),
            ),
            Gap(pt(20)),
            Text(
              placeText ?? "暂无数据",
              style: TextStyle(
                color: const Color(0xffacb2bb),
                fontSize: pt(16, isFontSize: true),
              ),
            ),
            SizedBox(
              height: pt(30),
            ),
          ],
        ),
      );
    }

    if (status == PageStatus.loading) {
      return SizedBox(
        height: placeholderHeight,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: pt(108),
                height: pt(108),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(pt(14)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CupertinoActivityIndicator(radius: 16),
                    Gap(pt(8)),
                    Text(
                      '加载中',
                      style: TextStyle(
                        color: AppColors.textGray2,
                        fontSize: pt(16),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return child;
  }
}
