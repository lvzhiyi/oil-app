import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottery_app/utils/pt.dart';

typedef OnRefresh = void Function();
typedef OnLoading = void Function();

class PullOrRefreshEasy extends HookWidget {
  final Widget child;
  final OnRefresh? onRefresh;
  final OnLoading? onLoading;
  final EasyRefreshController refreshController;
  final bool enablePullDown;
  final bool enablePullUp;
  final String? noDataText;
  final String? headerText;
  final bool showHeaderText;
  final double headerTopSpace;

  const PullOrRefreshEasy(
      {Key? key,
      required this.child,
      required this.refreshController,
      this.onRefresh,
      this.onLoading,
      this.enablePullDown = true,
      this.enablePullUp = true,
      this.noDataText,
      this.headerText,
      this.showHeaderText = true,
      this.headerTopSpace = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      callRefreshOverOffset: headerTopSpace,
      triggerAxis: Axis.vertical,
      header: ClassicHeader(
          showMessage: false,
          showText: false,
          textStyle: const TextStyle(fontSize: 14, color: Color(0xff007FDD)),
          pullIconBuilder: (context, state, __) {
            if (state.mode == IndicatorMode.drag) {
              return const CupertinoActivityIndicator();
            }
            return const CupertinoActivityIndicator();
          }),
      footer: ClassicFooter(
        infiniteOffset: pt(40),
        triggerOffset: pt(40),
        showMessage: false,
        spacing: 4,
        textStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        noMoreText: noDataText ?? '暂无更多',
        dragText: '下拉加载',
        armedText: '释放加载',
        readyText: '加载中...',
        processingText: '加载中...',
        processedText: '加载完成',
        failedText: '加载失败',
        pullIconBuilder: (context, _, __) {
          switch (_.result) {
            case IndicatorResult.noMore:
              return const Icon(
                Icons.sentiment_satisfied,
                size: 16,
                color: Colors.grey,
              );
            case IndicatorResult.fail:
              return const Icon(
                size: 16,
                Icons.sentiment_very_dissatisfied,
                color: Colors.grey,
              );

            case IndicatorResult.none:
              return const Icon(
                size: 16,
                Icons.sentiment_very_dissatisfied,
                color: Colors.grey,
              );

            default:
              return const Icon(
                size: 16,
                Icons.check_circle,
                color: Colors.grey,
              );
          }
        },
      ),
      controller: refreshController,
      onRefresh: onRefresh,
      onLoad: onLoading,
      child: child,
    );
  }
}
