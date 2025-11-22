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
  StationListCtrl() : super(StationListState(stations: [])) {
    initState();
  }

  void initState() async {
    emit(state.copyWith(isLoading: true));
    try {
      // 调用真实 API 获取加油站数据
      // 只获取已激活的加油站（YAGNI 原则，仅实现当前需求）
      final response = await appController.getStationStatus(1, 10);

      // 直接使用 Station 模型
      final stations = response.list ?? [];

      emit(state.copyWith(
        stations: stations,
        isLoading: false,
        hasError: false,
      ));
    } catch (e) {
      l.e('StationListCtrl', '加载加油站列表失败: $e');
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
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
