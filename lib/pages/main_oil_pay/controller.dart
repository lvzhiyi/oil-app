import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/main_oil_pay/service/oil_order_service.dart';

import 'state.dart';

class OilPayCtrl extends Cubit<MainOilPayState> {
  OilPayCtrl() : super(MainOilPayState()) {
    initState();
  }

  initState() async {
    getOilStoreList(isRefresh: true);
  }

  /// 获取油库列表
  /// [isRefresh] 是否为刷新操作，true表示刷新，false表示加载更多
  Future<void> getOilStoreList({bool isRefresh = false}) async {
    try {
      emit(state.copyWith(isLoading: true));
      final response =
          await oilOrderService.getOilStoreList(page: 1, pageSize: 10);

      emit(state.copyWith(depotList: response.list));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
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
