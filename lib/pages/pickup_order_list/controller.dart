import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/pickup_order_list/state.dart';
import 'package:oil_business_app/pages/oil_pickup/service/oil_pickup_service.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/widgets/popup/toast.dart';

class PickupOrderListCtrl extends Cubit<PickupOrderListState> {
  static const int _pageSize = 10;
  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  PickupOrderListCtrl() : super(PickupOrderListState()) {
    onRefresh();
  }

  Future<void> onRefresh() async {
    if (state.isLoading) return;

    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      page: 1,
      hasMore: true,
    ));

    await _loadData(isRefresh: true);
  }

  Future<void> onLoadMore() async {
    await _loadData(isRefresh: false);
  }

  /// 切换标签
  void switchTab(int index) {
    if (state.tabIndex == index) return;
    emit(state.copyWith(
      tabIndex: index,
      orderList: [],
      page: 1,
      hasMore: true,
      errorMessage: null,
    ));
    onRefresh();
  }

  /// 加载数据
  Future<void> _loadData({required bool isRefresh}) async {
    try {
      final page = isRefresh ? 1 : state.page + 1;

      // 根据标签索引确定状态筛选条件
      // tabIndex 0: 待提油 (pending_pickup)
      // tabIndex 1: 已完成 (completed)
      // tabIndex 2: 已取消 (cancelled)
      final status = state.tabIndex == 0
          ? 'pending_pickup'
          : state.tabIndex == 1
              ? 'completed'
              : 'cancelled';

      final response = await oilPickupService.getWithdrawOrderList(
        status: status,
        page: page,
        pageSize: _pageSize,
      );

      final list = response.list ?? [];
      final hasMore = list.length >= _pageSize;

      if (isRefresh) {
        emit(state.copyWith(
          orderList: list,
          page: page,
          hasMore: hasMore,
          isLoading: false,
          isLoadingMore: false,
        ));
        refreshController.finishRefresh();
        refreshController.resetFooter();
      } else {
        emit(state.copyWith(
          orderList: [...state.orderList, ...list],
          page: page,
          hasMore: hasMore,
          isLoading: false,
          isLoadingMore: false,
        ));
        refreshController.finishLoad(
            hasMore ? IndicatorResult.success : IndicatorResult.noMore);
      }
    } catch (e) {
      l.e('PickupOrderListCtrl', '加载提油订单列表失败: $e');
      emit(state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: e.toString(),
      ));

      if (isRefresh) {
        refreshController.finishRefresh(IndicatorResult.fail);
      } else {
        refreshController.finishLoad(IndicatorResult.fail);
      }
    }
  }

  /// 取消订单
  Future<bool> cancelOrder(int withdrawId) async {
    try {
      await oilPickupService.cancelWithdraw(withdrawId);
      SportsToast.showSuccess('订单已取消');
      // 刷新列表
      await onRefresh();
      return true;
    } catch (e) {
      l.e('PickupOrderListCtrl', '取消订单失败: $e');
      SportsToast.showWarning('取消失败，请重试');
      return false;
    }
  }

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }
}
