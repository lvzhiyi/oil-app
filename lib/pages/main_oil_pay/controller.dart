import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/main_oil_pay/service/oil_order_service.dart';
import 'package:oil_business_app/widgets/common/page_loading.dart';

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
      emit(state.copyWith(pageStatus: PageStatus.loading));
      final response =
          await oilOrderService.getOilStoreList(page: 1, pageSize: 10);

      emit(state.copyWith(
          depotList: response.list,
          pageStatus: response.list?.isEmpty ?? true
              ? PageStatus.empty
              : PageStatus.success));
    } catch (e) {
      emit(state.copyWith(pageStatus: PageStatus.error));
    }
  }

  /// 刷新列表
  Future<void> refresh() async {
    await getOilStoreList(isRefresh: true);
  }

  /// 加载更多
  Future<void> loadMore() async {
    if (state.currentPage >= (state.total)) {
      return; // 已加载全部数据
    }
    await getOilStoreList(isRefresh: false);
  }
}

final oilPayCtrl = OilPayCtrl();
