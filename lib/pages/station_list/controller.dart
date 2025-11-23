import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/pages/station_list/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';
import 'package:oil_business_app/utils/station_extension.dart';

class StationListCtrl extends Cubit<StationListState> {
  static const int _pageSize = 10;
  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  StationListCtrl() : super(StationListState(stations: [])) {
    onRefresh();
  }

  Future<void> onRefresh() async {
    // Don't block if already loading, EasyRefresh handles debounce usually, but good to be safe.
    // However, for initial load we might want to show full screen loading.
    if (state.stations.isEmpty) {
      emit(state.copyWith(isLoading: true, hasError: false));
    }
    
    await _loadData(isRefresh: true);
  }

  Future<void> onLoadMore() async {
    await _loadData(isRefresh: false);
  }

  Future<void> _loadData({required bool isRefresh}) async {
    try {
      final pageToLoad = isRefresh ? 1 : state.page + 1;
      
      // 调用真实 API 获取加油站数据
      final response = await appController.getStationStatus(pageToLoad, _pageSize);

      final newStations = response.list ?? [];
      final hasMore = newStations.length >= _pageSize;

      List<Station> finalStations;
      if (isRefresh) {
        finalStations = newStations;
        refreshController.finishRefresh();
        refreshController.resetFooter();
      } else {
        finalStations = [...state.stations, ...newStations];
        refreshController.finishLoad(hasMore ? IndicatorResult.success : IndicatorResult.noMore);
      }

      emit(state.copyWith(
        stations: finalStations,
        isLoading: false,
        hasError: false,
        page: pageToLoad,
        hasMore: hasMore,
      ));
    } catch (e) {
      l.e('StationListCtrl', '加载加油站列表失败: $e');
      
      if (isRefresh) {
        refreshController.finishRefresh(IndicatorResult.fail);
      } else {
        refreshController.finishLoad(IndicatorResult.fail);
      }

      emit(state.copyWith(
        isLoading: false,
        hasError: true, // Only meaningful for full page error or toast
        errorMessage: e.toString(),
      ));
    }
  }

  void selectStation(Station station, BuildContext context) {
    appController.setSelectedStation(station);
    BaseRouter.pop(result: station);
  }

  void navigateToEdit(Station station, BuildContext context) {
    BaseRouter.push(
      url: AppPage.stationEditPage.path,
      extra: {'stationId': station.idString},
    );
  }

  /// 跳转到新增加油站页面
  /// 遵循 KISS 原则，不传递 stationId 即为新增模式
  void navigateToAdd(BuildContext context) {
    BaseRouter.push(url: AppPage.stationEditPage.path);
  }

  void updateStation(Station station) {
    final updated = state.stations.map((s) {
      return s.id == station.id ? station : s;
    }).toList();
    emit(state.copyWith(stations: updated));
  }
}
