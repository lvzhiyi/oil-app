import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottery_app/global/events.dart';
import 'package:lottery_app/pages/dashboard/model/dashboard_type.dart';
import 'package:lottery_app/pages/dashboard/state.dart';
import 'package:lottery_app/router/routes.dart';

import ' service/dashboard_service.dart';

class DashboardCtrl extends Cubit<DashboardState> {
  DashboardCtrl()
      : super(
          DashboardState(),
        ) {
    initState();
  }

  final refreshController = EasyRefreshController();

  initState() async {
    // 初始化仪表盘数据
    await loadDashboardData();
    globalTabChangeEventBus.on<int>().listen((event) {
      if (event == 0) {
        loadDashboardData();
      }
    });
  }

  /// 加载仪表盘数据
  Future<void> loadDashboardData() async {
    emit(state.copyWith(isLoading: true));

    try {
      final dashboardData = await dashboardService.getDashboardData();
      final dashboardTrends = await dashboardService.getDashboardTrends(
        DateTime.now()
            .subtract(const Duration(days: 7))
            .millisecondsSinceEpoch
            .toString(),
        DateTime.now()
            .subtract(const Duration(days: 1))
            .millisecondsSinceEpoch
            .toString(),
      );
      AccountStats stats = AccountStats(
        todayGiftCount: dashboardData.data.today,
        cumulativeGiftCount: dashboardData.data.total,
      );

      /// 最近7天赠送趋势
      /// 如果数据长度小于7天，则补全数据
      /// 如果数据长度大于7天，则截取前7天
      // final _recentGiftTrend = <DashboardTrendsDataItem>[];
      // if (dashboardTrends.data.length < 7) {
      //   for (int i = 0; i < 7; i++) {
      //     final _item = dashboardTrends.data.length > i
      //         ? DashboardTrendsDataItem(
      //             date: DateFormat('MM-dd')
      //                 .format(DateTime.parse(dashboardTrends.data[i].date)),
      //             count: dashboardTrends.data[i].count,
      //           )
      //         : DashboardTrendsDataItem(
      //             date: DateFormat('MM-dd').format(
      //               DateTime.now().subtract(Duration(days: i + 1)),
      //             ),
      //             count: 0,
      //           );
      //     _recentGiftTrend.add(_item);
      //   }
      // }

      emit(state.copyWith(
        isLoading: false,
        isDataLoaded: true,
        accountStats: stats,
        recentGiftTrend: dashboardTrends.data
            .map((e) => DashboardTrendsDataItem(
                  date: DateFormat('MM-dd').format(DateTime.parse(e.date)),
                  count: e.count,
                ))
            .toList(),
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      ));
    }
  }

  /// 刷新数据
  Future<void> refreshData() async {
    await loadDashboardData();
  }

  /// 导航到余额充值页面
  void navigateToBalanceRecharge(BuildContext context) {
    context.push(AppPage.unifiedPaymentPage.path);
  }

  /// 导航到彩票套餐购买页面
  void navigateToLotteryPackage(BuildContext context) {
    context.push(AppPage.unifiedPaymentPage.path);
  }

  /// 导航到赠送彩票页面
  void navigateToGiftLottery(BuildContext context) {
    context.push(AppPage.giftLotteryPage.path);
  }

  /// 导航到赠送记录页面
  void navigateToGiftRecords(BuildContext context) {
    context.push(AppPage.giftRecordsPage.path);
  }
}
