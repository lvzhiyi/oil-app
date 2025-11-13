import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/main_oil_pay/model/oil_order_res.type.dart';
import 'package:oil_business_app/pages/main_oil_pay/service/oil_order_service.dart';

import 'state.dart';

class OilPayCtrl extends Cubit<MainOilPayState> {
  OilPayCtrl() : super(MainOilPayState()) {
    initState();
  }

  initState() async {
    await getOilStoreList(isRefresh: true);
  }

  /// 获取油库列表
  /// [isRefresh] 是否为刷新操作，true表示刷新，false表示加载更多
  Future<void> getOilStoreList({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        emit(state.copyWith(isLoading: true, errorMessage: null));
      } else {
        emit(state.copyWith(isLoadingMore: true));
      }

      final page = isRefresh ? 1 : state.currentPage + 1;
      final response =
          await oilOrderService.getOilStoreList(page: page, pageSize: 10);

      if (response.list != null) {
        final List<Depot> newList = isRefresh
            ? response.list!
            : [...(state.depotList ?? []), ...response.list!];

        emit(state.copyWith(
          depotList: newList,
          isLoading: false,
          isLoadingMore: false,
          currentPage: page,
          total: response.total ?? 0,
          errorMessage: null,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          errorMessage: '暂无数据',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: e.toString(),
      ));
    }
  }

  /// 刷新列表
  Future<void> refresh() async {
    await getOilStoreList(isRefresh: true);
  }

  /// 加载更多
  Future<void> loadMore() async {
    if (state.isLoadingMore) return;
    if (state.depotList != null && state.depotList!.length >= (state.total)) {
      return; // 已加载全部数据
    }
    await getOilStoreList(isRefresh: false);
  }
}

final oilPayCtrl = OilPayCtrl();
