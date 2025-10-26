import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:lottery_app/resources/colors.dart';
import 'package:lottery_app/utils/pt.dart';
import 'package:lottery_app/widgets/common/hidden_scroll_behavior.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

typedef OnRefresh = void Function();
typedef OnLoading = void Function();

final _headerText = <RefreshStatus, String>{
  RefreshStatus.idle: '下拉刷新',
  RefreshStatus.canRefresh: '释放可刷新',
  RefreshStatus.refreshing: '加载中...',
};

class PullOrRefresh extends HookWidget {
  final Widget child;
  final void Function()? onRefresh;
  final void Function()? onLoading;
  final RefreshController refreshController;
  final bool enablePullDown;
  final bool enablePullUp;
  final String? noDataText;
  final String? headerText;
  final bool showHeaderText;
  final double headerTopSpace;

  const PullOrRefresh(
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
      this.headerTopSpace = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scaleController = useAnimationController(
      initialValue: 0.0,
      upperBound: 1.0,
    );

    return SmartRefresher(
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      header: CustomHeader(
        height: pt(50) + headerTopSpace,
        refreshStyle: RefreshStyle.Follow,
        onOffsetChange: (offset) {
          if (refreshController.headerMode?.value != RefreshStatus.refreshing) {
            scaleController.value = offset / 25;
          }
        },
        builder: (BuildContext context, RefreshStatus? status) {
          return ScrollConfiguration(
            behavior: HiddenScrollBehavior(),
            child: SizeTransition(
              sizeFactor: scaleController,
              child: FadeTransition(
                opacity: scaleController,
                child: Column(
                  children: [
                    SizedBox(
                      height: pt(headerTopSpace),
                    ),
                    AnimatedAlign(
                      alignment: Alignment.topCenter,
                      duration: const Duration(
                        microseconds: 300,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const CupertinoActivityIndicator(),
                            SizedBox(width: pt(6)),
                            Text(
                              _headerText[status] ?? 'Refreshing...',
                              style: TextStyle(
                                color: AppColors.darkBlue,
                                fontSize: pt(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(
                      pt(12),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      footer: ClassicFooter(
        idleIcon: Container(),
        loadingIcon: Container(),
        canLoadingIcon: Container(),
        spacing: 0,
        height: pt(20),
        loadingText: '加载中...',
        canLoadingText: '上拉加载更多',
        noDataText: noDataText ?? '没有更多了',
        idleText: '上拉加载',
        textStyle: TextStyle(
          color: Colors.grey,
          fontSize: pt(14),
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal,
        ),
      ),
      controller: refreshController,
      onRefresh: () {
        if (onRefresh != null) {
          onRefresh!();
        }
      },
      onLoading: () {
        if (onLoading != null) {
          onLoading!();
        }
      },
      child: child,
    );
  }
}
