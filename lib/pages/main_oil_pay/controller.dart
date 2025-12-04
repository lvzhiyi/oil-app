import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/pages/main_oil_pay/model/oil_order_res.type.dart';
import 'package:oil_business_app/pages/main_oil_pay/service/oil_order_service.dart';
import 'package:oil_business_app/widgets/common/page_loading.dart';

import 'state.dart';

class OilPayCtrl extends Cubit<MainOilPayState> {
  OilPayCtrl() : super(MainOilPayState()) {
    initState();
  }

  initState() async {
    getOilStoreList();
  }

  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  int pageNum = 1;
  int total = 0;
  int pageSize = 10;

  /// 获取油库列表
  /// [isRefresh] 是否为刷新操作，true表示刷新，false表示加载更多
  Future<GetOilStoreResponse> getOilStoreList(
      {bool loadMore = false, bool onRefresh = false}) async {
    try {
      if (!onRefresh && !loadMore) {
        if (!isClosed) {
          emit(state.copyWith(pageStatus: PageStatus.loading));
        }
      }
      final response = await oilOrderService.getOilStoreList(
        page: pageNum,
        pageSize: pageSize,
      );

      if (!isClosed) {
        emit(state.copyWith(
            depotList: response.list,
            pageStatus: response.list?.isEmpty ?? true
                ? PageStatus.empty
                : PageStatus.success));
      }
      return response;
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(pageStatus: PageStatus.error));
      }
      return GetOilStoreResponse(list: [], total: 0);
    }
  }

  /// 加载更多
  void onLoading() async {
    if (state.depotList.length >= total) {
      refreshController.finishLoad(IndicatorResult.noMore);
      return;
    }
    pageNum++;
    final response = await getOilStoreList(loadMore: true);
    if (!isClosed) {
      refreshController.finishLoad(IndicatorResult.success);
      emit(state.copyWith(
          depotList: pageNum == 1
              ? state.depotList
              : [...state.depotList, ...response.list ?? []],
          pageStatus: PageStatus.success));
    }
  }

  /// 刷新
  void onRefresh() async {
    pageNum = 1;
    await getOilStoreList(onRefresh: true);
    if (!isClosed) {
      refreshController.finishRefresh(IndicatorResult.success);
    }
  }
}

final oilPayCtrl = OilPayCtrl();
