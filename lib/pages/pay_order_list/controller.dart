import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/pay_order_list/service/pay_order_list.dart';
import 'package:oil_business_app/pages/pay_order_list/state.dart';
import 'package:oil_business_app/widgets/common/page_loading.dart';

import 'model/orders_data.dart';

class PayOrderListCtrl extends Cubit<PayOrderListState> {
  PayOrderListCtrl()
      : super(
          PayOrderListState(),
        ) {
    initState();
  }

  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  int pageNum = 1;
  int total = 0;
  int pageSize = 10;

  initState() async {
    getOrderList();
  }

  /// 加载更多
  void onLoading() async {
    if (state.orderList.length >= total) {
      refreshController.finishLoad(IndicatorResult.noMore);
      return;
    }
    pageNum++;
    await getOrderList(loadMore: true);
    refreshController.finishLoad(IndicatorResult.success);
    emit(state.copyWith(
      orderList: pageNum == 1
          ? state.orderList
          : [...state.orderList, ...state.orderList],
      pageStatus: PageStatus.success,
    ));
  }

  /// 刷新
  void onRefresh() async {
    pageNum = 1;
    await getOrderList(onRefresh: true);
    refreshController.finishRefresh(IndicatorResult.success);
  }

  /// 加载记录列表
  Future<OrderListResponse> getOrderList(
      {bool loadMore = false, bool onRefresh = false}) async {
    try {
      if (!onRefresh && !loadMore) {
        emit(state.copyWith(pageStatus: PageStatus.loading));
      }
      OrderListResponse? response;

      response = await payOrderListService.getOrderList(
          page: pageNum, pageSize: pageSize);

      final List<OrderModel> newRecords = response.list ?? [];
      total = response.total ?? 0;

      /// 加载下一页统一在外部处理新的列表
      if (!loadMore) {
        emit(state.copyWith(
          orderList: newRecords,
          pageStatus: PageStatus.success,
        ));
      }

      if (response.list?.isEmpty ?? true) {
        emit(state.copyWith(pageStatus: PageStatus.empty));
      }

      return response;
    } catch (e) {
      print(e);
      emit(state.copyWith(pageStatus: PageStatus.error));
      pageNum = 1;
      return OrderListResponse(list: [], total: 0);
    }
  }
}
