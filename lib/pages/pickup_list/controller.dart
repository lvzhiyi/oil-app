import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/pickup_list/state.dart';
import 'package:oil_business_app/pages/oil_pickup/service/oil_pickup_service.dart';
import 'package:oil_business_app/utils/log.dart';

class PickupListCtrl extends Cubit<PickupListState> {
  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  final int _pageSize = 10;

  PickupListCtrl() : super(PickupListState()) {
    initData();
  }

  void initData() {
    loadData(refresh: true);
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
    loadData(refresh: true);
  }

  /// 加载数据
  Future<void> loadData({bool refresh = false}) async {
    if (state.isLoading) return;

    try {
      final page = refresh ? 1 : state.page;
      
      if (refresh) {
        emit(state.copyWith(isLoading: true, errorMessage: null));
      }

      // 根据标签索引确定状态筛选条件
      // tabIndex 0: 待提油 (pending_pickup)
      // tabIndex 1: 已完成 (completed)
      final status = state.tabIndex == 0 ? 'pending_pickup' : 'completed';

      final response = await oilPickupService.getWithdrawOrderList(
        status: status,
        page: page,
        pageSize: _pageSize,
      );

      final list = response.list ?? [];
      final hasMore = list.length >= _pageSize;

      if (refresh) {
        emit(state.copyWith(
          orderList: list,
          page: page + 1,
          hasMore: hasMore,
          isLoading: false,
        ));
        refreshController.finishRefresh();
        refreshController.resetFooter();
      } else {
        emit(state.copyWith(
          orderList: [...state.orderList, ...list],
          page: page + 1,
          hasMore: hasMore,
          isLoading: false,
        ));
        refreshController.finishLoad(hasMore ? IndicatorResult.success : IndicatorResult.noMore);
      }
    } catch (e) {
      l.e('PickupListCtrl', '加载提油列表失败: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
      if (refresh) {
        refreshController.finishRefresh(IndicatorResult.fail);
      } else {
        refreshController.finishLoad(IndicatorResult.fail);
      }
    }
  }
}

