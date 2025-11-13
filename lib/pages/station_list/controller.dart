import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/global/enum/common.dart';
import 'package:oil_business_app/global/model/station_res_type.dart';
import 'package:oil_business_app/models/station_model.dart';
import 'package:oil_business_app/pages/station_list/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';

class StationListCtrl extends Cubit<StationListState> {
  StationListCtrl() : super(StationListState(stations: [])) {
    initState();
  }

  /// 将 Station 转换为 StationModel
  /// 遵循 KISS 原则，直接映射字段
  StationModel _convertToStationModel(Station station) {
    return StationModel(
      id: station.id?.toString() ?? '',
      name: station.stationName ?? '',
      address: _buildFullAddress(station),
      latitude: null, // API 暂未返回坐标信息
      longitude: null,
      isActive: station.status == StationStatus.active,
    );
  }

  /// 构建完整地址
  /// 遵循 DRY 原则，避免地址拼接逻辑重复
  String _buildFullAddress(Station station) {
    final parts = [
      station.provinceName,
      station.cityName,
      station.areaName,
      station.addressDetail,
    ].where((part) => part != null && part.isNotEmpty);
    return parts.join('');
  }

  void initState() async {
    emit(state.copyWith(isLoading: true));
    try {
      // 调用真实 API 获取加油站数据
      // 只获取已激活的加油站（YAGNI 原则，仅实现当前需求）
      final response = await appController.getStationStatus();

      // 转换数据模型
      final stations = (response.list ?? [])
          .map((station) => _convertToStationModel(station))
          .toList();

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

  void selectStation(StationModel station, BuildContext context) {
    appController.setSelectedStation(station);
    BaseRouter.pop(result: station);
  }

  void navigateToEdit(StationModel station, BuildContext context) {
    BaseRouter.push(
      url: AppPage.stationEditPage.path,
      extra: {'stationId': station.id},
    );
  }

  void updateStation(StationModel station) {
    final updated = state.stations.map((s) {
      return s.id == station.id ? station : s;
    }).toList();
    emit(state.copyWith(stations: updated));
  }
}

