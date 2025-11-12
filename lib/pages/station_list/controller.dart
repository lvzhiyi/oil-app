import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oil_business_app/global/app_controller.dart';
import 'package:oil_business_app/models/station_model.dart';
import 'package:oil_business_app/pages/station_list/state.dart';
import 'package:oil_business_app/router/router.dart';
import 'package:oil_business_app/router/routes.dart';
import 'package:oil_business_app/utils/log.dart';

class StationListCtrl extends Cubit<StationListState> {
  StationListCtrl() : super(StationListState(stations: _mockStations)) {
    initState();
  }

  static final List<StationModel> _mockStations = [
    StationModel(
      id: '1',
      name: '中石化北京朝阳加油站',
      address: '北京市朝阳区建国路88号',
      latitude: 39.9042,
      longitude: 116.4074,
    ),
    StationModel(
      id: '2',
      name: '中石油上海浦东加油站',
      address: '上海市浦东新区世纪大道1000号',
      latitude: 31.2304,
      longitude: 121.4737,
    ),
    StationModel(
      id: '3',
      name: '中海油广州天河加油站',
      address: '广州市天河区天河路123号',
      latitude: 23.1291,
      longitude: 113.2644,
    ),
    StationModel(
      id: '4',
      name: '中石化深圳南山加油站',
      address: '深圳市南山区科技园南路2001号',
      latitude: 22.5431,
      longitude: 113.9344,
    ),
  ];

  void initState() async {
    emit(state.copyWith(isLoading: true));
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      emit(state.copyWith(
        stations: _mockStations,
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

