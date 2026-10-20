import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/config/config.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/pages/main_oil_pay/model/oil_order_res.type.dart';
import 'package:oil_business_app/pages/main_oil_pay/service/oil_order_service.dart';
import 'package:oil_business_app/widgets/common/page_loading.dart';
import 'package:oil_business_app/widgets/popup/dialog.dart';

import 'state.dart';

class OilPayCtrl extends Cubit<MainOilPayState> {
  OilPayCtrl() : super(MainOilPayState()) {
    initState();
  }
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  initState() async {
    _subscribeNetworkStateChange();
  }

  _subscribeNetworkStateChange() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) async {
      result = await (Connectivity().checkConnectivity());
      print('result: $result');
      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {
        await BaseConfig.appContext
            ?.read<AppController>()
            .checkStartupProcess();
        getOilStoreList();

        SportsDialog.dismiss();

        /// 执行完所有初始化操作后，需要取消事件监听
        _unSubscribeNetworkStateChange();
      } else {
        // await SportsDialog.show(
        //   title: '需要网络权限',
        //   bodyText: '请在系统设置中为本应用开启网络权限并保持网络连接。',
        //   cancelText: '退出应用',
        //   okText: '去设置',
        //   clickMaskDismiss: false,
        //   showClose: false,
        //   onCancel: () {
        //     exitApp();
        //   },
        //   onOk: () async {
        //     try {
        //       // 打开应用设置页面，引导用户开启网络权限/网络访问
        //       await openAppSettings();
        //     } catch (e) {
        //       l.e('AppController', '打开系统设置失败: $e');
        //     }
        //   },
        // );
      }
    });
  }

  _unSubscribeNetworkStateChange() {
    _connectivitySubscription.cancel();
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
